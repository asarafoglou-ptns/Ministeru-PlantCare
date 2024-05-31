library(PlantCare)
#library(shiny)
#source("R/functions.R")

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
#' @example
#' @export
PlantCare_app <- function(data = final_data()){

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


  #Define shiny appliction
  shinyApp(ui = ui, server = server)

  runApp(appDir = "Ministeru-PlantCare/R")

}

PlantCare_app()




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
