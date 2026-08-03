#' Stair terminology
#'
#' This page describes the terminology and naming conventions used
#' throughout \pkg{stairtools} to represent stair geometry.
#'
#' 
#' ![](stair-terminology.png "Stair geometry terminology")
#'
#' The package uses the following conventions:
#'
#' \itemize{
#'   \item \code{total_height}: total vertical distance between the lower
#'   and upper finished floors;
#'
#'   \item \code{rise}: vertical height of one riser;
#'
#'   \item \code{n_risers}: number of risers required to reach the upper
#'   floor;
#'
#'   \item \code{going}: horizontal depth of one tread;
#'
#'   \item \code{horizontal_run}: total horizontal footprint of the
#'   staircase.
#' 
#'   \item \code{landing}:
#'   Horizontal platform reached at the end of a staircase.
#'   The last going may lead either to a landing or directly to the upper
#'   finished floor.
#' }
#'
#' A \emph{riser} is the vertical element between two consecutive treads.
#' A \emph{going} refers to the horizontal depth of a \emph{tread} (horizontal surface of a step).
#'
#'
#' A complete step is composed of one riser and one tread. The package
#' uses \code{n_risers} rather than "number of steps" because the number
#' of vertical increments is the quantity required to compute the total
#' height of a staircase.
#'
#' Stair comfort is commonly evaluated using Blondel's formula:
#'
#' \deqn{2 \times rise + going}
#'
#' where \code{rise} and \code{going} are expressed in centimetres.
#'
#' @name stair_terminology
NULL