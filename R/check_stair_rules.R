#' Check stair solutions against dimensional rules
#'
#' Checks stair solutions against rules stored in `stair_rules` (rules from
#' `sysdata.rda`).
#'
#' @param x A `data.frame` of stair solutions, e.g., returned by `solve_stairs()`.
#' @param rule `character` - Optional rule id. If `NULL`, all rules are checked.
#'
#' @return The input `data.frame` with one logical column per rule,
#'   `n_rules_ok`, and `rate_rules_ok`.
#'
#' @examples
#' x <- data.frame(
#'   step_rise = c(15, 17, 19),
#'   going = c(30, 28, 25),
#'   blondel = c(60, 62, 63)
#' )
#'
#' check_stair_rules(x)
#'
#' @export
check_stair_rules <- function(
    x,
    rule = NULL,
    dimensions = c("step_rise", "going", "blondel")
) {

  rules <- stair_rules

  if (!is.null(rule)) {
    rules <- rules[rules$id == rule, , drop = FALSE]
    if (nrow(rules) != 1)
      stop("Unknown rule.")
  }

check <- function(r) {

    checks <- lapply(dimensions, function(d) {

      min <- r[[paste0(d, "_min")]]
      max <- r[[paste0(d, "_max")]]

      if (is.na(min) && is.na(max))
        return(NULL)

      if (!d %in% names(x))
        return(rep(NA, nrow(x)))

      ok <- TRUE

      if (!is.na(min))
        ok <- ok & x[[d]] >= min

      if (!is.na(max))
        ok <- ok & x[[d]] <= max

      ok
    })

    checks <- Filter(Negate(is.null), checks)

    if (!length(checks))
      return(rep(TRUE, nrow(x)))

    Reduce(`&`, checks)
  }

  x[rules$id] <- lapply(
    seq_len(nrow(rules)),
    function(i) check(rules[i, , drop = FALSE])
  )

  x$n_rules_ok <- rowSums(x[rules$id] == TRUE, na.rm = TRUE)
  x$rate_rules_ok <- x$n_rules_ok / nrow(rules)

  x
}