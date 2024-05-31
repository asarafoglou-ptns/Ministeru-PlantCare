

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
#' @references Plant Sage. (n.d.). Plant Sage. Retrieved May 31, 2024, from https://plantsage.org/reference
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

  return(data)
}

?prepare_data()
