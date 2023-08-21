
<!-- README.md is generated from README.Rmd. Please edit that file -->

# parlementr <img src="man/figures/parlementr_logo.png" width="160px" align="right" />

<!-- badges: start -->
<!-- badges: end -->

The goal of parlementr is to facilitate access from R to french
parliamentary data. Most of the functions make calls to the
nosdeputes.fr API.

## Installation

You can install the development version of parlementr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("malojan/parlementr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(parlementr)
## basic example code

get_mps(term = "15", type = "all")
#> # A tibble: 659 × 32
#>       id nom           nom_de_famille prenom sexe  date_naissance lieu_naissance
#>    <dbl> <chr>         <chr>          <chr>  <chr> <date>         <chr>         
#>  1     1 Cédric Rouss… Roussel        Cédric H     1972-10-10     Brest (Finist…
#>  2     2 Nadia Hai     Hai            Nadia  F     1980-03-08     Trappes (Yvel…
#>  3     3 Pascale Font… Fontenel-Pers… Pasca… F     1962-05-26     Mans (Sarthe) 
#>  4     4 Laurent Piet… Pietraszewski  Laure… H     1966-11-19     Saint-Denis (…
#>  5     5 Guillaume Ka… Kasbarian      Guill… H     1987-02-28     Marseille (Bo…
#>  6     6 Cyrille Isaa… Isaac-Sibille  Cyril… H     1958-04-30     Lyon 6 (Rhône)
#>  7     7 Guillaume Vu… Vuilletet      Guill… H     1967-06-20     Beauvais (Ois…
#>  8     8 Olivier Faure Faure          Olivi… H     1968-08-18     La Tronche (I…
#>  9     9 Pierre-Alain… Raphan         Pierr… H     1983-04-06     Choisy-le-Roi…
#> 10    10 Isabelle Mul… Muller-Quoy    Isabe… F     1967-11-08     Agen (Lot-et-…
#> # ℹ 649 more rows
#> # ℹ 25 more variables: num_deptmt <chr>, nom_circo <chr>, num_circo <chr>,
#> #   mandat_debut <date>, mandat_fin <date>, ancien_depute <dbl>,
#> #   groupe_sigle <chr>, parti_ratt_financier <chr>, sites_web <chr>,
#> #   emails <chr>, adresses <chr>, collaborateurs <chr>, autres_mandats <chr>,
#> #   anciens_autres_mandats <lgl>, anciens_mandats <chr>, profession <chr>,
#> #   place_en_hemicycle <dbl>, url_an <chr>, id_an <dbl>, slug <chr>, …
```
