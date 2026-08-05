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
create_stair_rules_rda <- function() {

stair_rules <- data.frame(
 
  id = c( 
# US
  "US_ADA_public_stairs"
  ,  "US_ADA_pool_stairs"
  ,  "US_ADA_pool_transfer_steps"
  , "US_IBC_means_of_egress" 
  , "US_IBC_dwelling_units"
  , "US_IBC_guard_towers_obeservation_stations_and_control_rooms"
, "US_IRC_means_of_egress"
  , "US_IRC_sleeping_loft", 

    # france
"FR_collective_housing_common_areas",
"FR_private_dwelling_interior",
"FR_ERP_accessibility",
"FR_workplace_accessibility",
"FR_public_circulation_stairs",
  
  # iso
"ISO_machinery_access"
  
  # uk
, "UK_private", "UK_utility", "UK_general_access" 
)

, destination = c("State and local government facilities, public accommodations, and commercial facilities (ADA)"
   , "Pool stairs (ADA)"
  , "Pool transfer steps (ADA)"

  ,  "Means of egress (IBC)"
  , "Dwelling units (IBC)"
  , "Guard towers, observation stations and control rooms (IBC)"
 , "Means of egress (IRC)"
 , "Sleeping loft"
  
  , "Common areas of collective residential buildings and individual houses" # "Parties communes des batiments d'habitation collectifs et des maisons individuelles"
  , "Interiors of dwellings" # "Interieurs des logements"
  , "Establishments open to the public and publicly accessible facilities" # "Accessibilite aux personnes handicap'é'es des 'é'tablissements recevant du public et des installations ouvertes au public"
  , "Workplaces: occasional use by persons with disabilities" # "Lieux de travail : usage occasionnel d'un niveau a desservir pour les personnes handicapees" 
  , "Public circulation"# "Escaliers droits destines a la circulation du public"
  
  # iso
  , "Access to machinery" # "Accessing Machineries (ISO standards)"
  
  # uk
  , "Private stair" # brit' standards
  , "Utility stair" # brit' standards
  , "General access stair" # brit' standards
  )

  , jurisdiction = c( rep("United States",8), rep("France", 5 ), "International", rep("United Kingdom", 3))
  
  , step_rise_min = c(10, NA , NA, NA, NA , 10.2, NA , 17.8, NA, NA, NA, NA, 13, NA   , 15, 15, 15)

  , step_rise_max = c(18, NA , NA, 20.3, 19.7 , 17.8, 19.6 ,  30.5 , 17, 18, 16, 16, 17, 21     , 22, 19, 17)
  , going_min =  c(28, 28, 35.5 , 22.9, 25.4 , 27.9, 25.4 ,  NA, 28 , 24, 28, 28, 36, 19   , 22, 25, 25)
  , going_max = c(NA, NA, 43 ,  NA, NA , NA, NA , NA, NA, NA, NA, NA, 36, NA , 30, 40, 40 )
  , blondel_min = c(NA, NA , NA ,  NA, NA , NA, NA,NA, NA, NA, NA, NA, 60, NA , rep(55, 3) )
  , blondel_max = c(NA, NA , NA , NA, NA , NA, NA, NA, NA, NA, NA, NA, 64, NA , rep(70, 3) )
 
  , other_calcs = c(NA, NA, NA, NA, NA, NA, NA, "1. The trad depth shall be 508 mm minus four-thirds of the riser height OR 2. The riser height shall be 381 mm minus three-fourths of the tread depth", rep(NA, 9))
  
  , article = c("ADA 2010 - Articles 504.2", "ADA 2010 - Articles 1009.6.1",  "ADA 2010 - Articles 1009.5.4"
  ,  rep("IBS 2021 - Chapter 10, articles 1011.5.2", 3)
   ,  "IRC 2024 - Chapter 3, articles R318.7"
  , "IRC 2024 - Chapter 3, articles R315.5"
  ,  "Arrêté du 24 décembre 2015, article 6-1 [building regulations in France]"
  , "Arrêté du 24 décembre 2015, article 12-1 [building regulations in France]"
  , "Arrêté du 20 avril 2017, article 7-1 [building regulations in France]"
  , "Arrêté du 27 juin 1994, article 4 [building regulations in France]"
  , "Arrêté du 23 mars 1965, article 3 [former building regulations in France]"
  , "ISO 14122-3:2016 / NF EN ISO 14122-3:2017"
  , rep("Approved Document K [building regulations in England]", 3) # p. 5
          )

          , main_source = c(rep("ADA Standards for accessible design (2010)",3), rep("International Building Code 2021 (IBC)", 3)
           ,  rep("International Residential Code 2024 (IRC)", 2)
          , rep("Building regulations in France", 5)
        , "ISO standards"
     ,  rep("Building regulations in England", 3))

, url = c("https://www.ada.gov/law-and-regs/design-standards/2010-stds/#inPageResult4#section95"
  , rep("https://www.ada.gov/law-and-regs/design-standards/2010-stds/#inPageResult13#section144", 2)
  , rep("https://codes.iccsafe.org/content/IBC2018P6/chapter-10-means-of-egress#IBC2018P6_Ch10_Sec1011.5.2", 3)
  , rep("https://codes.iccsafe.org/content/IRC2024P2/chapter-3-building-planning", 2)
  , "https://www.legifrance.gouv.fr/loda/id/JORFTEXT000031692481"
  , "https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000031830909" 
  , "https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000034485956"
  , "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000006679776"
  , "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000020272650/"
  , "https://www.boutique.afnor.org/fr-fr/norme/nf-en-iso-141223"
  , rep("https://www.gov.uk/government/publications/protection-from-falling-collision-and-impact-approved-document-k", 3)

  
  )

,   stringsAsFactors = FALSE


)
  
 # adding a - deduced - blondel value interval 
stair_rules <- transform(stair_rules,
  deduced_blondel_min = ifelse(is.na(step_rise_min) | is.na(going_min), NA_real_, 2 * step_rise_min + going_min),
  deduced_blondel_max = ifelse(is.na(step_rise_max) | is.na(going_max), NA_real_, 2 * step_rise_max + going_max)
)
  

save(stair_rules,  file = "R/sysdata.rda")
}
