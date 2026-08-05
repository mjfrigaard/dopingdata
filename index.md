# dopingdata

![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

Lifecycle: experimental

`dopingdata` contains data from the [United States Anti-Doping
Agency](https://en.wikipedia.org/wiki/United_States_Anti-Doping_Agency)
for exploration, modeling, and visualizations. The datasets in this
package are derived from from the [USADA
website](https://www.usada.org/) and the [World Anti-Doping Agency
(WADA) banned substances
list](https://www.wada-ama.org/en/prohibited-list?q=). Scraping,
processing, and visualizing these data presented so many unique
challenges I decided to combine the utilities into a package.

## Installation

You can install the development version of `dopingdata` like so:

``` r

# install.packages("pak")
pak::pak("mjfrigaard/dopingdata")
```

``` r

library(dopingdata)
#> 
#> Attaching package: 'dopingdata'
#> The following object is masked _by_ '.GlobalEnv':
#> 
#>     %nin%
```

![Bar chart of the top ten sports with the most USADA
sanctions](reference/figures/top10_sports-1.png)

Bar chart of the top ten sports with the most USADA sanctions

![Heatmap of WADA substance categories by sport, for the four
most-sanctioned sports](reference/figures/heatmap_substances-1.png)

Heatmap of WADA substance categories by sport, for the four
most-sanctioned sports

![Waffle chart of common WADA banned substances in weightlifting
sanctions](reference/figures/waffle_weightlifting-1.png)

Waffle chart of common WADA banned substances in weightlifting sanctions
