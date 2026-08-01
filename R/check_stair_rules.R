#' Check stair solutions against dimensional rules
#'
#' Checks stair solutions against a set of dimensional requirements
#' stored in the internal `stair_rules` dataset.
#'
#' The function automatically detects the dimensions defined in the selected
#' rule (for example `height`, `going`, and `blondel`) from the `_min` and
#' `_max` suffixes in `stair_rules`.
#'
#' A missing (`NA`) limit in a rule means that no constraint is specified
#' for that dimension. The corresponding check is therefore considered
#' satisfied.
#'
#' @param x A data frame containing stair solutions. Columns matching the
#'   dimensions defined in `stair_rules` are checked when available.
#'   For example, `height`, `going`, and `blondel`.
#'
#' @param rule A character string identifying the rule to apply. Must match
#'   one of the identifiers available in `stair_rules$id`.
#'
#' @return The input data frame with additional logical columns indicating
#'   whether each dimensional requirement is satisfied:
#'   \itemize{
#'     \item `height_ok`: whether the stair height satisfies the rule;
#'     \item `going_ok`: whether the going satisfies the rule;
#'     \item `blondel_ok`: whether the Blondel value satisfies the rule;
#'     \item `is_compliant`: whether all applicable requirements are satisfied.
#'   }
#'
#' A value of `TRUE` indicates that the requirement is satisfied, whereas
#' `FALSE` indicates that the requirement is not satisfied.
#'
#' @examples
#' \dontrun{
#' sol <- calculer_toutes_solutions(
#'   height_to_climb = 160,
#'   max_run = 150
#' )
#'
#' check_stair_rules(
#'   sol,
#'   "habitation_common_areas"
#' )
#'
#' ids <- stair_rules$id
#'
#' results <- sapply(ids, FUN = function(rule) {
#'   res <- check_stair_rules(sol, rule)
#'   res$is_compliant
#' })
#'
#' sol$n_rules_respected <- rowSums(results)
#' }
#'
#' @export
check_stair_rules <- function(x, rule) {

  r <- stair_rules[
    stair_rules$id == rule,
    ,
    drop = FALSE
  ]

  if (nrow(r) != 1) {
    stop("Unknown or ambiguous rule.")
  }


# get names of dimensions to test from stair_rules (internal data)
 dimensions <- unique(sub("_(min|max)$","",
    grep("_(min|max)$", names(stair_rules), value = TRUE)
    )  )


  for (d in dimensions) {

    if (d %in% names(x)) {

      x[[paste0(d, "_ok")]] <-
        check_rule_dimension(
          x[[d]],
          r,
          d
        )

    }

  }


  checks <- grep(
    "_ok$",
    names(x),
    value = TRUE
  )


  x$is_compliant <- Reduce(
    `&`,
    x[checks]
  )

  x
}
  
  
  
# get_rule_dimensions(stair_rules)
# [1] "height" "going" "blondel"
check_rule_dimension <- function(value, rule, dimension) {

  ok <- rep(TRUE, length(value))

  min_name <- paste0(dimension, "_min")
  max_name <- paste0(dimension, "_max")

  if (min_name %in% names(rule) &&
      !is.na(rule[[min_name]])) {

    ok <- ok & (
      is.na(value) |
      value >= rule[[min_name]]
    )

  }

  if (max_name %in% names(rule) &&
      !is.na(rule[[max_name]])) {

    ok <- ok & (
      is.na(value) |
      value <= rule[[max_name]]
    )

  }

  ok
}
   