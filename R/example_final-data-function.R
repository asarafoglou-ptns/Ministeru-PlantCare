library(PlantCare)

my_data <- scrap_data()                                                           # An 11 x 7 data frame
my_final_data <- final_data(my_data)                                              # An 11 x 13 data frame, ready for use with the PlantCare app

final_data(data.frame(NA))                                                        # Error: input must be data frame obtained from the scrap_data() function

