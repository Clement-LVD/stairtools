# stair-design-principles

## Stair design principles

### Historical background

**Historical Approach.** The classical stair-design relationship is
commonly expressed as “the Blondel value”:

``` math
2R + G \approx L
```

where `R` is the rise and `G` is the going. Originally, Blondel
introduce[^1] an ideal value of 64.77 cm (Templer, 1992, p. 27).

**Modern Approach.** Therefore, modern approach should enlarge the
theoritical value given by Blondel:

> If we adjust for the pace of people today, depending on leg length and
> walking speed—say, 28 inches (71 cm) - and express the formula in
> today’s measures, then it would become:

``` math
2R + G \approx 71\ cm
```

> Templer, John A. The Staircase: Studies of Hazards, Falls, and Safer
> Design. 2. print. *MIT Press*, 1992.
> <https://doi.org/10.7551/mitpress/6434.001.0001>. p. 27

**Actual practices.** To the best of our knowledges, actual masonry and
carpentry guidelines introduce the ideal value at 63 cm, with acceptable
range of solution between 60 cm to 64 cm (e.g., ici ref compagnons du
devoir). Cela est en accord avec les anciennes réglementations, p. ex.
regarding old French legal guidelines, rise have to be comprise between
13 cm and 17 cm, the going have to be comprise between 28 cm and 36 cm,
and “hauteur et largeur seront liées par la relation” 0,60 m ≤ 2H + G ≤
0,64
(<https://www.legifrance.gouv.fr/loda/id/JORFTEXT000000441635/2024-04-22> -
Arrêté From the 23 mars 1965 - article CO 66).

Thus,

``` math
60≤2R+G≤64\ cm
```

**Anciennes règles Françaises : Escalier hors les normes si giron
inférieur à 28 cm. Hauteur maximale de 17 cm.**

**Modern Approach.** L’arrêté du 24 décembre 2015, article 6-1 - relatif
à l’accessibilité aux personnes handicapées des bâtiments d’habitation
collectifs et des maisons individuelles lors de leur construction -
prévoit pour les escaliers **des parties communes** une “hauteur
inférieure ou égale à 17 cm ; largeur du giron supérieure ou égale à 28
cm” (<https://www.legifrance.gouv.fr/loda/id/JORFTEXT000031692481>).

- Toujours d’après cet Arrêté du 24 décembre 2015 relatif à
  l’accessibilité aux personnes handicapées des bâtiments d’habitation
  collectifs et des maisons individuelles lors de leur construction,
  article 12.1 À l’intérieur des logements, il s’agit de marches avec
  une hauteur inférieure ou égale à 18 cm ; largeur du giron supérieure
  ou égale à 24 cm
  (<https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000031830909>).

Pour l’accessibilité aux personnes handicapées des établissements
recevant du public et des installations ouvertes au public lors de leur
aménagement, l’arrêté du 20 avril 2017, article 7-1, précise que “Les
escaliers ouverts au public dans des conditions normales de
fonctionnement” disposent de marches avec une hauteur “inférieure ou
égale à 16 cm ; la largeur du giron est supérieure ou égale à 28 cm”
(<https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000034485956>).

Enfin, pour rendre accessible les lieux de travail aux personnes
handicapées : Arrêté du 27 juin 1994 relatif aux dispositions destinées
à rendre accessibles les lieux de travail aux personnes handicapées
(nouvelles constructions ou aménagements) en application de l’article R.
235-3-18 du code du travail précise que : La hauteur maximale des
marches est de 16 centimètres ; La largeur minimale du giron des marches
est de 28 centimètres
(<https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000006679776>).

L’ancien texte était : Article CO 66 - § 3. Concernant les escaliers
droits destinés à la circulation du public, “La hauteur des marches doit
être de 13 cm au minimum et de 17 cm au maximum, par largeur de 28 cm au
minimum et de 36 cm au maximum. Hauteur et largeur seront liées par la
relation 0,60 m \<= 2 H + G \<= 0,64 m.”
(<https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000020272650/>).
Ici on précisait un minimum également, et la relatiçon 2h+G.

**Accessing Machineries.** Regarding industrial ISO standards for
accessing a machinery, the acceptable values are between 58 cm and 66 cm
(ISO 14122-3:2016, NF EN ISO 14122-3:2017).

La hauteur maximum de marche est de 21 cm et le giron minimal de 19 cm
(EN ISO 14122-3:2016, Safety of machinery - Permanent means of access to
machinery - Part 3: Stairs, stepladders and guard-rails[^2]).
Idéalement, le giron doit être compris entre 21 cm et 31 cm.

**REGLES ISO Machinery : Escalier hors-les-normes : giron inférieur a 19
cm. Hauteur maximum de 21 cm.**

**Resume.**

``` r


stair_rules <- data.frame(Destination =  c( "Parties communes des bâtiments d'habitation collectifs et des maisons individuelles", "Intérieurs des logements" , "Accessibilité aux personnes handicapées des établissements recevant du public et des installations ouvertes au public", "Lieux de travail : usage occasionnel d'un niveau à desservir pour les personnes handicapées" , "Escaliers droits destinés à la circulation du public", "Accessing Machineries (ISO standards)")
, Hauteur_max = c(17, 18, 16, 16, 17, 21)
, Giron_min =  c(28 , 24, 28, 28, 36, 19)
, Source = c("Arrêté du 24 décembre 2015, article 6-1", "Arrêté du 24 décembre 2015, article 12-1", "Arrêté du 20 avril 2017, article 7-1", "Arrêté du 27 juin 1994, article 4", "Arrêté du 23 mars 1965, article 3", "ISO 14122-3:2016 & NF EN ISO 14122-3:2017")
, url = c("https://www.legifrance.gouv.fr/loda/id/JORFTEXT000031692481", "https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000031830909" , "https://www.legifrance.gouv.fr/loda/article_lc/LEGIARTI000034485956", "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000006679776", "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000020272650/", "https://www.boutique.afnor.org/fr-fr/norme/nf-en-iso-141223"))


stair_rules[, 1:4]
#>                                                                                                             Destination
#> 1                                   Parties communes des bâtiments d'habitation collectifs et des maisons individuelles
#> 2                                                                                              Intérieurs des logements
#> 3 Accessibilité aux personnes handicapées des établissements recevant du public et des installations ouvertes au public
#> 4                           Lieux de travail : usage occasionnel d'un niveau à desservir pour les personnes handicapées
#> 5                                                                  Escaliers droits destinés à la circulation du public
#> 6                                                                                 Accessing Machineries (ISO standards)
#>   Hauteur_max Giron_min                                    Source
#> 1          17        28   Arrêté du 24 décembre 2015, article 6-1
#> 2          18        24  Arrêté du 24 décembre 2015, article 12-1
#> 3          16        28      Arrêté du 20 avril 2017, article 7-1
#> 4          16        28         Arrêté du 27 juin 1994, article 4
#> 5          17        36         Arrêté du 23 mars 1965, article 3
#> 6          21        19 ISO 14122-3:2016 & NF EN ISO 14122-3:2017
```

**Stair comfort.** Pour le DTU français, il y a 3 classes de confort
d’escaliers:

1.  Raide 1.32 \> H/G \> 1
2.  Courant 1 \> H/G \> 0.78
3.  Confortable H/G \< 0.78

Avec H hauteur de marche et G Giron.

*Ici pente en degrés !*

**Experimental Research.**

Experimental research has subsequently investigated stair dimensions
using several criteria, including energy expenditure, biomechanical
constraints, perceived difficulty and fall risk.

> A reasonable compromise would be a stair with risers that are not less
> than 6.3 inches (16 cm) to suit ascent, and risers not more than 7.2
> inches (18.3 cm) and goings greater than 9 inches (22.9 cm) to suit
> descent (Templer, 1992, p. 39).

> • In terms of gait, risers should be 6.3 to 7.2 inches (16-18.3 cm)
> and goings should not be less than 9 inches (22.9 cm).
>
> • The etiological studies suggest that risers should not exceed 7.5
> inches (19.1 cm) and goings should not be less than 9 inches (22.9
> cm).
>
> • To accommodate feet adequately, goings should not be less than 11
> inches (27.9 cm).
>
> Templer, John A. The Staircase: Studies of Hazards, Falls, and Safer
> Design. 2. print. *MIT Press*, 1992.
> <https://doi.org/10.7551/mitpress/6434.001.0001>. p. 38

### Ergonomic research

Theoritical lab’ values : cm Rise Goings 18.3 27.9 17.8 27.9 16.5 27.9
29.2 30.5 31.8 15.2 27.9 29.2 30.5 31.8 33.0 34.3 35.6 14.0 27.9 29.2
30.5 31.8 33.0 12.7 27.9 29.2 30.5 11.7 27.9

p. 39

[^1]: “Blondel probably referred to the French (pre-Revolutionary) royal
    inch” (Templer, 1992, p. 27).

[^2]: French equivalent to EN ISO 14122-3:2016 is NF EN ISO
    14122-3:2017.
