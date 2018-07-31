# Paper-1-Geospatial-Analysis-Forest-Incidence

This repositories gathers R code for the geospatial analyses linking Forest and malaria incidence.

Data_Cleaning_Functions.R creates some functions used in data cleaning.

Data_Cleaning_Malaria_Incidence.R cleans the A3 data from southern Laos.

Data_Cleaning_Village_Coordinates.R lists the village names in southern Laos for which we have GPS coordinates.

Data_Merging_Malaria_Incidence_With_GPS_Coordinates.R merges the cleaned A3 data with the list of villages with GPS coordinates via the Village_Key_A3_GPS.csv developped with Khamphao from HPA

Data_Creating_Champasak_Land_Cover.R is the code that takes Google earth engine training points, comes up with a classification algo (random forest) and produces land cover layers in champasak in 2008-2016

Data_Creating_Forest_layers.R converts those landcover layers into forest layers.

Data_Creating_PALSAR_Layers.R creates forest layers from the PALSAR layers

Comparing_Forest_layers.R compares the PALSAR layers to the Landsat layers dervied from classification algo.

Data_Creating_Environmental_Layers produces the layers of environmental covariates.

