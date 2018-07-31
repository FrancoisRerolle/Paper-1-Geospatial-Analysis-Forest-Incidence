# This codes writes functions for data cleaning of malaria incidence A3 data in the south

# Create a list for factor level from codebook

Level_key_function <- function(codebook, slice.start, slice.end){
  codebook_A3 <- (codebook
                  %>% slice(slice.start:slice.end) #filter codebook rows corresponding
                  )
  Level_key <- as.list(codebook_A3$X3)
  names(Level_key) <- codebook_A3$X2
  return(Level_key)
}





