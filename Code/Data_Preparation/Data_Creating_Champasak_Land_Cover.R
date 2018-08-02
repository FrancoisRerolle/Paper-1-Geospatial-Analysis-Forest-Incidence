# This codes creates land cover layer for Champasak Province in southern Lao using 
# a random forest algorithm, trained on points collected on google earth engine

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper 1 Geospatial analysis Forest_Incidence/Data/Raw")

#Load packages
library(raster)
library(caret)
library(rpart)
library(rgdal)
library(rattle)
library(rpart.plot)
library(RColorBrewer)


#### Load the data
# Champasak Administrative Boundary
Lao_Adm_1 <- getData("GADM", country = "LAO", level = 1)
Champasak <- Lao_Adm_1[Lao_Adm_1$NAME_1 == "Champasak",]

# Import Training dataset
Training_Points <- readOGR(layer="Training_Points_Dataset", dsn="Landcover Training Points")
Training_Points_DF <- Training_Points@data

#### Model for landcover prediction
# Cross-validation
## 1 tree
# setting the tree control parameters
Fit_control <- trainControl(method = "cv", number = 5)
Cart_grid <- expand.grid(.cp=(1:10)*0.0001)

# Decision tree
Tree_model <- train(Class ~ NDVI + NDWI + Band1 + Band2 + Band3 + Band4 + Band5,
                    data = Training_Points_DF,
                    method = "rpart",
                    trControl = Fit_control,
                    tuneGrid = Cart_grid)

Main_tree <- rpart(Class ~ NDVI + NDWI + Band1 + Band2 + Band3 + Band4 + Band5,
                   data = Training_Points_DF,
                   control = rpart.control(cp=0.0004),
                   method = "class")

Predictions <- predict(Main_tree, type = "class")
Training_Points_DF$Class_prediction <- Predictions
length(which(Training_Points_DF$Class_prediction == Training_Points_DF$Class))/nrow(Training_Points_DF)
table(Training_Points_DF$Class, Training_Points_DF$Class_prediction)



#### Import Landsat rasters layers
setwd("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/LandcoverPredicted/Champasak") # Directory where to store predicted layers
extent(Champasak) # Champasak province is fully covered by portion 8, 9, 11 and 12 of the landsat layers Alameyhu gave me for the whole Lao

years <- c(2008, 2009, 2010, 2012, 2013, 2014, 2015, 2016) # 2011 is missing because only 500*500m resolution landsat data

for (i in 1:length(years)){
  # Load landsat data
  NDWI <- raster(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/Landsat/Landsat data 30per30/NDWI_", years[i], "_Laos.tif"))
  NDVI <- raster(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/Landsat/Landsat data 30per30/NDVI_", years[i], "_Laos.tif"))
  Landsat8 <- stack(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/Landsat/Landsat data 30per30/Landsat_", years[i], "_Laos-0000020992-0000010496.tif"))
  names(Landsat8) <- c("Band_1", "Band_2", "Band_3", "Band_4", "Band_5")
  Landsat9 <- stack(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/Landsat/Landsat data 30per30/Landsat_", years[i], "_Laos-0000020992-0000020992.tif"))
  names(Landsat9) <- c("Band_1", "Band_2", "Band_3", "Band_4", "Band_5")
  Landsat11 <- stack(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/Landsat/Landsat data 30per30/Landsat_", years[i], "_Laos-0000031488-0000010496.tif"))
  names(Landsat11) <- c("Band_1", "Band_2", "Band_3", "Band_4", "Band_5")
  Landsat12 <- stack(paste0("/Volumes/FREROLLE/UCSF MEI/PhD/Laos/Landsat/Landsat data 30per30/Landsat_", years[i], "_Laos-0000031488-0000020992.tif"))
  names(Landsat12) <- c("Band_1", "Band_2", "Band_3", "Band_4", "Band_5")
  
  #Merge bands cropped to Champsak extent
  # Band 1
  Champasak_Band_1 <- merge(Landsat8$Band_1,
                           Landsat9$Band_1,
                           Landsat11$Band_1,
                           Landsat12$Band_1)
  Champasak_Band_1 <- crop(Champasak_Band_1, Champasak) # Crop to the extent of Champasak province
  
  # Band 2
  Champasak_Band_2 <- merge(Landsat8$Band_2,
                            Landsat9$Band_2,
                            Landsat11$Band_2,
                            Landsat12$Band_2)
  Champasak_Band_2 <- crop(Champasak_Band_2, Champasak) # Crop to the extent of Champasak province
  
  # Band 3
  Champasak_Band_3 <- merge(Landsat8$Band_3,
                            Landsat9$Band_3,
                            Landsat11$Band_3,
                            Landsat12$Band_3)
  Champasak_Band_3 <- crop(Champasak_Band_3, Champasak) # Crop to the extent of Champasak province
  
  # Band 4
  Champasak_Band_4 <- merge(Landsat8$Band_4,
                            Landsat9$Band_4,
                            Landsat11$Band_4,
                            Landsat12$Band_4)
  Champasak_Band_4 <- crop(Champasak_Band_4, Champasak) # Crop to the extent of Champasak province
  
  # Band 5
  Champasak_Band_5 <- merge(Landsat8$Band_5,
                            Landsat9$Band_5,
                            Landsat11$Band_5,
                            Landsat12$Band_5)
  Champasak_Band_5 <- crop(Champasak_Band_5, Champasak) # Crop to the extent of Champasak province
  
  # NDVI and NDWI
  Champasak_NDVI <- crop(NDVI, Champasak)
  Champasak_NDWI <- crop(NDWI, Champasak)
  
  ### Stack together
  Champasak_Landcover <- stack(Champasak_NDVI,
                               Champasak_NDWI,
                               Champasak_Band_1,
                               Champasak_Band_2,
                               Champasak_Band_3,
                               Champasak_Band_4,
                               Champasak_Band_5)
  
  names(Champasak_Landcover) <- c('NDVI', 'NDWI', 'Band1', 'Band2', 'Band3', 'Band4', 'Band5')
  Champasak_Landcover$Landcover <- predict(Champasak_Landcover,
                                           model = Main_tree,
                                           type = "class")
  
  # Save
  writeRaster(Champasak_Landcover,paste0("Champasak_Landcover_", years[i], ".grd"), format="raster")
}

