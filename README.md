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

<h4>1. With ShinyApp</h4>
<p>Access the <a href="https://daniel-althoff.shinyapps.io/easy-eto/" target="blank">Easy-ETo</a> app directly in shinyapps.io.</p>

<h4>2. With R</h4>
<p>Install the required packages in <b>R</b></p>

```{r}
if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, readxl, writexl, dplyr, tidyr,  ggplot2, ggpmisc, lubridate, hydroGOF, update=F)
```

<img src="./misc/app_1.png"
     style="float: left; margin-right: 10px;" />

<h4>2. Create a MAPBIOMAS folder</h4>
<ul>
  <li>Go to the Assets tab and click on the New menu. Then choose the Folder option.</li>
  <li>Select your primary account if you have others linked to your structure. In this example, we see the mapbiomas account, but your structure will apper like this: users/MYACCOUNT. Examples: users/mary/, users/joao/, users/john/, users/tyler/.</li>
  <li>Create a MAPBIOMAS folder (all capital letters) in your assets structure.</li>
</ul>
<img src="misc/create-folder.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<h4>3. Upload a new table asset</h4>

<ul>
  <li>In GEE vectors are called tables.</li>
  <li>Access the menu New > Table upload to add a table.</li>
  <li>Press the SELECT button to choose your shapefile. Browse to the file on your computer.
  <li>Remember to use files with the extension .shp, .shx, .prj, and .dbf. Alternatively, you can compress them into a zip file to upload.
  <li>Note that you must enter the MAPBIOMAS folder name to add the file directly within this folder.</li>
  <li>Click on OK to start the upload task.</li>
</ul>
<img src="misc/upload-table.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>The table will appear inside the MAPBIOMAS folder. Press the refresh button to view all your new files.</li>
  <li>You can also move/copy a table asset from elsewhere in your structure into the MAPBIOMAS folder.</li>
</ul>
<img src="misc/tables-asset.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<h4>4. Accessing the data</h4>

<ul>
  <li>Run the script now. Open it in Code Editor and click the Run button.</li>
</ul>
<img src="misc/accessing-data-1.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>Select a table or choose one of the default tables.</li>
</ul>
<img src="misc/accessing-data-2.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>The table (vector) will be loaded on the map.</li>
  <li>In the Properties menu, select the attribute (column name) that will identify each of the vector polygons.</li>
</ul>
<img src="misc/accessing-data-3.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>In the Features menu, select the polygon name you want to work with.</li>
</ul>
<img src="misc/accessing-data-4.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>The toolkit will zoom into the selected polygon.</li>
  <li>It is possible to apply a buffer between 1 and 5 km. This buffer will only have effect on data export.</li>
</ul>
<img src="misc/accessing-data-5.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>Select from the Layers menu the years you want to view and export. Layers are active in the menu and appear in the default list of layers in the Code Editor.</li>
</ul>
<img src="misc/accessing-data-6.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<h4>5. Exporting data</h4>
<ul>
  <li>To export the data to your Google Drive, click the Export images to Google Drive button. Go to Tasks tab and click the RUN button.</li>
</ul>
<img src="misc/accessing-data-7.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />
<ul>
  <li>A confirmation box will pop up. Choose the Drive option and click the <img src="misc/run-button.png" alt="Markdown Monster icon"/> button.</li>
</ul>
<img src="misc/accessing-data-8.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

<ul>
  <li>Now just wait for the images to be saved to your Google Drive.</li>
  <li>A MAPBIOMAS-EXPORT folder will be created in your Google Drive root and all the mapbiomas data that you exported will be there.</li>
</ul>


<h4>6. Apply the MapBiomas color palette.</h4>
<ul>
  <li><a href="legend-colors/mapbiomas-legend-arcmap.lyr" target="_blank" rel="noopener noreferrer">Color file for ArcMap</a></li>
  <li><a href="legend-colors/mapbiomas-legend-qgis.qml" target="_blank" rel="noopener noreferrer">Color file for QGIS</a></li>
  <li><a href="legend-colors/mapbiomas-legend-excel.xlsx" target="_blank" rel="noopener noreferrer">Color file in Excel table</a></li>
</ul>

<h4>7. Transitions dates.</h4>
<ul>
  <li><a href="misc/transitions.md" target="_blank" rel="noopener noreferrer">Transitions table description</a></li>
</ul>

<h4>Enjoy!</h4>
:smile:


