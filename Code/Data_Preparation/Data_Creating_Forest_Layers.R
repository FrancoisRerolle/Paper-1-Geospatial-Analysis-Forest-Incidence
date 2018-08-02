# This codes creates forest layers for Champasak from landcover layers

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/LandcoverPredicted/Champasak")

#Load packages
library(raster)

#### Load the data
# Landcover rasters
# 1=Bare Soil; 2=High Biomass Vegetation; 3=Impervious Surface; 4=Low Biomass Vegetation; 5=Rock; 6=Sand;7=Water
Champasak_Landcover_Stack_2016_30m <- raster::stack("Champasak_Landcover_2016.grd")
Champasak_Landcover_Stack_2015_30m <- raster::stack("Champasak_Landcover_2015.grd")
Champasak_Landcover_Stack_2014_30m <- raster::stack("Champasak_Landcover_2014.grd")
Champasak_Landcover_Stack_2013_30m <- raster::stack("Champasak_Landcover_2013.grd")
Champasak_Landcover_Stack_2012_30m <- raster::stack("Champasak_Landcover_2012.grd")
Champasak_Landcover_Stack_2010_30m <- raster::stack("Champasak_Landcover_2010.grd")
Champasak_Landcover_Stack_2009_30m <- raster::stack("Champasak_Landcover_2009.grd")
Champasak_Landcover_Stack_2008_30m <- raster::stack("Champasak_Landcover_2008.grd")

# Keep only layer with landcover
Champasak_Landcover_2016_30m <- Champasak_Landcover_Stack_2016_30m$Landcover
Champasak_Landcover_2015_30m <- Champasak_Landcover_Stack_2015_30m$Landcover
Champasak_Landcover_2014_30m <- Champasak_Landcover_Stack_2014_30m$Landcover
Champasak_Landcover_2013_30m <- Champasak_Landcover_Stack_2013_30m$Landcover
Champasak_Landcover_2012_30m <- Champasak_Landcover_Stack_2012_30m$Landcover
Champasak_Landcover_2010_30m <- Champasak_Landcover_Stack_2010_30m$Landcover
Champasak_Landcover_2009_30m <- Champasak_Landcover_Stack_2009_30m$Landcover
Champasak_Landcover_2008_30m <- Champasak_Landcover_Stack_2008_30m$Landcover

# Dichotomize HBV to convert into forest layers
Champasak_HBV_2016_30m <- calc(Champasak_Landcover_2016_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2015_30m <- calc(Champasak_Landcover_2015_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2014_30m <- calc(Champasak_Landcover_2014_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2013_30m <- calc(Champasak_Landcover_2013_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2012_30m <- calc(Champasak_Landcover_2012_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2010_30m <- calc(Champasak_Landcover_2010_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2009_30m <- calc(Champasak_Landcover_2009_30m, fun = function(x) {ifelse(x == 2, 1, 0)})
Champasak_HBV_2008_30m <- calc(Champasak_Landcover_2008_30m, fun = function(x) {ifelse(x == 2, 1, 0)})

# Agrregate to 930m per 930m pixel
Champasak_HBV_percent_2016_930m <- aggregate(Champasak_HBV_2016_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2015_930m <- aggregate(Champasak_HBV_2015_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2014_930m <- aggregate(Champasak_HBV_2014_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2013_930m <- aggregate(Champasak_HBV_2013_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2012_930m <- aggregate(Champasak_HBV_2012_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2010_930m <- aggregate(Champasak_HBV_2010_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2009_930m <- aggregate(Champasak_HBV_2009_30m, fact = 31, fun = mean)
Champasak_HBV_percent_2008_930m <- aggregate(Champasak_HBV_2008_30m, fact = 31, fun = mean)

# Create HBV percent in 10km radius around cell center layers
# Each of them takes ~1min
Champasak_HBV_percent_in_10km_2016_930m <- Champasak_HBV_percent_2016_930m
Champasak_HBV_percent_in_10km_2016_930m[which(!is.na(Champasak_HBV_percent_in_10km_2016_930m[]))] <- raster::extract(Champasak_HBV_percent_2016_930m, y=rasterToPoints(Champasak_HBV_percent_2016_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2015_930m <- Champasak_HBV_percent_2015_930m
Champasak_HBV_percent_in_10km_2015_930m[which(!is.na(Champasak_HBV_percent_in_10km_2015_930m[]))] <- raster::extract(Champasak_HBV_percent_2015_930m, y=rasterToPoints(Champasak_HBV_percent_2015_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2014_930m <- Champasak_HBV_percent_2014_930m
Champasak_HBV_percent_in_10km_2014_930m[which(!is.na(Champasak_HBV_percent_in_10km_2014_930m[]))] <- raster::extract(Champasak_HBV_percent_2014_930m, y=rasterToPoints(Champasak_HBV_percent_2014_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2013_930m <- Champasak_HBV_percent_2013_930m
Champasak_HBV_percent_in_10km_2013_930m[which(!is.na(Champasak_HBV_percent_in_10km_2013_930m[]))] <- raster::extract(Champasak_HBV_percent_2013_930m, y=rasterToPoints(Champasak_HBV_percent_2013_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2012_930m <- Champasak_HBV_percent_2012_930m
Champasak_HBV_percent_in_10km_2012_930m[which(!is.na(Champasak_HBV_percent_in_10km_2012_930m[]))] <- raster::extract(Champasak_HBV_percent_2012_930m, y=rasterToPoints(Champasak_HBV_percent_2012_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2010_930m <- Champasak_HBV_percent_2010_930m
Champasak_HBV_percent_in_10km_2010_930m[which(!is.na(Champasak_HBV_percent_in_10km_2010_930m[]))] <- raster::extract(Champasak_HBV_percent_2010_930m, y=rasterToPoints(Champasak_HBV_percent_2010_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2009_930m <- Champasak_HBV_percent_2009_930m
Champasak_HBV_percent_in_10km_2009_930m[which(!is.na(Champasak_HBV_percent_in_10km_2009_930m[]))] <- raster::extract(Champasak_HBV_percent_2009_930m, y=rasterToPoints(Champasak_HBV_percent_2009_930m, spatial=T), buffer = 10000, fun = mean)

Champasak_HBV_percent_in_10km_2008_930m <- Champasak_HBV_percent_2008_930m
Champasak_HBV_percent_in_10km_2008_930m[which(!is.na(Champasak_HBV_percent_in_10km_2008_930m[]))] <- raster::extract(Champasak_HBV_percent_2008_930m, y=rasterToPoints(Champasak_HBV_percent_2008_930m, spatial=T), buffer = 10000, fun = mean)



###################################
#Stack data together
Champasak_Forest_Layer <- stack(Champasak_HBV_percent_2016_930m,
                                Champasak_HBV_percent_2015_930m,
                                Champasak_HBV_percent_2014_930m,
                                Champasak_HBV_percent_2013_930m,
                                Champasak_HBV_percent_2012_930m,
                                Champasak_HBV_percent_2010_930m,
                                Champasak_HBV_percent_2009_930m,
                                Champasak_HBV_percent_2008_930m,
                                Champasak_HBV_percent_in_10km_2016_930m,
                                Champasak_HBV_percent_in_10km_2015_930m,
                                Champasak_HBV_percent_in_10km_2014_930m,
                                Champasak_HBV_percent_in_10km_2013_930m,
                                Champasak_HBV_percent_in_10km_2012_930m,
                                Champasak_HBV_percent_in_10km_2010_930m,
                                Champasak_HBV_percent_in_10km_2009_930m,
                                Champasak_HBV_percent_in_10km_2008_930m)

names(Champasak_Forest_Layer) <- c("HBV_2016_percent",
                                   "HBV_2015_percent",
                                   "HBV_2014_percent",
                                   "HBV_2013_percent",
                                   "HBV_2012_percent",
                                   "HBV_2010_percent",
                                   "HBV_2009_percent",
                                   "HBV_2008_percent",
                                   "HBV_percent_in_10km_2016",
                                   "HBV_percent_in_10km_2015",
                                   "HBV_percent_in_10km_2014",
                                   "HBV_percent_in_10km_2013",
                                   "HBV_percent_in_10km_2012",
                                   "HBV_percent_in_10km_2010",
                                   "HBV_percent_in_10km_2009",
                                   "HBV_percent_in_10km_2008")

####Export raster stack
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper 1 Geospatial analysis Forest_Incidence/Data/Cleaned/Forest Layers")
writeRaster(Champasak_Forest_Layer, "Champasak_Forest_Layer.grd", format="raster", overwrite=T)


