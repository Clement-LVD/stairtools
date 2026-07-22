#' Determine the feasible numbers of steps for a given total rise
#'
#' Computes all feasible numbers of steps for a specified total rise, based on
#' the minimum and maximum allowable step heights. For each valid solution, the
#' corresponding step height and its deviation from the ideal step height are
#' calculated. Results are returned in ascending order of deviation, so the
#' first row corresponds to the solution closest to the ideal step height.
#'
#' @param hauteur_a_franchir Total rise to be climbed (cm).
#' @param h_min Minimum allowable step height (cm). Default is 16.
#' @param h_max Maximum allowable step height (cm). Default is 20.
#' @param h_ideale Ideal step height used to rank the solutions (cm). Default is 16.
#'
#' @return A \code{data.frame} with one row for each feasible solution and the
#' following columns:
#' \describe{
#'   \item{n_marches}{Number of steps.}
#'   \item{hauteur_marche}{Computed step height (cm).}
#'   \item{ecart_hauteur_ideale}{Absolute deviation from the ideal step height (cm).}
#' }
#' The rows are sorted by increasing deviation from the ideal step height.
#'
#' @examples
#' optimal_nsteps(hauteur_a_franchir = 260)
#' #   n_marches hauteur_marche ecart_hauteur_ideale
#' # 4        16       16.25000             0.250000
#'
#' @export
optimal_nsteps <- function(hauteur_a_franchir,
                                    h_min = 16,
                                    h_max = 20,
                                    h_ideale = 16) {

  if (hauteur_a_franchir <= 0) stop("hauteur_a_franchir must be positive.")
  if (h_min <= 0 || h_max <= 0 || h_min >= h_max) stop("h_min must be positive and inferior to h_max.")
  if (h_ideale < h_min || h_ideale > h_max) { warning("h_ideale is not a value within the [h_min, h_max] interval.") }

  # n marches -> hauteur = hauteur_a_franchir / n
  # on veut h_min <= hauteur <= h_max
  n_min <- ceiling(hauteur_a_franchir / h_max)
  n_max <- floor(hauteur_a_franchir / h_min)

  if (n_min > n_max) {
    stop(sprintf(
      "Aucune solution : impossible de franchir %.1f cm avec des marches entre %.1f et %.1f cm. \n==>Veuillez elargir h_min/h_max.",
      hauteur_a_franchir, h_min, h_max
    ))
  }

  n_candidats <- n_min:n_max
  hauteur_marche <- hauteur_a_franchir / n_candidats
  ecart <- abs(hauteur_marche - h_ideale)

  res <- data.frame(
    n_marches = n_candidats,
    hauteur_marche = hauteur_marche,
    ecart_hauteur_ideale = ecart
  )

  res[order(res$ecart_hauteur_ideale), , drop = FALSE]
}
