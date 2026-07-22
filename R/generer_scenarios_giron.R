#' Génère les scénarios de giron possibles pour un nombre de marches donné
#'
#' Pour un \code{n_marches} et son \code{giron_standard} (Blondel), génère
#' systématiquement 5 scénarios de giron, sans en privilégier aucun (le choix
#' se fait plus tard, en comparant \code{ecart_blondel} et
#' \code{distance_utilisee} entre scénarios) :
#'
#' \describe{
#'   \item{sans_palier_blondel}{Girons standards (Blondel), pas de marche
#'     palière. La dernière contremarche arrive directement sur le palier.}
#'   \item{sans_palier_uniforme}{Un giron uniforme = \code{distance_max / n_girons},
#'     sans respecter Blondel, pour occuper tout l'espace sans marche palière.}
#'   \item{avec_palier_standard}{Girons standards + une marche palière (après
#'     la dernière contremarche, au niveau du palier) au giron standard aussi :
#'     du surplus d'espace peut rester.}
#'   \item{avec_palier_max}{Girons standards + une marche palière qui absorbe
#'     tout l'espace restant (giron potentiellement très grand : rebouchage de
#'     trémie, giga-palier devant une porte, etc.).}
#'   \item{avec_palier_uniforme}{Un giron uniforme = \code{distance_max / n_marches},
#'     appliqué à toutes les marches y compris la marche palière.}
#' }
#'
#' Dans tous les scénarios "avec palière", la marche palière est la dernière,
#' positionnée après la dernière contremarche, à la même hauteur que le sol
#' fini d'arrivée — jamais suivie d'une contremarche.
#'
#' \code{ecart_blondel} ne porte que sur les girons de type "standard" : le
#' giron de la marche palière est exclu du calcul, puisqu'on est déjà au
#' niveau du sol fini en y posant le pied (son giron n'affecte pas le confort
#' de la montée, quelle que soit sa valeur).
#'
#' Si l'espace ne permet pas un scénario (giron palière négatif ou nul), il
#' est quand même renvoyé, avec \code{palier_impossible = TRUE} et/ou
#' \code{depasse_espace = TRUE} : rien n'est masqué, tout est laissé pour
#' comparaison ultérieure.
#'
#' @param n_marches Nombre de contremarches.
#' @param distance_max Distance horizontale disponible (cm).
#' @param giron_standard Giron issu de \code{\link{giron_blondel}} (cm).
#'
#' @return Une liste nommée de 5 scénarios (liste vide si \code{n_marches <= 1}).
#'   Chaque scénario contient : \code{girons}, \code{type_girons},
#'   \code{distance_utilisee}, \code{ecart_blondel} (écart moyen absolu au
#'   giron standard, sur les girons "standard" uniquement), et selon le cas
#'   \code{depasse_espace} et/ou \code{palier_impossible}.
#'
#' @examples
#' giron_standard <- giron_blondel(16.25)  # 30.5
#' scenarios <- generer_scenarios_giron(n_marches = 16, distance_max = 450,
#'                                       giron_standard = giron_standard)
#' names(scenarios)
#' scenarios$avec_palier_max$giron_paliere <- tail(scenarios$avec_palier_max$girons, 1)
#' scenarios$avec_palier_max$ecart_blondel  # 0 : la palière géante n'entre pas dans le calcul
#'
#' @export
generer_scenarios_giron <- function(n_marches, distance_max, giron_standard) {

  n_girons <- n_marches - 1
  if (n_girons <= 0) {
    return(list())
  }

  # N'évalue l'écart à Blondel que sur les girons "standard" (montée réelle) ;
  # le giron de la marche palière est exclu (déjà au niveau du sol fini).
  ecart_blondel <- function(girons, type_girons) {
    mean(abs(girons[type_girons == "standard"] - giron_standard))
  }

  scenarios <- list()

  # 1. Sans palière, Blondel (escalier "classique")
  girons_1 <- rep(giron_standard, n_girons)
  types_1 <- rep("standard", n_girons)
  distance_1 <- sum(girons_1)
  scenarios$sans_palier_blondel <- list(
    girons = girons_1,
    type_girons = types_1,
    distance_utilisee = distance_1,
    depasse_espace = distance_1 > distance_max,
    ecart_blondel = ecart_blondel(girons_1, types_1)
  )

  # 2. Sans palière, giron uniforme (hors Blondel, occupe tout l'espace)
  giron_unif_sans <- distance_max / n_girons
  girons_2 <- rep(giron_unif_sans, n_girons)
  types_2 <- rep("standard", n_girons)
  scenarios$sans_palier_uniforme <- list(
    girons = girons_2,
    type_girons = types_2,
    distance_utilisee = distance_max,
    depasse_espace = FALSE,
    ecart_blondel = ecart_blondel(girons_2, types_2)
  )

  # 3. Avec palière standard (giron palière = giron standard ; surplus possible)
  girons_3 <- c(girons_1, giron_standard)
  types_3 <- c(rep("standard", n_girons), "paliere")
  distance_3 <- sum(girons_3)
  scenarios$avec_palier_standard <- list(
    girons = girons_3,
    type_girons = types_3,
    distance_utilisee = distance_3,
    depasse_espace = distance_3 > distance_max,
    ecart_blondel = ecart_blondel(girons_3, types_3)
  )

  # 4. Avec palière, occupant tout l'espace restant ("giga-palier")
  extension_max <- distance_max - distance_1
  girons_4 <- c(girons_1, extension_max)
  types_4 <- c(rep("standard", n_girons), "paliere")
  scenarios$avec_palier_max <- list(
    girons = girons_4,
    type_girons = types_4,
    distance_utilisee = distance_1 + max(extension_max, 0),
    palier_impossible = extension_max <= 0,
    ecart_blondel = ecart_blondel(girons_4, types_4)
  )

  # 5. Avec palière, giron uniforme (toutes les marches, y compris la palière)
  giron_unif_avec <- distance_max / n_marches
  girons_5 <- rep(giron_unif_avec, n_marches)
  types_5 <- c(rep("standard", n_marches - 1), "paliere")
  scenarios$avec_palier_uniforme <- list(
    girons = girons_5,
    type_girons = types_5,
    distance_utilisee = distance_max,
    depasse_espace = FALSE,
    ecart_blondel = ecart_blondel(girons_5, types_5)
  )

  scenarios
}

