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

<p> Download the <a href="https://github.com/danielalthoff/Easy-ETo/raw/master/Sample.xlsx" target="blank">template</a><br>
    Your excel file should look like this:</p>
    
<h4>2. Insert Latitude and Longitude values</h4>
<ul>
  <li>Go to the Assets tab and click on the New menu. Then choose the Folder option.</li>
  <li>Select your primary account if you have others linked to your structure. In this example, we see the mapbiomas account, but your structure will apper like this: users/MYACCOUNT. Examples: users/mary/, users/joao/, users/john/, users/tyler/.</li>
  <li>Create a MAPBIOMAS folder (all capital letters) in your assets structure.</li>
</ul>
<img src="misc/create-folder.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<h4>3. Upload a new table asset</h4>



<h4>Enjoy!</h4>
:smile:


