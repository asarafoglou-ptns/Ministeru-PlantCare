

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
library(remotes)


#' @title Shiny app that tells you when to water your plant
#' @description
#' An interactive app that gives advice on whether to water, fertilize, or 
#' change light conditions for common houseplants. Assumes the user is close to 
#' their plant, i.e., to feel whether the soil is wet and see if the 
#' leaves are droopy.
#' @param ... No parameters yet 
#' @return Pop-up with the user interface
#' @export
GUI <- function(){

  # Taking a Java object and putting it in a data frame
  data_string <- '
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
  
  # Creating data frame  
  data <- jsonlite::fromJSON(data_string, simplifyDataFrame = TRUE)
  
  
  # Adding column: After how many days the plant needs water
  data <- cbind(data, watering_days = NA)
  
  # 2-3 times per week: every 4 days
  data$watering_days[grep("2-3 times", data$watering)] <- 4
  
  # Every 3-7 days and once weekly: every 7 days
  data$watering_days[grep("3-7 days", data$watering)] <- 7
  data$watering_days[grep("once weekly", data$watering)] <- 7
  
  # Fortnight or every 2 weeks: every 14 days
  data$watering_days[grep("fortnight", data$watering)] <- 14
  data$watering_days[grep("every 2 weeks", data$watering) ] <- 14
  
  # Some plants do not have specified number of days; the soil must be checked
  data$watering_days[grep("soil", data$watering)] <- "soil"
  
  
  # Adding column: Water amount
  data <- cbind(data, water_amount = NA)
  data$water_amount[grep("Moderate", 
                         data$watering,ignore.case = T)] <- "moderate"
  data$water_amount[grep("Low", data$watering, ignore.case = T)] <- "low"
  data$water_amount[grep("High", data$watering, ignore.case = T)] <- "high"
  data$water_amount <- ifelse(is.na(data$water_amount), 
                              "moderate", 
                              data$water_amount)
  
  
  # Adding column: fertilizer per month
  data <- cbind(data, f_growing = c(rep(1, 11)))
  data <- cbind(data, f_winter = c(1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0))
  data <- cbind(data, f_growing_months = c(0.5, 2, 4, 1, 1, 0.25, 2, 1, 1, 2, 
                                           0.5))
  data <- cbind(data, f_winter_months = c(0.5, NA, NA, NA, NA, 1, 2, 2, NA, NA, 
                                          NA))
  
  # Define UI for application
  ui <- fluidPage(
    
    # Application title
    titlePanel("PlantCare Guide"),
    
    #Select plant from drop-down list
    sidebarLayout(
      sidebarPanel(
        
        # Select plant
        selectInput(
          "my_plant", 
          label = "Select your plant:",
          choices = c(data$plant, "I don't know the name of my plant", 
                      "My plant is not on the list"), 
          multiple = FALSE
        ),
        
        br(), # Adds space
        
        # Image of plant during selection
        uiOutput("image"),
        
        #Error message if the plant is not found or the name is not known
        textOutput("plant_found"),
        
        br(), # Adds space
        br(),
        
        # Selects which advice they want
        selectInput(
          "advice",
          label = "I want advice about:",
          choices = c("Watering", "Light", "Fertilizing", "Repotting"),
          multiple = TRUE
        ),
        
        # Action button: Restart
        actionButton(
          "restart",
          label = "Restart",
          icon = icon("rotate-right")
        ),
        
        br(), # Add space
        br(),
        
        # Action button: Submit
        actionButton(
          "submit",
          label = "Get advice",
          icon = icon("pagelines")
        )
        
        ),
      
      mainPanel(
        
        conditionalPanel(
          condition = "input.advice.includes(\"Watering\")",
          
          # Number of days since last watering
          sliderInput(
            "water1",
            label = "How many days have passed since you watered your plant?",
            min = 0,
            max = 30,
            value = 7,
            round = TRUE
          ),
          
          # Soil feels dry or not
          radioButtons(
            "water2",
            label = paste("Stick your finger in the soil until your nail is",
                          "completely covered. Does the soil feel dry?"),
            choices = c("Yes", "No")
          ),
          
          # Signs underwatering
          radioButtons(
            "water3",
            label = paste("Do the leaves seem dry and yellowing? This is a", 
                          "sign the plant needs water."),
            choices = c("Yes", "No")
          ),
          
          # Signs overwatering
          radioButtons(
            "water4",
            label = paste("Do the leaves seem soft and limp?", 
                          "This is a sign of overwatering."),
            choices = c("Yes", "No")
          )
          
        ),
        
        conditionalPanel(
          condition = "input.advice.includes(\"Light\")",
        
        # Light
        selectInput(
          "light",
          label = "In which type of light do you keep your plant?",
          choices = c(
            "Bright indirect", 
            "Low indirect", 
            "Bright direct", 
            "Low direct"
            )
        )
        ),
        
        conditionalPanel(
          condition = "input.advice.includes(\"Fertilizing\")",
          
        # Fertilizer
        sliderInput(
          "fertilizer",
          label = paste("How many months have passed", 
                        "since you last fertilized your plant?"),
          min = 0,
          max = 6,
          value = 1
          )
        ),
        
        conditionalPanel(
          condition = "input.advice.includes(\"Repotting\")",
         
        # Repotting: Drainage holes
        radioButtons(
          "repotting1_drainage",
          label = "Does your pot have drainage holes?",
          choices = c("Yes", "No")
        ),
        
        conditionalPanel(
          condition = "input.repotting1_drainage == \"Yes\"",
        
      # Repotting: Drainage: Pick up
        radioButtons(
          "repotting2",
          label = paste("Pick up the pot and look at the drainage holes.", 
                        "Do you see roots coming out the bottom?"),
          choices = c("Yes", "No")
        )
        ),
      
      conditionalPanel(
        condition = "input.repotting1_drainage == \"No\"",
        
      # Repotting: No drainage: Check roots
        radioButtons(
          "repotting3",
          label = paste("Gently remove the plant from its pot.", 
                        "How do the roots look like?"),
          choices = c(
            "I can see no visible roots",
            "The roots are very visible"
            )
        )
      )
        )
  )
  )
  )
  
  
  # Define server logic required for the app
  server <- function(input, output) {
    
    output$image <- renderUI({
      
      # An option must be selected
      req(input$my_plant)
      
      # Path to the image file
      imagePath <- paste0(input$my_plant, ".jpg")
      
      # Check if the image file exists
      if (file.exists(file.path("www", imagePath))) {
        tags$img(src = imagePath, height = "125px")
      } else {
        tags$p("Image not found")
      }
    })
    
    output$plant_found <- renderText({
     
      # An option must be selected
      req(input$my_plant)
      
      if (input$my_plant == "My plant is not on the list") {
        stop("You plant is not in our database. Please find care guidance here: 
             https://garden.org/plants/group >> Select your plant >> 
             Select \"Visit our Plant Care Guides for...\"")
      } else {
        if (input$my_plant == "I don't know the name of my plant") {
          stop(paste("Please find the name of your plant using this free",
          "online tool: https://plant.id/. You can then return and continue", 
          "your search."))
        } 
      }
    })
    
    # Show modal dialog when "Get advice" button is pressed
    observeEvent(input$submit, {
      showModal(modalDialog(
        title = paste("Care advice for your", input$my_plant),
        p(paste("Advice selected:", paste(input$advice, collapse = ", "))),
        if("Watering" %in% input$advice) {
          
          # For the plants watered based on the "soil"
          if(!is.numeric(data[data$plant == input$my_plant, 
                        "water_amount"])) {
            
            # If the soil is wet, do not water
            if(input$water2 == "No") {
              p(paste("Your plant is fine! No water needed yet."))
            } else {
              
              # Soil is dry, no underwatering, no overwatering
              if(input$water3 == "No" & input$water4 == "No") {
                p(paste("Time to water your plant! Provide a", 
                        data[data$plant == input$my_plant, "water_amount"], 
                        "quantity."))
              } else {
                # Soil is dry, underwatering
                if(input$water3 == "Yes") {
                  p(paste("Your plant really needs water. Water",
                          "immediately with a", 
                          data[data$plant == input$my_plant, "water_amount"], 
                          "quantity."
                  )
                  )
                }
                
                # Soil is dry, overwatering 
                if(input$water3 == "Yes") {
                  p(paste("Your plant is showing sign of overwatering.",
                          "Let it be for two days, then water with a",
                          data[data$plant == input$my_plant,
                                     "water_amount"],
                          "quantity."
                  )
                  )  
                }
              }
            }
            
          } else { 
            
            # If the plant is watered based on the number of days
            
            # If the number of days was exceeded
              if(input$water1 < data[data$plant == input$my_plant,
                                     "water_amount"]) {
                p(paste("Your plant is fine! No water needed yet."))
              } else { 
                
                # Days exceeded, wet soil
                if(input$water2 == "No") {
                  p(paste("Your plant is fine! No water needed yet."))
                } else {
                  
                  # Dry soil, underwatering
                  if(input$water3 == "Yes") {
                    p(paste("Your plant really needs water.", 
                            "Water immediately with a", 
                            data[data$plant == input$my_plant, 
                                       "water_amount"], 
                            "quantity."
                    )
                    )
                  } else {
                    if (input$water4 == "Yes"){ 
                      p(paste("Your plant is showing sign of overwatering.",
                              "Wait two days, then water with a",
                              data[data$plant == input$my_plant,
                                         "water_amount"],
                              "quantity."
                      )
                      )
                    } 
                  }
                }
                
              }
            }
          },
        
        if("Light" %in% input$advice) {
          
          # If data$light matches response, don't move
          if(grep(input$light, data[data$input$my_plant, 
                                          "light"])) {
            p(paste("The light is good for your plant, don't move it."))
          } else {
            p(paste("Move your plat to a spot with",
                    data[data$input$my_plant, "light"],
                    "light."))
          }
        },
        
        easyClose = TRUE,
        footer = NULL
      )
      )
    })
    
    
  }
  
          
# Problem: Your plant is showing sign of overwatering. Let it be for two days, 
  # then water with a moderate quantity.
  # When dry, underwatered, but not overwatered
  
  
  
  # Run the application 
  shinyApp(ui = ui, server = server)
  
}

GUI()









# Problem: says overwatered too often
# Problem: Add fertilizer
# Problem: Light does not work
# Problem: Images not visible
# Problem: Style












### Database credit: Database taken from: https://plantsage.org/

### Picture credit: The plant pictures are taken from: https://plantsage.org/
  # "I don't know the name of my plant" picture taken from: 
    # https://miro.medium.com/max/4000/1*aEVMbEExBTVfvv1j4pqiPg.jpeg
  # "My plant is not in the list" picture taken from: 
    #http://clipart-library.com/data_images/109158.png