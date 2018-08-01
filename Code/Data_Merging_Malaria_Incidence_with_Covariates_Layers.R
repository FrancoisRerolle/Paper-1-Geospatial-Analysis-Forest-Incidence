#This code extracts the forest and environmental covariates for the clean A3 data with GPS

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data")

#Load packages
library(tidyverse)
library(raster)

### Load the data
# Malaria Incidence
load("Merged/A3_South_GPS.RData")

# Environmental Covariates
Champasak_Environmental_Layers <- raster::stack("Cleaned/Environmental Layers/Champasak_Environmental_Layers.grd")

# Forest Layers
Champasak_Forest_Layers <- raster::stack("Cleaned/Forest Layers/Champasak_Forest_Layer.grd")


### Extract Environmental and Forest covariates 
# Create SP file
A3_South_GPS$Index <- 1:nrow(A3_South_GPS) # Creates index for matching back after extraction
A3_South_GPS_DF <- A3_South_GPS

# Remove NA in coordinates
A3_South_GPS <- (A3_South_GPS
                 %>% filter(!is.na(Latitude) & !is.na(Longitude))
                 )

# Define coordinates and projection
coordinates(A3_South_GPS) <- ~ Longitude + Latitude
proj4string(A3_South_GPS) <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')

# Extraction
A3_South_Environmental_Covariates <- extract(Champasak_Environmental_Layers,  A3_South_GPS)
A3_South_Forest_Covariates <- extract(Champasak_Forest_Layers,  A3_South_GPS)

# Append
A3_South_GPS <- as.tibble(cbind(A3_South_GPS@data, A3_South_Environmental_Covariates, A3_South_Forest_Covariates))

# Merge back with coordinates
A3_South <- (A3_South_GPS_DF
             %>% left_join(A3_South_GPS)
             %>% dplyr::select(-Index)
             )


### Save 
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper-1-Geospatial-Analysis-Forest-Incidence/Data/Final")
write.csv(A3_South, file = "A3_South.csv", row.names = F) # Save an excel file for easy visualization
save(file="A3_South.RData", A3_South) # Save an Rdata file to conserve data cleaning/management features
