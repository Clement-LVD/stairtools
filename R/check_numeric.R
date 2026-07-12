#' Internal helper to validate numeric scalar inputs
check_numeric <- function(x, name) {
  if (
    length(x) != 1 ||
    !is.numeric(x) ||
    is.na(x) ||
    !is.finite(x)
  )
    stop(name, " must be a finite numeric value", call. = FALSE)
}