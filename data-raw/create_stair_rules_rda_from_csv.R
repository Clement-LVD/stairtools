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
#' @examples
#' \dontrun{
#' create_stair_rules_rda_from_csv()
#' }
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



#' Append new stair rules into the internal dataset
#'
#' Append one or more rows within the stair_rules dataset.
#' Dimensional requirements for stairs need: all dimensional values
#' are expressed in centimetres.
#'
#' Missing values (NA) indicate that the corresponding limit is not
#' specified by the referenced source.
#'
#' @param path `character` - Path to the stair rules CSV file.
#' @param new_rules A `data.frame` containing the new rules to append.
#'
#' @return Invisibly returns the updated data.frame.
#' @examples
#' \dontrun{
#' new_rule <- data.frame( id = c("academic_compromise", "etiological_studies", "feet_accommodation")
#' , destination = c("Generic stair principle (academic compromise)", "Generic stair principle (etiological studies)",  "Generic stair principle (adequate foot accommodation)")
#' , jurisdiction = c(NA, NA, NA)
#' , step_rise_min = c(16, NA, NA)
#' , step_rise_max = c(18.3, 19.1, NA)
#' , going_min = c(22.9, 22.9, 27.9)
#' , going_max = NA
#' , blondel_min = NA
#' , blondel_max = NA
#' , other_calcs = NA
#' , article = c("p. 39", "p. 38", "p. 38")
#' , main_source = "Templer, John A. The Staircase: Studies of Hazards, Falls, and Safer Design. 2. print. MIT Press, 1992. https://doi.org/10.7551/mitpress/6434.001.0001."
#' , url = "https://doi.org/10.7551/mitpress/6434.001.0001")
#' 
#' returned_rules <- append_stair_rules_to_csv(new_rules = new_rule)
#' }
#' @keywords internal
#' @internal
append_stair_rules_to_csv <- function(
    path = "data-raw/stair_rules.csv",
    new_rules
) {

  stair_rules <- utils::read.csv(path)

  if (!is.data.frame(new_rules)) {
    stop("`new_rules` must be a data.frame.", call. = FALSE)
  }

  if (!all(names(new_rules) %in% names(stair_rules))) {
    missing <- setdiff(names(new_rules), names(stair_rules))
    warning(
      "Unknown variable(s): ",
      paste(missing, collapse = ", "),
      ".",
      call. = FALSE
    )
    stop("Colnames within the .csv file are :", paste0(collapse = ", ", names(stair_rules)))
  }

  new_rules <- new_rules[, names(stair_rules), drop = FALSE]

  stair_rules <- rbind(stair_rules, new_rules)

  stair_rules <- unique(stair_rules)

  utils::write.csv(
    stair_rules,
    path,
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )

  invisible(stair_rules)
}
