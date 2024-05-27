

# install.packages("readr")
# install.packages("dplyr")
# install.packages("jsonlite")
# install.packages("shiny")
# install.packages("bslib")
# install.packages("shinyquiz")


library(dplyr)
library(readr)
library(jsonlite)
library(shiny)
library(bslib)
library(remotes)
library(shinyquiz)


#' @title Shiny app that tells you when to water your plant
#' @description
#' An interactive app that gives advice on whether to water, fertilize, or change light conditions for common houseplants. Assumes the user is close to their plant (i.e., to feel whether the soil is wet and see if the leaves are droopy).
#' @param ... No parameters yet 
#' @return Pop-up with the user interface
#' @export

GUI <- function(){

  # Taking a Java object and putting it in a data frame
  plant_data_string <- '
  [
      {
          "plant": "Spider Plant",
          "light": "Bright Indirect",
          "watering": "Moderate 2-3 times per week",
          "soil": "Well-draining",
          "feeding": "General purpose balanced fertiliser every 14 days",
          "carescore": "Very Easy",
          "notes": "Spider plants are highly resilient. May be propagated easily by removing and planting small plants that grow on runners."
      },
      {
          "plant": "Areca Palm",
          "light": "Bright Indirect",
          "watering": "Moderate 2-3 times per week. (Allow soil to dry before watering)",
          "soil": "Well-draining",
          "feeding": "General purpose fertiliser every 2-3 months during growing season",
          "carescore": "Easy to Medium",
          "notes": "Growth may be poor at temperatures below 15°C. Prefers humid environment, leaf tips may turn brown in a dry room."
      },
      {
          "plant": "Snake Plant",
          "light": "Bright Indirect to Bright Direct",
          "watering": "Low, water once per fortnight during growing season. (Allow soil to dry before watering)",
          "soil": "Well-draining",
          "feeding": "Very low requirement for fertiliser, feed 1-2 times per growing season (April-September)",
          "carescore": "Easy",
          "notes": "Toxic for cats and dogs."
      },
      {
          "plant": "Christmas Cactus",
          "light": "Bright Indirect",
          "watering": "Moderate, water when top of soil is dry.",
          "soil": "Well-draining",
          "feeding": "Provide a balanced houseplant fertiliser once a month from early spring to autumn",
          "carescore": "Easy",
          "notes": "Christmas cacti enjoy high humidity, keep them near to other plants in your house or spray with water occasionally"
      },
      {
          "plant": "African Violet",
          "light": "Bright Indirect",
          "watering": "Moderate, water when top of soil is dry. Approximately 1-2 times per week.",
          "soil": "Well-draining",
          "feeding": "Provide a balanced houseplant fertiliser every 3 weeks from spring to autumn to encourage flowering",
          "carescore": "Easy",
          "notes": "African violets require warm conditions, ideally the room should reach no less than 16°C at night. Ensure water does not end up on leaves or flowers as African violets may rot."
      },
      {
          "plant": "Moth Orchid",
          "light": "Bright Indirect",
          "watering": "Moderate-high, water once weekly during the spring-autumn growing period. In winter, water once every ~10 days. Approximately 1-2 times per week.",
          "soil": "Well-draining",
          "feeding": "High feeding requirement. Use a fertiliser designated for orchids. Feed regularly (once every 1-2 weeks) in the spring-autumn growing season. Reduce to once monthly in winter.",
          "carescore": "Medium",
          "notes": "In winter they require high levels of light to ensure flowering. Moth orchids are very sensitive to temperature changes. Keep away from heaters/radiators or areas with a draught. They should ideally be kept in a room with minimum night temperatures of 16°C"
      },
      {
          "plant": "Lucky Bamboo",
          "light": "Bright Indirect",
          "watering": "Water frequently (every 3-7 days) and ideally use bottled/distilled water (the chlorine in tap water is known to affect lucky bamboo). If the lucky bamboo is being grown directly in water, ensure the water in the pot is replaced regularly.",
          "soil": "Well-draining. Some lucky bamboo may be grown directly in water.",
          "feeding": "Very low feeding requirement, especially when grown in water. Add a small amount of a diluted general purpose fertiliser every 1-2 months.",
          "carescore": "Very easy",
          "notes": "Avoid keeping near draughts and/or in cold rooms."
      },
      {
          "plant": "Peace Lily",
          "light": "Medium - Bright Indirect",
          "watering": "Low water requirements. Check soil, if top layer of soil is dry or the lily has started to droop slightly, water as required.",
          "soil": "Well-draining and rich in organic matter.",
          "feeding": "Low feeding requirement. Add a small amount of a diluted general purpose fertiliser every 1-2 months.",
          "carescore": "Easy",
          "notes": "To maintain healthy, shiny leaves carefully wipe with a damp and clean cloth occasionally."
      },
      {
          "plant": "Monstera Deliciosa",
          "light": "Bright Indirect",
          "watering": "Check soil, if top ~3cm layer of soil is dry provide some water.",
          "soil": "Well-draining.",
          "feeding": "Low-moderate feeding requirement. Use a general balanced houseplant fertiliser (following the dilution instructions given by the supplier), use around once every month during the growing season (spring to autumn). During winter reduce or stop using fertiliser as the plant requires much less nutrients for growth outside the main growing season. When feeding avoid getting any liquid on the leaves as they may be damaged by direct contact with fertiliser.",
          "carescore": "Easy",
          "notes": "Keep away from cold rooms and areas with a draught. "
      },
      {
          "plant": "String of Pearls",
          "light": "Bright Direct or Indirect",
          "watering": "Very low requirement for water. Water once every 2 weeks.",
          "soil": "Well-draining. A cactus or succulent type soil is ideal.",
          "feeding": "From Spring to Autumn use a cactus/succulent fertiliser as directed by the specific product.",
          "carescore": "Very easy",
          "notes": "Keep away from cold rooms and areas with a draught. To propagate, simply remove a ~10 section from the plant in the growing season. Then plant the ends in cactus/succulent soil or place in water (then move to soil once roots have grown)."
      },
      {
          "plant": "String of Turtles",
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
    titlePanel("PlantCare"),
    
    #Select plant from drop-down list
    sidebarLayout(
      sidebarPanel(
        selectInput("selected_plant", 
          label = "Select your plant from the list",
          choices = c(plant_data$plant, "I don't know the name of my plant", 
                      "My plant is not on the list"), 
          multiple = FALSE
        )
        ), 
      
      mainPanel(
        # Image of plant during selection
        uiOutput("image"),
        textOutput("plant_found")
        
        
      )
  )
  )
  
  
  # Define server logic required for the app
  server <- function(input, output) {
    
    output$image <- renderUI({
      
      # An option must be selected
      req(input$selected_plant)
      
      # Create the path to the image file
      imagePath <- paste0(input$selected_plant, ".jpg")
      
      # Check if the image file exists
      if (file.exists(file.path("www", imagePath))) {
        tags$img(src = imagePath, height = "125px")
      } else {
        tags$p("Image not found")
      }
    })
    
    output$plant_found <- renderText({
     
      # An option must be selected
      req(input$selected_plant)
      
      if (input$selected_plant == "My plant is not on the list") {
        stop("You plant is not in our database. Please find care guidance here: 
             https://garden.org/plants/group >> Select your plant >> 
             Select \"Visit our Plant Care Guides for...\"")
      } else {
        if (input$selected_plant == "I don't know the name of my plant") {
          stop("Please find the name of your plant using this free online tool: https://plant.id/. You can then return and continue your search.")
        } else {
          paste("Plant Care guide:", input$selected_plant)
        }
      }
      
      
      
    })
    
  }
  
  
  # Run the application 
  shinyApp(ui = ui, server = server)
  
}

GUI()




advice <- create_question(
  prompt = "I want advice about:",
  add_choice("Watering", correct = FALSE),
  add_choice("Fertilizer", correct = FALSE),
  add_choice("Repotting", correct = FALSE),
  add_choice("Light conditions", correct = FALSE),
  add_choice("All of the above", correct = TRUE),
  type = "multiple"
  )

water1 <- create_question(
  "How many days have passed since you watered your plant?",
  add_slider(min = 0, max = 14, default_position = 7, correct = 7)
)

water2 <- create_question(
  prompt = "Stick your finger in the soil until your nail is completely covered. Does the soil feel dry?",
  add_choice("Yes", correct = TRUE),
  add_choice("No", correct = TRUE)
)

water3 <- create_question(
  prompt = "Do the leaves seem dry and yellowing? This is a sign the plant needs water",
  add_choice("Yes", correct = TRUE),
  add_choice("No", correct = TRUE)
)

water4 <- create_question(
  prompt = "Do the leaves seem soft and limp? This is a sign of overwatering.",
  add_choice("Yes", correct = TRUE),
  add_choice("No", correct = TRUE)
)

light <-  create_question(
  prompt = "In which type of light do you keep your plant?",
  add_choice("Bright indirect", correct = TRUE),
  add_choice("Low indirect", correct = TRUE),
  add_choice("Bright direct", correct = TRUE),
  add_choice("Low direct", correct = TRUE)
)

fertilizer <- create_question(
    prompt = "When is the last time when you fertilized your plant?",
    add_choice("Never", correct = TRUE),
    add_choice("One month ago", correct = TRUE),
    add_choice("Two weeks ago", correct = TRUE),
    add_choice("Last week", correct = TRUE),
    add_choice("Less than a week ago", correct = TRUE)
  )

repotting1 <- create_question(
  prompt = "Does your pot have drainage holes?",
  add_choice("Yes", correct = TRUE),
  add_choice("No", correct = TRUE)
)

# Repotting2 should only be seen by people who select "yes" on repotting1
repotting2 <- create_question(
  prompt = "Pick up the pot and look at the drainage holes. Do you see roots coming out the bottom?",
  add_choice("Yes", correct = TRUE),
  add_choice("No", correct = TRUE)
)

# Repotting3 should only be seen by people who select "no" on repotting1
repotting3 <- create_question(
  prompt = "Gently remove the plant from its pot. How do the roots look like?",
  add_choice("I can see no visible roots", correct = TRUE),
  add_choice("The roots are very visible", correct = TRUE)
)
# Ideally, add pictures to this

# Create the quiz
quiz <- create_quiz(advice, water1, water2, water3, water4, light, fertilizer, repotting1, repotting2, repotting3)

# Set quiz options
set_quiz_options(progress_bar = TRUE, end_on_first_wrong = FALSE)

# Preview the quiz
preview_app(quiz)






questionnaire <- function(){
    advice <- readline("What do you want advice about? Options include: Water, Fertilizing, Light, Repotting, All of the above ")  
    if (advice == "Water" | advice == "All of the above") {
      water1 <- readline("How many days have passed since you watered your plant? Insert a number between 0 and 30. ")
      water2 <- readline("Stick your finger in the soil until your nail is completely covered. Does the soil feel dry? Respond with \"Yes\" or \"No\". ")
      water3 <- readline("Do the leaves seem dry and yellowing? This is a sign the plant needs water. Respond with \"Yes\" or \"No\". ")
      water4 <- readline("Do the leaves seem soft and limp? This is a sign of overwatering. Respond with \"Yes\" or \"No\". ")
    }
    if (advice == "Light" | advice == "All of the above"){
      light <- readline("In which type of light do you keep your plant? Options include: Bright direct, Low direct, Bright indirect, Low indirect. ")
    }
    if (advice == "Fertilizer" | advice == "All of the above"){
      fertilizer <- readline("When is the last time when you fertilized your plant? Options include: Never, More than two months ago, More than a month ago, Less than a month ago, Less than two weeks ago. ")
    }
    if (advice == "Repotting" | advice == "All of the above"){
      repotting1 <- readline("Does your pot have drainage holes? Respond with \"Yes\" or \"No\". ")
      if (repotting1 == "Yes") {
        repotting2 <- readline("Pick up the pot and look at the drainage holes. Do you see roots coming out the bottom? Respond with \"Yes\" or \"No\". ")
      } else {
        repotting3 <- readline("Gently remove the plant from its pot. Can you see visible roots? Respond with \"Yes\" or \"No\". ")
      }
    }
    result <- data.frame(water1 = water1, water2 = water2, water3 = water3, water4 = water4, light = light, fertilizer = fertilizer, repotting1 = repotting1, repotting2 = repotting2, repotting3 = repotting3)
    return(result)
}

questionnaire()










### Database credit: Database taken from: https://plantsage.org/

### Picture credit: The plant pictures are taken from: https://plantsage.org/
  # "I don't know the name of my plant" picture taken from: 
    # https://miro.medium.com/max/4000/1*aEVMbEExBTVfvv1j4pqiPg.jpeg
  # "My plant is not in the list" picture taken from: 
    #http://clipart-library.com/data_images/109158.png