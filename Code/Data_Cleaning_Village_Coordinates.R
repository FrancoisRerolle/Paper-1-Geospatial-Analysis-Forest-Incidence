#This code converts the shapefile with GPS coordinates into a table for further merging with malaria data

#Clear working environment
rm(list=ls())

#Set working directory
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper 1 Geospatial analysis Forest_Incidence/Data/Raw/Village Coordinates")

#Load packages
require(rgdal)

#Load the data and Use shapefiles to extract village coordinates
Champasak_Villages_Coordinates <- readOGR(dsn = "Champasak", layer = "vill_CPS",encoding = "utf-8", stringsAsFactors = FALSE)

# Data cleaning
Champasak_Villages_Coordinates$VN_Eng15_U_Original <- Champasak_Villages_Coordinates$VN_Eng15_U
Champasak_Villages_Coordinates$VN_Eng15_U[which(Champasak_Villages_Coordinates$VN_Eng15_U[]=="B. Thieng")] <- "B. Hieng"
Champasak_Villages_Coordinates$Dname_Eng1_Original <- Champasak_Villages_Coordinates$Dname_Eng1
Champasak_Villages_Coordinates$Dname_Eng1[which(Champasak_Villages_Coordinates$Dname_Eng1[]=="Champasack")] <- "Champasak"

# Convert to data frame and extract variables of interest
Champasak_Villages_Coordinates_DF <- Champasak_Villages_Coordinates@data
Champasak_Villages_Coordinates_DF <- Champasak_Villages_Coordinates_DF[,c("Dname_Eng1", "VN_Eng15_U", "LAT", "LONG")]
names(Champasak_Villages_Coordinates_DF) <- c("District", "Village", "Latitude", "Longitude")

# Save 
setwd("/Users/francoisrerolle/Desktop/UCSF/Dissertation/Paper 1 Geospatial analysis Forest_Incidence/Data/Cleaned/Village Coordinates/Champasak")
write.csv(Champasak_Villages_Coordinates_DF, file = "Champasak_Villages_Coordinates.csv", row.names = F) 



