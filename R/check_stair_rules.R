#' Check stair solutions against dimensional rules
#'
#' Checks stair solutions against rules stored in `stair_rules`.
#'
#' @param x A `data.frame` of stair solutions.
#' @param rule `character` - Optional rule id. If `NULL`, all rules are checked.
#'
#' @return Return the input `data.frame` with one logical column per rule and a 'n_rules_ok' and a 'rate_rules_ok' columns.
#' @examples
#' sol <- solve_stairs(160, 150)
#' check_stair_rules(sol)
#' @export
check_stair_rules <- function(x, rule = NULL) {

  rules <- stair_rules

  if (!is.null(rule)) {

    rules <- rules[rules$id == rule, , drop = FALSE]

    if (nrow(rules) != 1)
      stop("Unknown rule.")

  }

  dimensions <- unique(sub("_(min|max)$", "",  grep("_(min|max)$", names(rules), value = TRUE)  ))

  check <- function(r) {

  ok <- rep(TRUE, nrow(x))

  for (d in intersect(dimensions, names(x))) {

    min_value <- r[[paste0(d, "_min")]]
    max_value <- r[[paste0(d, "_max")]]

    if (!is.na(min_value))
      ok <- ok & (is.na(x[[d]]) | x[[d]] >= min_value)

    if (!is.na(max_value))
      ok <- ok & (is.na(x[[d]]) | x[[d]] <= max_value)
  }

  ok
}

  x[ rules$id ] <- lapply(seq_len(nrow(rules)), function(i) check(rules[i, , drop = FALSE])  )

  x$n_rules_ok <- rowSums(x[rules$id] == TRUE, na.rm = TRUE)
  
  x$rate_rules_ok <-  x$n_rules_ok  / length( rules$id )
    
  x
}