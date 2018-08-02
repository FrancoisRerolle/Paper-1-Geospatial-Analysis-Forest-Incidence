# This creates the PALSAR layers
# PALSAR worlwide 25m per 25m Forest/no forest 2008, 2009, 2010, 2015, 2016, 2017

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Forest Layers")

#Load packages
library(raster)

#### Load the data
## Champasak Administrative Boundary
Lao_Adm <- getData("GADM", country = "LAO", level = 0)

###### PALSAR
# ~10 min per year
years <- c(2008, 2009, 2010, 2015, 2017) # Years of PALSAR data

for (j in 1:length(years)){
  year <- years[j]
  print(year) #To follow progress
  
  setwd(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Forest Layers/PALSAR/Raw/",year))
  PALSAR_filenames <- list.files()
  PALSAR_filenames <- PALSAR_filenames[-grep(pattern = "Surrounding Laos", x=PALSAR_filenames)] # Selects all raster file in PALSAR/year folder
  PALSAR_filenames <- PALSAR_filenames[-grep(pattern = ".hdr", x=PALSAR_filenames)] # Selects all raster file in PALSAR/year folder
  print(length(PALSAR_filenames))
  List_raster <- list()

  for (i in 1:length(PALSAR_filenames)){
    List_raster[[i]] <- raster(PALSAR_filenames[i])
  }
  List_raster$filename <-  paste0("PALSAR_Laos_", year, ".tif")
  List_raster$overwrite <- TRUE
  List_raster$tolerance <- 1
  setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Forest Layers/PALSAR/MERGED")
  m <- do.call(merge, List_raster) # Saves the .tif file in folder
}


