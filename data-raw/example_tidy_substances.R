## code to prepare `example_tidy_substances` dataset goes here
example_tidy_substances <- data.frame(
  athlete = c(
    "perkins, ravaughn", "gatto regonha, melissa",
    "jackson, tate", "silva, anderson", "gastelum, kelvin", "lo, wayne",
    "beckwith-ludlow, molly", "nogueira, antonio rogerio", "kimmons, trell",
    "gay, tyson"
  ), sport = c(
    "wrestling", "mixed martial arts", "swimming",
    "mixed martial arts", "mixed martial arts", "paralympic table tennis",
    "track & field", "mixed martial arts", "track & field", "track & field"
  ), substance_reason = c(
    "furosemide", "furosemide", "cannabinoids",
    "hydrochlorothiazide", "cannabinoids", "chlorothiazide", "clomiphene",
    "hydrochlorothiazide", "1,3-dimethylbutylamine", "androgenic anabolic steroid"
  ), sanction_terms = c(
    "6-month suspension - loss of results",
    "1-year suspension", "1-month suspension; loss of results", "1-year suspension",
    "6-month suspension with 3-month deferral", "public warning - loss of results",
    "public warning", "6-month suspension", "2-year suspension - loss of results",
    "2-year suspension with 1 year reduction - loss of results"
  ),
  sanction_announced = c(
    "10/16/2014", "10/17/2019",
    "04/29/2021", "07/18/2018",
    "05/11/2017", "03/09/2016",
    "05/01/2017", "04/23/2018",
    "09/27/2016", "05/02/2014"
  ), sanction_date = structure(c(
    16359, 18186, 18746, 17730, 17297, 16869, 17287, 17644, 17071, 16192
  ), class = "Date"),
  support_personnel = c(
    FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
  ), paralympic = c(
    FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE
  ), multiple_sports = c(
    FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
  ), sanction_type = c(
    "analytic", "analytic", "analytic", "analytic",
    "analytic", "analytic", "analytic", "analytic",
    "analytic", "analytic"
  ), substance_cat = c(
    "single",
    "single", "single", "multiple",
    "single", "multiple", "single",
    "single", "single", "single"
  )
)
usethis::use_data(example_tidy_substances, overwrite = TRUE)
