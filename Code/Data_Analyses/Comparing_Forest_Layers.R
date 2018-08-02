# This codes compares forest layers produce by landsat classification to forest layers available out there:

# PALSAR Forest/no forest 2008, 2009, 2010, 2015, 2016, 2017

# GLCF Landsat tree cover continuous field 2010
# GLCF Landsat tree cover continuous field 2000

# Hansen 2000 percent tree cover
# Hansen 2000-2017 loss
# Hansen 2000-2012 gain

# Hansen 2000 vs GLCF 2000
# PALSAR 2010 vs GLCF 2010

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Forest Layers")

#Load packages
library(raster)
library(tidyverse)

###### PALSAR vs FR Landsat
#### Over Champasak
## Champasak Administrative Boundary
Lao_Adm_1 <- getData("GADM", country = "LAO", level = 1)
Champasak_Adm <- Lao_Adm_1[Lao_Adm_1$NAME_1 == "Champasak",]

### Import data
# PALSAR
setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Forest Layers/PALSAR/MERGED")
PALSAR_Laos_2016 <- raster("PALSAR_Laos_2016.tif")
PALSAR_Laos_2015 <- raster("PALSAR_Laos_2015.tif")
PALSAR_Laos_2010 <- raster("PALSAR_Laos_2010.tif")
PALSAR_Laos_2009 <- raster("PALSAR_Laos_2009.tif")
PALSAR_Laos_2008 <- raster("PALSAR_Laos_2008.tif")

# Stack together
PALSAR_Laos <- stack(PALSAR_Laos_2008,
                     PALSAR_Laos_2009,
                     PALSAR_Laos_2010,
                     PALSAR_Laos_2015,
                     PALSAR_Laos_2016)


# Landcover rasters
setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/LandcoverPredicted/Champasak")

# 1=Bare Soil; 2=High Biomass Vegetation; 3=Impervious Surface; 4=Low Biomass Vegetation; 5=Rock; 6=Sand;7=Water
Landcover_Champasak_2016_Stack <- raster::stack("Champasak_Landcover_2016.grd")
Landcover_Champasak_2015_Stack <- raster::stack("Champasak_Landcover_2015.grd")
Landcover_Champasak_2010_Stack <- raster::stack("Champasak_Landcover_2010.grd")
Landcover_Champasak_2009_Stack <- raster::stack("Champasak_Landcover_2009.grd")
Landcover_Champasak_2008_Stack <- raster::stack("Champasak_Landcover_2008.grd")

# Keep only layer with landcover
Landcover_Champasak_2016 <- Landcover_Champasak_2016_Stack$Landcover
Landcover_Champasak_2015 <- Landcover_Champasak_2015_Stack$Landcover
Landcover_Champasak_2010 <- Landcover_Champasak_2010_Stack$Landcover
Landcover_Champasak_2009 <- Landcover_Champasak_2009_Stack$Landcover
Landcover_Champasak_2008 <- Landcover_Champasak_2008_Stack$Landcover

# Stack together
Landcover_Champasak <- stack(Landcover_Champasak_2008,
                             Landcover_Champasak_2009,
                             Landcover_Champasak_2010,
                             Landcover_Champasak_2015,
                             Landcover_Champasak_2016)

### Randomly select points
Number_of_points <- 5000
Comparison_points <- spsample(Champasak_Adm, n = Number_of_points, type = "random")

Comparison_data_raw <- as.tibble(data.frame(raster::extract(x = Landcover_Champasak, y = Comparison_points), raster::extract(x = PALSAR_Laos, y = Comparison_points)))

# A bit of data cleaning
names(Comparison_data_raw) <- c("Landcover_2008",
                                "Landcover_2009",
                                "Landcover_2010",
                                "Landcover_2015",
                                "Landcover_2016",
                                "PALSAR_2008",
                                "PALSAR_2009",
                                "PALSAR_2010",
                                "PALSAR_2015",
                                "PALSAR_2016")

Landcover_level_key <- list("1" = "Bare Soil",
                            "2" = "High Biomass Vegetation",
                            "3" = "Impervious Surface",
                            "4" = "Low Biomass Vegetation",
                            "5" = "Rock",
                            "6" = "Sand",
                            "7" = "Water")

PALSAR_level_key <- list("0" = "No data",
                         "1" = "Forest",
                         "2" = "No Forest",
                         "3" = "Water")

# Binary
Landcover_level_key <- list("1" = "No Forest",
                            "2" = "Forest",
                            "3" = "No Forest",
                            "4" = "No Forest",
                            "5" = "No Forest",
                            "6" = "No Forest",
                            "7" = "No Forest")

PALSAR_level_key <- list("0" = "No data",
                         "1" = "Forest",
                         "2" = "No Forest",
                         "3" = "No Forest")


Comparison_data <- (Comparison_data_raw
                    %>% mutate(Landcover_2008 = recode(Landcover_2008, !!!Landcover_level_key),
                               Landcover_2009 = recode(Landcover_2009, !!!Landcover_level_key),
                               Landcover_2010 = recode(Landcover_2010, !!!Landcover_level_key),
                               Landcover_2015 = recode(Landcover_2015, !!!Landcover_level_key),
                               Landcover_2016 = recode(Landcover_2016, !!!Landcover_level_key),
                               PALSAR_2008 = recode(PALSAR_2008, !!!PALSAR_level_key),
                               PALSAR_2009 = recode(PALSAR_2009, !!!PALSAR_level_key),
                               PALSAR_2010 = recode(PALSAR_2010, !!!PALSAR_level_key),
                               PALSAR_2015 = recode(PALSAR_2015, !!!PALSAR_level_key),
                               PALSAR_2016 = recode(PALSAR_2016, !!!PALSAR_level_key)
                               )
                    )

# Sensitivity & Specificity
years <- c(2008, 2009, 2010, 2015, 2016)
for (i in 1:length(years)){
  data <- Comparison_data[,c(i, i+5)]
  Two_by_two_table <- table(data)
  print(Two_by_two_table)
  
  #Sensitivity
  print("Sensitivity:")
  print(100*Two_by_two_table[1,1]/(Two_by_two_table[1,1] + Two_by_two_table[2,1]))
  
  #Specificity
  print("Specificty:")
  print(100*Two_by_two_table[2,2]/(Two_by_two_table[2,2] + Two_by_two_table[1,2]))
}


