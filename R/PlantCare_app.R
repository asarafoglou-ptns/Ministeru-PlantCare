# install.packages("readr")
# install.packages("dplyr")
# install.packages("jsonlite")
# install.packages("shiny")
# install.packages("bslib")

library(dplyr)
library(readr)
library(jsonlite)
library(shiny)
library(bslib)


#' @title Shiny app that tells you when to water your plant
#' @description
#' An interactive app that gives advice on whether to water, fertilize, or change light conditions for common houseplants. Assumes the user is close to their plant (i.e., to feel whether the soil is wet and see if the leaves are droopy).
#' @param ... No parameters yet 
#' @return Pop-up with the user interface
#' @export
GUI <- function() {

  # Taking a Java object and putting it in a data frame
  plant_data_string <- '
  [
      {
          "plant": "Spider Plant - Chlorophytum comosum",
          "light": "Bright Indirect",
          "watering": "Moderate 2-3 times per week",
          "soil": "Well-draining",
          "feeding": "General purpose balanced fertiliser every 14 days",
          "carescore": "Very Easy",
          "notes": "Spider plants are highly resilient. May be propagated easily by removing and planting small plants that grow on runners."
      },
      {
          "plant": "Areca Palm - Bamboo Palm - Dypsis lutescens",
          "light": "Bright Indirect",
          "watering": "Moderate 2-3 times per week. (Allow soil to dry before watering)",
          "soil": "Well-draining",
          "feeding": "General purpose fertiliser every 2-3 months during growing season",
          "carescore": "Easy to Medium",
          "notes": "Growth may be poor at temperatures below 15°C. Prefers humid environment, leaf tips may turn brown in a dry room."
      },
      {
          "plant": "Snake Plant - Dracaena trifasciata",
          "light": "Bright Indirect to Bright Direct",
          "watering": "Low, water once per fortnight during growing season. (Allow soil to dry before watering)",
          "soil": "Well-draining",
          "feeding": "Very low requirement for fertiliser, feed 1-2 times per growing season (April-September)",
          "carescore": "Easy",
          "notes": "Toxic for cats and dogs."
      },
      {
          "plant": "Christmas Cactus - Schlumbergera",
          "light": "Bright Indirect",
          "watering": "Moderate, water when top of soil is dry.",
          "soil": "Well-draining",
          "feeding": "Provide a balanced houseplant fertiliser once a month from early spring to autumn",
          "carescore": "Easy",
          "notes": "Christmas cacti enjoy high humidity, keep them near to other plants in your house or spray with water occasionally"
      },
      {
          "plant": "African Violet - Streptocarpus sect. Saintpaulia",
          "light": "Bright Indirect",
          "watering": "Moderate, water when top of soil is dry. Approximately 1-2 times per week.",
          "soil": "Well-draining",
          "feeding": "Provide a balanced houseplant fertiliser every 3 weeks from spring to autumn to encourage flowering",
          "carescore": "Easy",
          "notes": "African violets require warm conditions, ideally the room should reach no less than 16°C at night. Ensure water does not end up on leaves or flowers as African violets may rot."
      },
      {
          "plant": "Moth Orchid - Phalaenopsis",
          "light": "Bright Indirect",
          "watering": "Moderate-high, water once weekly during the spring-autumn growing period. In winter, water once every ~10 days. Approximately 1-2 times per week.",
          "soil": "Well-draining",
          "feeding": "High feeding requirement. Use a fertiliser designated for orchids. Feed regularly (once every 1-2 weeks) in the spring-autumn growing season. Reduce to once monthly in winter.",
          "carescore": "Medium",
          "notes": "In winter they require high levels of light to ensure flowering. Moth orchids are very sensitive to temperature changes. Keep away from heaters/radiators or areas with a draught. They should ideally be kept in a room with minimum night temperatures of 16°C"
      },
      {
          "plant": "Lucky Bamboo - Dracaena sanderiana",
          "light": "Bright Indirect",
          "watering": "Water frequently (every 3-7 days) and ideally use bottled/distilled water (the chlorine in tap water is known to affect lucky bamboo). If the lucky bamboo is being grown directly in water, ensure the water in the pot is replaced regularly.",
          "soil": "Well-draining. Some lucky bamboo may be grown directly in water.",
          "feeding": "Very low feeding requirement, especially when grown in water. Add a small amount of a diluted general purpose fertiliser every 1-2 months.",
          "carescore": "Very easy",
          "notes": "Avoid keeping near draughts and/or in cold rooms."
      },
      {
          "plant": "Peace Lily - Spathiphyllum",
          "light": "Medium - Bright Indirect",
          "watering": "Low water requirements. Check soil, if top layer of soil is dry or the lily has started to droop slightly, water as required.",
          "soil": "Well-draining and rich in organic matter.",
          "feeding": "Low feeding requirement. Add a small amount of a diluted general purpose fertiliser every 1-2 months.",
          "carescore": "Easy",
          "notes": "To maintain healthy, shiny leaves carefully wipe with a damp and clean cloth occasionally."
      },
      {
          "plant": "Swiss Cheese Plant - Monstera deliciosa",
          "light": "Bright Indirect",
          "watering": "Check soil, if top ~3cm layer of soil is dry provide some water.",
          "soil": "Well-draining.",
          "feeding": "Low-moderate feeding requirement. Use a general balanced houseplant fertiliser (following the dilution instructions given by the supplier), use around once every month during the growing season (spring to autumn). During winter reduce or stop using fertiliser as the plant requires much less nutrients for growth outside the main growing season. When feeding avoid getting any liquid on the leaves as they may be damaged by direct contact with fertiliser.",
          "carescore": "Easy",
          "notes": "Keep away from cold rooms and areas with a draught. "
      },
      {
          "plant": "String-of-Pearls - Senecio rowleyanus",
          "light": "Bright Direct or Indirect",
          "watering": "Very low requirement for water. Water once every 2 weeks.",
          "soil": "Well-draining. A cactus or succulent type soil is ideal.",
          "feeding": "From Spring to Autumn use a cactus/succulent fertiliser as directed by the specific product.",
          "carescore": "Very easy",
          "notes": "Keep away from cold rooms and areas with a draught. To propagate, simply remove a ~10 section from the plant in the growing season. Then plant the ends in cactus/succulent soil or place in water (then move to soil once roots have grown)."
      },
      {
          "plant": "String of Turtles - Peperomia prostrata",
          "light": "Bright Indirect",
          "watering": "Water when the top 1-2 inches of soil are dry, approximately 1-2 times per week.",
          "soil": "Well-draining, slightly acidic and high in organic material. A peat and perlite based soil mix is ideal.",
          "feeding": "From Spring to Summer use a small amount of houseplant fertiliser as directed by the specific product. Apply approximately ever 1-2 weeks. During autumn and winter do not use any fertiliser.",
          "carescore": "Medium",
          "notes": "Keep away from cold rooms and areas with a draught. A stable and moderate temperature of around 19-21C is ideal for a string-of-turtles plant. Pruning can be useful to maintain a dense and healthy plant."
      }
  ]'
      
  plant_data <- jsonlite::fromJSON(plant_data_string, simplifyDataFrame = TRUE)
  
  
  # Define UI for application
  ui <- fluidPage(
    
    # Application title
    titlePanel("PlantCare Guide"),
    
    # Flowing list for selection of the plant 
    selectInput(
      "select_plant", 
      label = "Select your plant from the list",
      choices = c(
        plant_data$plant, 
        "I don't know the name of my plant", 
        "My plant is not in the list"
        ), 
      multiple = FALSE
    )
  )
  
  
  # Define server logic required for the app
  server <- function(input, output) {
  
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
  
}

GUI()
