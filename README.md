<div class="fluid-row" id="header">
    <img src='./misc/img.png' height='150' width='auto' align='right'>
    <h1 class="title toc-ignore">Easy Reference Evapotranspiration</h1>
    <h4 class="author"><em>Daniel Althoff</em></h4>
</div>

# About

Easy Reference Evapotranspiration (Easy-ETo) is a ShinyApp used to compute reference evapotranspiration. This tutorial is on how to use the Easy-ETo app online or with R.

# Release History

* 1.0.0
    * Upload climatic data to Easy-ETo and download reference evapotranspiration data
    * Two options of data visualization

# How to use

<h4>1. Open the <b>Easy-ETo</b> app</h4>
<h6>With ShinyApp</h6>
<p>Access the <a href="https://daniel-althoff.shinyapps.io/easy-eto/" target="blank">Easy-ETo</a> app directly in shinyapps.io.</p>

<h6>With R</h6>
<p>Install the required packages and run the <b>Easy-ETo</b> app</p>

```{r setup}
if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, readxl, writexl, dplyr, tidyr,  ggplot2, ggpmisc, lubridate, hydroGOF, update=F)

runGitHub("Easy-ETo", "danielalthoff")
```

<img src="./misc/app_1.png"
     style="float: left; margin-right: 10px;" />
    
<h4>2. Provide the location <b>latitude</b> and <b>altitude</b></h4>
<p> Latitude should be in decimal (-90 to 90) and altitude in meters (> 0).<br>
    For this tutorial, we used the sample data available as <a href="https://github.com/danielalthoff/Easy-ETo/raw/master/Sample.xlsx" target="blank">template</a>. This dataset was retrieved from the Brazilian National Institute of Meteorology (INMET)'s database (<a href="http://www.inmet.gov.br/portal/index.php?r=estacoes/estacoesConvencionais" target='blank'>BA - BARRA: WMO id. 83179)</a>) and went through minimal pre-processing.<br>
    The station's corresponding latitude and altitude are -11.08° and 407.5 meters, respectively</p> 

<h4>3. Prepare your Excel (.xlsx) file</h4>
<p> Download the <a href="https://github.com/danielalthoff/Easy-ETo/raw/master/Sample.xlsx" target="blank">template</a> as a referente<br>
    Your excel file should look like this:</p>

<img src="./misc/app_2.png"
     style="float: left; margin-right: 10px;" />
     
<p>Make sure your variables are in the following units:</p>
<ul>
  <li>Tmax, Tmean, Tmin = Maximum, mean and minimum daily air temperatura (°C);</li>
  <li>Relative humidity (%);</li>
  <li>Wind speed at 10 m above ground (m/s);</li>
  <li>Solar radiation (MJ/m²/d);</li>
    <li>Date (dd/mm/yyyy).</li>
</ul>



<h4>3. Upload a new table asset</h4>



<h4>Enjoy!</h4>
:smile:


