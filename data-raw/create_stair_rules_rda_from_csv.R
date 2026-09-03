#' Create the stair rules dataset
#'
#' Creates the stair_rules dataset containing dimensional requirements
#' for stairs from regulatory texts, standards, and other reference
#' documents. All dimensional values are expressed in centimetres.
#'
#' Missing values (NA) indicate that the corresponding limit is not
#' specified by the referenced source.
#'
#' @return A data frame containing one row per reference rule. 
#' @keywords internal
#' @internal
create_stair_rules_rda_from_csv <- function() {

stair_rules <- utils::read.csv("data-raw/stair_rules.csv")
  
 # adding a - deduced - blondel value interval 
stair_rules <- transform(stair_rules,
  deduced_blondel_min = ifelse(is.na(step_rise_min) | is.na(going_min), NA_real_, 2 * step_rise_min + going_min),
  deduced_blondel_max = ifelse(is.na(step_rise_max) | is.na(going_max), NA_real_, 2 * step_rise_max + going_max)
)
  

save(stair_rules,  file = "R/sysdata.rda")
}
