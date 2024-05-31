

## Create function to scrap data
#' @title Scrap and Prepare Plant Data
#' @description
#' Scraps plant data from the website https://plantsage.org/.
#' Some new columns are added; these contain the same information as in the
#' data set https://plantsage.org/ but reformulated for easier use with the
#' PlantCare app. The reformulation was done by the package maintainer.
#' @param ... Does not contain arguments. The data is manually added as a
#' JavaScript object, cleaned up, restructured, and returned as a data frame.
#' @return An 11 x 13 data frame with plant data for 11 common houseplants,
#' ready for use with the PlantCare app.
#' @examples
#' data <- prepare_data()
#' View(data)
#' @references Plant Sage. (n.d.). Plant Sage. Retrieved May 31, 2024, from https://plantsage.org/
#' @export
prepare_data <- function() {
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
  data$watering_days[grep("every 2 weeks", data$watering)] <- 14
  
  # Some plants do not have specified number of days; the soil must be checked
  data$watering_days[grep("soil", data$watering)] <- "soil"
  
  
  # Adding column: Water amount
  data <- cbind(data, water_amount = NA)
  data$water_amount[grep("Moderate",
                         data$watering, ignore.case = T)] <-
    "moderate"
  data$water_amount[grep("Low", data$watering, ignore.case = T)] <-
    "low"
  data$water_amount[grep("High", data$watering, ignore.case = T)] <-
    "high"
  data$water_amount <- ifelse(is.na(data$water_amount),
                              "moderate",
                              data$water_amount)
  
  
  # Adding column: fertilizer per month
  data <- cbind(data, f_growing = c(rep(1, 11)))
  data <- cbind(data, f_winter = c(1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0))
  data <-
    cbind(data, f_growing_months = c(0.5, 2, 4, 1, 1, 0.25, 2, 1, 1, 2,
                                     0.5))
  data <-
    cbind(data, f_winter_months = c(0.5, NA, NA, NA, NA, 1, 2, 2, NA, NA,
                                    NA))
  
  return(data)
}


## Create the Shiny app
#' @title Plant Care Shiny App
#' @description
#' An interactive app that gives advice on whether to water, fertilize, repot,
#' or change light conditions for common houseplants. The advice is
#' plant-specific.Assumes the user is close
#' to their plant, i.e., to feel whether the soil is wet and see if the
#' leaves are dry or soft. Uses data scrapped from the website
#' https://plantsage.org/.
#' @param data Can be the 11 x 13 data frame obtained from final_data() or any
#' other object. Will be overwritten immediately with the data frame obtained
#' from the final_data() function.
#' @return No return. There will be a pop-up with the user interface. Interrupt
#' R to stop the application (press "Stop" button or press Esc).
#' @examples
#' # PlantCare_app()
#' @references Plant Sage. (n.d.). Plant Sage. Retrieved May 31, 2024, from https://plantsage.org/
#' @export
PlantCare_app <- function(data = prepare_data()) {
  data <- prepare_data()
  
  # Define UI for application
  ui <- shiny::fluidPage(
    # Application title
    shiny::titlePanel("PlantCare Guide"),
    
    #Select plant from drop-down list
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        # Select plant
        shiny::selectInput(
          "my_plant",
          label = "Select your plant:",
          choices = c(
            data$plant,
            "I don't know the name of my plant",
            "My plant is not on the list"
          ),
          multiple = FALSE
        ),
        
        shiny::br(),
        # Adds space
        
        
        # Image of plant during selection
        shiny::uiOutput("image"),
        
        #Error message if the plant is not found or the name is not known
        shiny::textOutput("plant_found"),
        
        shiny::br(),
        # Adds space
        shiny::br(),
        
        # Selects which advice they want
        shiny::selectInput(
          "advice",
          label = "I want advice about:",
          choices = c("Watering", "Light", "Fertilizing", "Repotting"),
          multiple = TRUE
        ),
        
        # Action button: Restart
        shiny::actionButton(
          "restart",
          label = "Restart",
          icon = shiny::icon("rotate-right")
        ),
        
        shiny::br(),
        # Add space
        shiny::br(),
        
        # Action button: Submit
        shiny::actionButton(
          "submit",
          label = "Get advice",
          icon = shiny::icon("pagelines")
        )
        
      ),
      
      shiny::mainPanel(
        shiny::conditionalPanel(
          condition = "input.advice.includes(\"Watering\")",
          
          # Number of days since last watering
          shiny::sliderInput(
            "water1",
            label = "How many days have passed since you watered your plant?",
            min = 0,
            max = 30,
            value = 7,
            round = TRUE
          ),
          
          # Soil feels dry or not
          shiny::radioButtons(
            "water2",
            label = paste(
              "Stick your finger in the soil until your nail is",
              "completely covered. Does the soil feel dry?"
            ),
            choices = c("Yes", "No")
          ),
          
          # Signs underwatering
          shiny::radioButtons(
            "water3",
            label = paste(
              "Do the leaves seem dry and yellowing? This is a",
              "sign the plant needs water."
            ),
            choices = c("Yes", "No")
          ),
          
          # Signs overwatering
          shiny::radioButtons(
            "water4",
            label = paste(
              "Do the leaves seem soft and limp?",
              "This is a sign of overwatering."
            ),
            choices = c("Yes", "No")
          )
          
        ),
        
        shiny::conditionalPanel(
          condition = "input.advice.includes(\"Light\")",
          
          # Light
          shiny::selectInput(
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
        
        shiny::conditionalPanel(
          condition = "input.advice.includes(\"Fertilizing\")",
          
          # Fertilizer
          shiny::sliderInput(
            "fertilizer",
            label = paste(
              "How many months have passed",
              "since you last fertilized your plant?"
            ),
            min = 0,
            max = 6,
            value = 1
          )
        ),
        
        shiny::conditionalPanel(
          condition = "input.advice.includes(\"Repotting\")",
          
          # Repotting: Drainage holes
          shiny::radioButtons(
            "repotting1_drainage",
            label = "Does your pot have drainage holes?",
            choices = c("Yes", "No")
          ),
          
          shiny::conditionalPanel(
            condition = "input.repotting1_drainage == \"Yes\"",
            
            # Repotting: Drainage: Pick up
            shiny::radioButtons(
              "repotting2",
              label = paste(
                "Pick up the pot and look at the drainage holes.",
                "Do you see roots coming out the bottom?"
              ),
              choices = c("Yes", "No")
            )
          ),
          
          shiny::conditionalPanel(
            condition = "input.repotting1_drainage == \"No\"",
            
            # Repotting: No drainage: Check roots
            shiny::radioButtons(
              "repotting3",
              label = paste(
                "Gently remove the plant from its pot.",
                "How do the roots look like?"
              ),
              choices = c("I can see no visible roots",
                          "The roots are very visible")
            )
          )
        )
      )
    )
  )
  
  
  # Define server logic required for the app
  server <- function(input, output) {
    output$image <- shiny::renderUI({
      # An option must be selected
      shiny::req(input$my_plant)
      
      # Path to the image file
      imagePath <- paste0(input$my_plant, ".jpg")
      
      # Check if the image file exists
      if (file.exists(file.path("www", imagePath))) {
        tags$img(src = imagePath, height = "125px")
      } else {
        tags$p("Image not found")
      }
    })
    
    output$plant_found <- shiny::renderText({
      # An option must be selected
      shiny::req(input$my_plant)
      
      if (input$my_plant == "My plant is not on the list") {
        stop(
          "You plant is not in our database. Please find care guidance here:
             https://garden.org/plants/group >> Select your plant >>
             Select \"Visit our Plant Care Guides for...\""
        )
      } else {
        if (input$my_plant == "I don't know the name of my plant") {
          stop(
            paste(
              "Please find the name of your plant using this free",
              "online tool: https://plant.id/. You can then return and continue",
              "your search."
            )
          )
        }
      }
    })
    
    # Show modal dialog when "Get advice" button is pressed
    shiny::observeEvent(input$submit, {
      shiny::showModal(
        shiny::modalDialog(
          title = paste("Care advice for your", input$my_plant),
          p(paste(
            "Advice selected:", paste(input$advice, collapse = ", ")
          )),
          
          # Watering
          if ("Watering" %in% input$advice) {
            # If the soil is wet, do not water
            if (input$water2 == "No") {
              p(paste("Your plant is fine! No water needed yet."))
              
            } else {
              # For the plants watered based on the "soil"
              if (!is.numeric(data[data$plant == input$my_plant,
                                   "water_amount"])) {
                # Soil is dry, no underwatering, no overwatering
                if (input$water3 == "No" & input$water4 == "No") {
                  p(paste(
                    "Time to water your plant! Provide a",
                    data[data$plant == input$my_plant, "water_amount"],
                    "quantity."
                  ))
                } else {
                  # Soil is dry, underwatering
                  if (input$water3 == "Yes" & input$water4 == "No") {
                    p(
                      paste(
                        "Your plant really needs water. Water",
                        "immediately with a",
                        data[data$plant == input$my_plant, "water_amount"],
                        "quantity."
                      )
                    )
                  } else {
                    # Soil is dry, overwatering
                    p(
                      paste(
                        "Your plant is showing sign of overwatering.",
                        "Let it be for two days, then water with a",
                        data[data$plant == input$my_plant,
                             "water_amount"],
                        "quantity."
                      )
                    )
                  }
                }
              } else {
                # Plants watered depending on the number of days
                
                # Number of days not passed
                if (input$water1 < data[data$plant == input$my_plant,
                                        "water_amount"]) {
                  p(paste("Your plant is fine! No water needed yet."))
                } else {
                  # Number of days passed, no underwatering, no overwatering
                  if (input$water3 == "No" & input$water4 == "No") {
                    p(paste(
                      "Time to water your plant! Provide a",
                      data[data$plant == input$my_plant, "water_amount"],
                      "quantity."
                    ))
                  } else {
                    # Soil is dry, underwatering
                    if (input$water3 == "Yes" & input$water4 == "No") {
                      p(
                        paste(
                          "Your plant really needs water. Water",
                          "immediately with a",
                          data[data$plant == input$my_plant, "water_amount"],
                          "quantity."
                        )
                      )
                    } else {
                      # Soil is dry, overwatering
                      p(
                        paste(
                          "Your plant is showing sign of overwatering.",
                          "Let it be for two days, then water with a",
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
          
          # Light
          if ("Light" %in% input$advice) {
            # If data$light matches response, don't move
            if (length(grep(input$light,
                            data[data$plant == input$my_plant, "light"],
                            ignore.case = TRUE) != 0))
            {
              p(paste("The light is good for your plant, don't move it."))
            } else {
              p(paste("Move your plat to a spot with",
                      data[data$plant == input$my_plant, "light"],
                      "light."))
            }
          },
          
          # Fertilizer
          if ("Fertilizing" %in% input$advice) {
            # If winter
            if ((as.numeric(format(Sys.Date(), "%m")) <= 2) |
                (as.numeric(format(Sys.Date(), "%m")) >= 11)) {
              # If f_winter_months is NA, do not fertilize
              if (is.na(data[data$plant == input$my_plant, "f_winter_months"])) {
                p(
                  paste(
                    "Your plant does not need fertilizer in winter!",
                    "Try again in March."
                  )
                )
              } else {
                # If input$fertilizing > f_winter_months
                if (input$fertilizer > data[data$plant == input$my_plant,
                                            "f_winter_months"]) {
                  p(paste("It's time to fertilize your plant!"))
                } else {
                  p(
                    paste(
                      "Your plant does not need fertilizer yet.",
                      "Try again in two weeks."
                    )
                  )
                }
                
              }
            } else {
              if (input$fertilizer > data[data$plant == input$my_plant,
                                          "f_growing_months"]) {
                p(paste("It's time to fertilize your plant!"))
              } else {
                p(paste(
                  "Your plant does not need fertilizer yet.",
                  "Try again in two weeks."
                ))
              }
              
            }
          },
          
          if ("Repotting" %in% input$advice) {
            if (!is.na(input$repotting2)) {
              if (input$repotting2 == "Yes") {
                p(
                  paste(
                    "Repotting time! Transfer your plant gently to a pot",
                    "5cm wider and 5cm deeper than the current one. Check out",
                    "https://www.wikihow.com/Repot-a-Plant for step-by-step",
                    "instructions with pictures."
                  )
                )
              } else {
                p(
                  paste(
                    "Your plant is in the right-sized pot for now! Check again",
                    "in 2 months."
                  )
                )
              }
            } else {
              if (!is.na(input$repotting3)) {
                if (input$repotting3 == "I can see no visible roots") {
                  p(paste(
                    "Your plant is in the right-sized pot for now! Check again",
                    "in 2 months. HELLO"
                  )
                  )
                } else {
                  if (input$repotting3 == "The roots are very visible")
                  {
                    p(
                      paste(
                        "Repotting time! Transfer your plant gently to a pot",
                        "5cm wider and 5cm deeper than the current",
                        "one. Check out https://www.wikihow.com/Repot-a-Plant",
                        "for step-by-step instructions with pictures."
                      )
                    )
                    
        }
                }
              }
              
            }
            
            
            
            
          },
        
        easyClose = TRUE,
        footer = NULL
      )
    )
    })

  }
  
  
  #Define shiny appliction
  shiny::runApp(shiny::shinyApp(ui = ui, server = server))
  
}


# Problem: Images not visible


### Database credit: Database taken from: https://plantsage.org/

### Picture credit: The plant pictures are taken from: https://plantsage.org/
# "I don't know the name of my plant" picture taken from:
# https://miro.medium.com/max/4000/1*aEVMbEExBTVfvv1j4pqiPg.jpeg
# "My plant is not in the list" picture taken from:
#http://clipart-library.com/data_images/109158.png
