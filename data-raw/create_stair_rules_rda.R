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
create_stair_ruless_rda <- function() {

stair_rules <- data.frame(
 
  id = c(
"habitation_common_areas",
"habitation_dwellings",
"access_public_building",
"workplace_accessibility",
"erp_public_stairs",
"machinery_access"
, "private_uk", "utility_uk", "general_access_uk" 
)

, destination = c( "Common areas of collective residential buildings and individual houses" # "Parties communes des batiments d'habitation collectifs et des maisons individuelles"
  , "Interiors of dwellings" # "Interieurs des logements"
  , "Accessibility of establishments open to the public and publicly accessible facilities" # "Accessibilite aux personnes handicap'é'es des 'é'tablissements recevant du public et des installations ouvertes au public"
  , "Workplaces: occasional use of a level by persons with disabilities" # "Lieux de travail : usage occasionnel d'un niveau é desservir pour les personnes handicapees" 
  , "Straight stairs intended for public circulation"# "Escaliers droits destines a la circulation du public"
  , "Access to machinery" # "Accessing Machineries (ISO standards)"
  , "Private stair" # brit' standards
  , "Utility stair" # brit' standards
  , "General access stair" # brit' standards
  )

  , height_max = c(17, 18, 16, 16, 17, 21     , 22, 19, 17)
  , going_min =  c(28 , 24, 28, 28, 36, 19   , 22, 25, 25)
  , height_min = c( NA, NA, NA, NA, 13, NA   , 15, 15, 15)
  , going_max = c( NA, NA, NA, NA, 36, NA , 300, 400, 400 )
  , blondel_min = c( NA, NA, NA, NA, 60, NA , rep(55, 3) )
  , blondel_max = c( NA, NA, NA, NA, 64, NA , rep(70, 3) )

  , source = c("Arrêté du 24 décembre 2015, article 6-1 [building regulations in France]"
  , "Arrêté du 24 décembre 2015, article 12-1 [building regulations in France]"
  , "Arrêté du 20 avril 2017, article 7-1 [building regulations in France]"
  , "Arrêté du 27 juin 1994, article 4 [building regulations in France]"
  , "Arrêté du 23 mars 1965, article 3 [building regulations in France]"
  , "ISO 14122-3:2016 / NF EN ISO 14122-3:2017"
  , rep("Approved Document K [building regulations in England]", 3) # p. 5
          )

, url = c("https://www.legifrance.gouv.fr/loda/id/JORFTEXT000031692481"
  , "https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000031830909" 
  , "https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000034485956"
  , "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000006679776"
  , "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000020272650/"
  , "https://www.boutique.afnor.org/fr-fr/norme/nf-en-iso-141223"
  , rep("https://www.gov.uk/government/publications/protection-from-falling-collision-and-impact-approved-document-k", 3)
  )

  
 , source_type = c( "regulation", "regulation", "regulation", "regulation", "regulation", "standard", rep("regulation", 3) )

,   stringsAsFactors = FALSE


)
  

save(stair_rules,  file = "R/sysdata.rda")
}