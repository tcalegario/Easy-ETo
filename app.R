library(shiny)
library(pacman)
library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)
library(ggpmisc)
library(lubridate)
library(hydroGOF)
library(writexl)

# Define UI for app that draws a histogram ----

ETo_diario_calc <- function(tmed, tmax, tmin, urmed, rad, vmed, lat, alt, date) {
  lat <- lat*pi/180
  J <- as.numeric(format(date, "%j"))
  dr <- 1+0.033*cos(2*pi*J/365)
  gamma <- 0.409*sin(2*pi*J/365-1.39)
  ws <- acos(-tan(lat)*tan(gamma))
  Rg <- 24*60/pi*0.0820*dr*(ws*sin(lat)*sin(gamma)+cos(lat)*cos(gamma)*sin(ws))
  P <- 101.3*((293-0.0065*alt)/293)^5.26 
  p <- 1013 
  lamb <- 2.45 
  eoTmax <- as.data.frame(0.6108*exp((17.27*tmax)/(tmax+237.3)))
  eoTmin <- as.data.frame(0.6108*exp((17.27*tmin)/(tmin+237.3)))
  es <- as.data.frame((eoTmax+eoTmin)/2) 
  ea <- (urmed*(eoTmax+eoTmin)/2)/100
  for (i in 1:nrow(ea)){
    if (ea[i,] > es[i,]) (ea[i,] <- es[i,])
  }
  
  delta <- as.data.frame(4098*es/((tmed+237.3)^2)) 
  psi <- 0.665*10^(-3)*P
  albedo <- 0.23
  Rns <- as.data.frame((1-albedo)*rad)
  Rso <- (0.75+(2*10^-5)*alt)*Rg
  Rnl <- 4.903*10^(-9)*(((tmax+273.15)^4+(tmin+273.15)^4)/2)*(0.34-0.14*sqrt(ea))*(1.35*rad/Rso-0.35)
  Rn <- Rns-Rnl
  u2 <- (vmed*4.87/(log(67.8*10-5.42))) %>% tbl_df()
  ETo <- (0.408*delta*Rn+psi*(900/(tmed+273))*u2*(es-ea))/(delta+psi*(1+0.34*u2))
  names(ETo) <- 'ETo'
  ETo <- ETo %>% mutate(Date = date,
                        HS = 0.0023*((tmax-tmin)^0.5)*(tmed+17.8)*Rg/2.45,
                        PT = as.numeric(unlist(1.26*(delta/(delta+psi))*Rn/2.45)))
}
MBE_text = function(df){
  names(df)<-c('vobs', 'vpred');
  m = hydroGOF::me.default(sim = df$vpred, obs = df$vobs);
  m = sprintf('%.2f',m)
  eq <- substitute(~~MBE~"="~m~"(mm day"^-1*")")
  as.character(as.expression(eq)); 
}
MAE_text = function(df){
  names(df)<-c('vobs', 'vpred');
  m = hydroGOF::mae(sim = df$vpred, obs = df$vobs);
  m = sprintf('%.2f',m)
  eq <- substitute(~~MAE~"="~m~"(mm day"^-1*")")
  as.character(as.expression(eq)); 
}
RMSE_text = function(df){
  names(df)<-c('vobs', 'vpred');
  m = hydroGOF::rmse(sim = df$vpred, obs = df$vobs);
  m = sprintf('%.2f',m)
  eq <- substitute(~~RMSE~"="~m~"(mm day"^-1*')')
  as.character(as.expression(eq)); 
}

ui <- fluidPage(
  
  # App title ----
  titlePanel("Welcome to Easy Reference Evapotranspiration!"),
  # Sidebar layout with input and output definitions ----
  fluidRow(
    column(3,
    # Sidebar panel for inputs ----
    wellPanel(
      tags$div(
        'Please check the tutorial at:', 
        tags$br(), 
        tags$a(href='https://github.com/danielalthoff/Easy-ETo', "Easy-ETo")),
      
      tags$div(h6('Try our ', 
                  tags$a(href='https://github.com/danielalthoff/Easy-ETo/raw/master/Sample.xlsx', "template"),
                  '(use Latitude = -11.08, and Altitude = 407.5)')),
      
      # Input: Excel file, latitude and longitude ----
      tags$br(),
      
      h4(tags$b('Location')),
      
      numericInput('lat', 'Latitude (decimal, -90 to 90)', 0, min=-100, max=100),
      
      numericInput('alt', 'Altitude (meters)', 0, min=0, max=5000),
      
      tags$br(),
      
      h4(tags$b('Load data')),
      
      tags$small(
        'Make sure data are in the following units:', tags$br(),
        '- Date (day/month/year)', tags$br(),
        '- Air temperature (C)', tags$br(),
        '- Relative humidity (%)', tags$br(),
        '- Wind speed at 10 m (m/s)', tags$br(),
        '- Solar radiation (MJ/m2/d)',tags$br()),
      
      tags$br(),
      
      fileInput("file1", "Choose Excel file (.xlsx)",
                accept = c(".xlsx"))
      
    )
    ),
    
    # Main panel for displaying outputs ----
    column(9,
      wellPanel(
        div(style='height: 36px',
            radioButtons("radio", "Choose output",
                     choices = list("Data summary" = 'sum', "Compare ETo methods" = 'eto'), 
                     inline = T,
                     selected = 'sum'),
            uiOutput('download'))),
      
      hr(),
      
      mainPanel(
      # Output: plots ----
      plotOutput(outputId = "Plot1", height = '275px', width='135%'),
      plotOutput(outputId = "Plot2", height = '200px', width='135%')
      
      
      )
      
      
    )
  )
)



# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  vars_Clima <- reactive({
    req(input$file1, file.exists(input$file1$datapath))
    data = readxl::read_xlsx(input$file1$datapath) %>% gather(Var, Valor, -Date)
    data$Var <- factor(data$Var, 
                       levels = c('Tmax', 'Tmean', 'Tmin', 'SR', 'RH', 'u10'),
                       labels=c(expression(paste("Max. air temperature ("^o,"C)")),
                                expression(paste("Mean air temperature ("^o,"C)")),
                                expression(paste("Min. air temperature ("^o,"C)")),
                                expression(paste('Solar radiation (MJ m'^-2,' day'^-1,')')),
                                expression(paste('Relative humidity (%)')),
                                expression(paste('Wind speed at 10 m (m s'^-1,')'))))
    data['Meses'] <- factor(month(data$Date),
                            levels = 1:12,
                            labels = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
    return(data)
  })
  
  vars_ETo <- reactive({
    req(input$file1, file.exists(input$file1$datapath))
    data = readxl::read_xlsx(input$file1$datapath)
    ETo <- ETo_diario_calc(tmed = data$Tmean, tmax = data$Tmax, 
                           tmin = data$Tmin, urmed = data$RH, 
                           rad = data$SR, vmed = data$u10, 
                           lat = input$lat, alt = input$alt, date = data$Date)
    return(ETo)
  })
  
  mae_rmse <- reactive({
    dados <- vars_ETo() %>% gather(Metodo,Valor,-Date, -ETo)
    MBE_txt <- by(dados[,c(1,4)], dados$Metodo, MBE_text)
    MAE_txt <- by(dados[,c(1,4)], dados$Metodo, MAE_text)
    RMSE_txt <- by(dados[,c(1,4)], dados$Metodo, RMSE_text)
    df <- data.frame(MBE_txt = unclass(MBE_txt), 
                     MAE_txt = unclass(MAE_txt), 
                     RMSE_txt=unclass(RMSE_txt), Metodo=names(MAE_txt))
    return(df)
  })
  
  ETo_tempo <- reactive({
    ETo_tempo <- vars_ETo() %>% gather(Var, Valor, -Date)
    ETo_tempo$Var <- factor(ETo_tempo$Var, 
                            levels = c('ETo', 'HS', 'PT'),
                            labels = c("Penman-Monteith",
                                       "Hargreaves-Samani",
                                       "Priestley-Taylor"))
    ETo_tempo['Meses'] <- factor(month(ETo_tempo$Date),
                                 levels = 1:12,
                                 labels = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
    
    return(ETo_tempo)
  })
  
  output$Plot1 <- renderPlot({
    saida <- switch(input$radio,
                    'sum' = 1,
                    'eto' = 2)
    
    if (any(c('Date', 'Var','Valor') %in% names(vars_Clima()))){
      g1 <- ggplot(vars_Clima())+
        geom_boxplot(aes(x=Meses, y=Valor)) +
        facet_wrap(~Var, nrow=2, scales = 'free_y', labeller = label_parsed) +
        stat_summary(aes(x=Meses, y=Valor), fun=mean, colour="red", geom="point", shape=17, show.legend = T) +
        labs(x='', y='Values') +
        theme(text = element_text('serif'), axis.text.x = element_text(angle=45),
              panel.border = element_rect(color='black', fill='transparent'), 
              strip.background = element_blank(), legend.title = element_blank())
      g2 <- ggplot(ETo_tempo())+
        geom_point(aes(x=Date, y=Valor, fill=Var), shape=21) +
        labs(x='', y=expression(paste('ETo (mm day'^-1,')')), subtitle = 'Time-series') +
        expand_limits(y=0) +
        #scale_fill_viridis_d(name='', option='D', direction=1) +
        theme(text = element_text('serif'),
              panel.border = element_rect(color='black', fill='transparent'), 
              strip.background = element_blank(), 
              legend.background = element_rect(color='transparent', fill=alpha('white',0.5)),
              legend.position = c(0.08,0.2),
              legend.title = element_blank())
      if (saida == 1) return(g1) else (g2)
    }
    
  })
  
  output$Plot2 <- renderPlot({
    saida <- switch(input$radio,
                    'sum' = 1,
                    'eto' = 2)

     if (any(c('Date') %in% names(vars_ETo()))){
      
       g2<-ggplot(vars_ETo() %>% gather(Metodo,Valor,-Date, -ETo), aes(x=ETo, y = Valor)) +
         geom_abline(slope=1, intercept=0, lwd=0.5, linetype=2) +
         geom_point(alpha=0.5, shape=21, fill='white',size=1) +
         geom_smooth(method='lm', lwd = 0.75, color='red') +
         geom_smooth(method='lm', lwd = 0.75, color='black', formula = y~x+0) +
         stat_poly_eq(formula = y~x, color='red', aes(label = paste('OLS',stat(eq.label), stat(rr.label), sep = "~\":\"~~")),  
                      eq.with.lhs = "italic(hat(y))~`=`~", parse = TRUE, label.y = 1, size=3) +
         stat_poly_eq(formula = y~x+0, aes(label = paste('FTO :~',stat(eq.label),"italic(x)", sep='~')),
                      eq.with.lhs = "italic(hat(y))~`=`~", parse = TRUE, label.y = 0.85, size=3) +
         labs(x = expression(paste('ETo'[Penman-Monteith],' (mm day'^-1,')')), y = expression(paste('ETo'[Others],' (mm day '^-1,')'))) +
         facet_wrap(~Metodo, nrow=1) + xlim(0,10) + ylim(0,10) + 
         geom_text(data = mae_rmse(), mapping = aes(x = +Inf-.1, y = 3.5, group=NULL,
                                                    label = MBE_txt, family='serif'), size=3, parse=T, hjust=1) +
         geom_text(data = mae_rmse(), mapping = aes(x = +Inf-.1, y = 2, group=NULL,
                                                    label = MAE_txt, family='serif'), size=3, parse=T, hjust=1) +
         geom_text(data = mae_rmse(), mapping = aes(x = +Inf-.1, y = 0.5, group=NULL,
                                                    label = RMSE_txt, family='serif'), size=3, parse=T, hjust=1) +
         theme(text=element_text('serif'), strip.background = element_blank(), 
               panel.border = element_rect(color='black', fill='transparent'))
       
      g1 <- ggplot(ETo_tempo())+
        geom_boxplot(aes(x=Meses, y=Valor, fill=Var)) +
        labs(x='', y=expression(paste('ETo (mm day'^-1,')'))) +
        # facet_wrap(~Var, nrow=1, scales = 'free_y', labeller = label_parsed) +
        stat_summary(aes(x=Meses, y=Valor, group=Var), fun=mean, 
                     colour="red", geom="point", shape=17, position = position_dodge(.75)) +
        expand_limits(y=0) +
        theme(text = element_text('serif'), axis.text.x = element_text(angle=45),
              panel.border = element_rect(color='black', fill='transparent'), 
              strip.background = element_blank(), legend.title = element_blank())
      
      if (saida == 1) return(g1) else return(g2)
    }
    
  })
  
  output$download <- renderUI({
    req(input$file1, file.exists(input$file1$datapath))
    downloadButton('downloadETo', label = 'Download ETo data') })
  
  output$downloadETo <- downloadHandler(
    filename = function() {paste("ETo", ".xlsx", sep='')},
    content = function(file) {write_xlsx(vars_ETo() %>% dplyr::select(Date, ETo, HS, PT),
                          file)}
  )
  
}
shinyApp(ui = ui, server = server)
