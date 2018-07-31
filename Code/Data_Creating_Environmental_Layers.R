# This codes creates environmental layers for Champasak

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper 1 Geospatial analysis Forest_Incidence/Data/Raw/Environmental Covariates")

#Load packages
library(raster)


#### Load the data
## Champasak Administrative Boundary
Lao_Adm_1 <- getData("GADM", country = "LAO", level = 1)
Champasak <- Lao_Adm_1[Lao_Adm_1$NAME_1 == "Champasak",]

## Environmental covariates Champasak: Altitude, rainfall, temperature, population
# Load data and resample to altitude layers extent and resolution

# Altitude 0.00833 degree resolution (=926m)
Lao_Altitude <- getData(name="alt", country="LAO") # Download altitude data (in meters)
Champasak_Altitude <- crop(Lao_Altitude, Champasak) # Crops to Champasak extent

# Bioclimatic annual variables 0.00833 degree resolution (=926m)
Lao_Bioclimatic <- getData(name = "worldclim", var = "bio", res = 0.5, lon = 102.5, lat = 20.5)

# Temperature
Champasak_Temperature_Annual_Mean <- Lao_Bioclimatic$bio1_29 # Annual mean temperature (in Kelvin), averaged between 1970 and 2000
Champasak_Temperature_Annual_Mean <- resample(Champasak_Temperature_Annual_Mean, Champasak_Altitude, method = "bilinear") # Resample to Altitude extent
Champasak_Temperature_Seasonality <- Lao_Bioclimatic$bio4_29 # Temperature Seasonality (Standrad deviation * 100)
Champasak_Temperature_Seasonality <- resample(Champasak_Temperature_Seasonality, Champasak_Altitude, method = "bilinear") # Resample to Altitude extent

# Rainfall
Champasak_Precipitation_Annual <- Lao_Bioclimatic$bio12_29 # Annual precipitation (mm)
Champasak_Precipitation_Annual <- resample(Champasak_Precipitation_Annual, Champasak_Altitude, method = "bilinear") # Resample to Altitude extent
Champasak_Precipitation_Seasonality <- Lao_Bioclimatic$bio15_29 #Precipitation Seasonality (Coefficient of Variation)
Champasak_Precipitation_Seasonality <- resample(Champasak_Precipitation_Seasonality, Champasak_Altitude, method = "bilinear") # Resample to Altitude extent

# Population
Lao_Population_2015_100m <- raster("Population/Laos 100m per 100m/110_LAO_popmap15adj_admin001_v2/LAO_popmap15adj_admin001_v2.tif")
Lao_Population_2010_100m <- raster("Population/Laos 100m per 100m/110_LAO_popmap10adj_admin001_v2/LAO_popmap10adj_admin001_v2.tif")

#Aggregate to 0.0083 resolution (=926m)
Lao_Population_2015 <- aggregate(Lao_Population_2015_100m, fact=10, fun = sum) #Sum over 100m per 100m pixels within a 1km per 1km pixel
Lao_Population_2010 <- aggregate(Lao_Population_2010_100m, fact=10, fun = sum)

#Resample to Altitude extent
Champasak_Population_2015 <- resample(Lao_Population_2015, Champasak_Altitude, method="bilinear") # Resample to Altitude extent
Champasak_Population_2010 <- resample(Lao_Population_2010, Champasak_Altitude, method="bilinear") # Resample to Altitude extent


###################################
#Stack data together
Champasak_Environmental_Layers <- stack(Champasak_Altitude,
                                        Champasak_Temperature_Annual_Mean,
                                        Champasak_Temperature_Seasonality,
                                        Champasak_Precipitation_Annual,
                                        Champasak_Precipitation_Seasonality,
                                        Champasak_Population_2010,
                                        Champasak_Population_2015)

# Rename layers
names(Champasak_Environmental_Layers) <- c("Altitude",
                                           "Temperature_Annual_Mean",
                                           "Temperature_Seasonality",
                                           "Precipitation_Annual",
                                           "Precipitation_Seasonality",
                                           "Population_2010",
                                           "Population_2015")

####Export raster stack
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper 1 Geospatial analysis Forest_Incidence/Data/Cleaned/Environmental Layers")
writeRaster(Champasak_Environmental_Layers, "Champasak_Environmental_Layers.grd", format="raster", overwrite=T)






