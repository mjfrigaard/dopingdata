support_personnel <- data.frame(athlete = "gingras, michael",
    sport = "weightlifting - athlete support personnel",
    substance_reason = "non-analytical: possession, trafficking, and administration",
    sanction_terms = "lifetime suspension with reduction to 12 years - loss of results; sanction tolled due to retirement",
    sanction_announced = "05/11/2017",
    sanction_date = structure(17297, class = "Date"),
    row.names = NULL)

track_and_field <- data.frame(athlete = "wilson, alyssa",
    sport = "track and field",
    substance_reason = "canrenone",
    sanction_terms = "public warning",
    sanction_announced = "09/18/2023",
    sanction_date = structure(19618, class = "Date"),
    row.names = NULL)

bjj_spelling <- data.frame(athlete = "galvão, micael",
    sport = "brazilian jiu-jitsu",
    substance_reason = "clomiphene",
    sanction_terms = "1-year suspension; loss of results",
    sanction_announced = "04/05/2023",
    sanction_date = structure(19452, class = "Date"),
    row.names = NULL)

paralympic <- data.frame(athlete = "brim, katerina",
    sport = "paralympic cycling",
    substance_reason = "insulin",
    sanction_terms = "1-year suspension; loss of results",
    sanction_announced = "05/23/2023",
    sanction_date = structure(19500, class = "Date"),
    row.names = NULL)

multiple_sports <- data.frame(athlete = "denney phillips, jessica",
    sport = "cycling, weightlifting",
    substance_reason = "non-analytical: use (iv)",
    sanction_terms = "14 month suspension - loss of results",
    sanction_announced = "08/24/2016",
    sanction_date = structure(17037, class = "Date"),
    row.names = NULL)

usada_test_sports <- rbind(support_personnel, track_and_field,
                          bjj_spelling, paralympic, multiple_sports)

saveRDS(object = usada_test_sports, "tests/testthat/fixtures/usada_test_sports.rds")
