usada_test_raw <- data.frame(Athlete = c(
  "*Name Removed", "*Name Removed",
  "Barnett, Josh", "Hearn, Timothy", "*Name Removed", "*Name Removed",
  "De Souza, Jose", "*Name Removed", "*Name Removed", "Benoit, Ryan",
  "*Name Removed", "Burka Gameda, Gebo", "Walker, Gregory", "Carnes, Andrew",
  "*Name Removed", "Kynard, Erik", "Penne, Jessica", "*Name Removed",
  "Smith, Braxton", "Carrillo, Michel", "Harroufi, Ridouane", "*Name Removed",
  "Ives, Kevin", "Thomas, Tammy", "da Silva, Jonnatas Gracie Araujo",
  "*Name Removed", "Erickson, Sarah", "Webb, Craig", "Jackson, Tate",
  "Klier, Andreas", "Alvis, Juancamilo Ronderos", "North, Jonathan",
  "*Name Removed", "Martin, James", "Tran, Hillary", "*Name Removed",
  "Block, Mark", "*Name Removed", "*Name Removed", "Monastyrskyi, Andrii",
  "*Name Removed", "*Name Removed", "Downing, Tricia", "*Name Removed",
  "Perry, Brett", "Denney Phillips, Jessica", "Mulwitz, Lauren",
  "*Name Removed", "Casey, Cortney", "Ramos, Don", "Lesnar, Brock",
  "Y Frederico Salvador de Lemos, Giacomo", "Ngetich, Eliud", "Anderson, Robert",
  "Magomedov, Ruslan", "Thompson, Lenroy", "*Name Removed", "Leinders, Geert",
  "Browne, Richard", "Jay-Rayon, Cyril", "*Name Removed", "Brown, Jeffrey",
  "Ferraro,  Anthony", "*Name Removed", "Ortiz, Robert", "*Name Removed",
  "*Name Removed", "Hu, Yaozong", "Herbert, Zack", "McGillivray, Deanna",
  "Arias, Luis", "Brown, Matthew", "*Name Removed", "de Tomas, Carls John",
  "Dosterschill, Robert Kyle", "Maia, Jennifer", "Cutelaba, Ion",
  "Gorgees, Alex", "*Name Removed", "Atkinson, Annie", "Sisson, Josh",
  "Pennington, Raquel", "Lopez, Enrique", "Wood, Jonathan", "Borrego Lee, Geony",
  "Oliveira, Flavia", "Sekulic, Stefan", "Carlin, Nikki", "Saint Preux, Ovince",
  "*Name Removed", "Branch, David", "Baatz, Robert", "Wethington, Madeline",
  "*Name Removed", "Duhon, Byron", "Murzakanov, Azamat", "Magomedov, Ruslan",
  "*Name Removed", "Hunter, Adam", "Hisaka, Scott"
), Sport = c(
  "Mixed Martial Arts",
  "Track and Field", "Mixed Martial Arts", "Weightlifting", "Skiing and Snowboarding",
  "Fencing", "Mixed Martial Arts", "Taekwondo", "Track and Field",
  "Mixed Martial Arts", "Figure Skating", "Track and Field", "Para Track and Field",
  "Track and Field", "Cycling", "Track and Field", "Mixed Martial Arts",
  "Wrestling", "Mixed Martial Arts", "Cycling", "Track and Field",
  "Track and Field", "Bobsled and Skeleton", "Cycling", "Brazilian Jiu-Jitsu",
  "Cycling", "Ice Hockey", "Cycling", "Swimming", "Cycling", "Mixed Martial Arts",
  "Weightlifting", "Paralympic Track and Field", "Cycling", "Weightlifting",
  "Cycling", "Track and Field - Athlete Support Personnel", "Track and Field",
  "Cycling", "Canoe", "Track and Field", "Taekwondo", "Para Shooting",
  "Roller Sports", "Speedskating", "Cycling, Weightlifting", "Cycling",
  "Cycling", "Mixed Martial Arts", "Weightlifting", "Mixed Martial Arts",
  "Mixed Martial Arts", "Track and Field", "Paralympic Judo", "Mixed Martial Arts",
  "Boxing", "Softball", "Cycling - Athlete Support Personnel",
  "Para Track and Field", "Cycling", "Track and Field", "Track and Field",
  "Paralympic Judo", "Shooting", "Weightlifting", "Weightlifting",
  "Bobsled and Skeleton", "Mixed Martial Arts", "Weightlifting",
  "Team Handball", "Boxing", "Paralympic Track and Field", "Weightlifting",
  "Mixed Martial Arts", "Weightlifting", "Mixed Martial Arts",
  "Mixed Martial Arts", "Mixed Martial Arts", "Track and Field",
  "Judo", "Paralympic Judo", "Mixed Martial Arts", "Cycling", "Cycling",
  "Cycling", "Cycling", "Mixed Martial Arts", "Weightlifting",
  "Mixed Martial Arts", "Track and Field", "Mixed Martial Arts",
  "Cycling", "Ice Hockey", "Paralympic Track and Field, Paralympic Triathlon",
  "Track and Field", "Mixed Martial Arts", "Mixed Martial Arts",
  "Bobsled and Skeleton", "Mixed Martial Arts", "Weightlifting"
), Substance.Reason = c(
  "Clenbuterol", "Amphetamine", "Ostarine",
  "19-norandrosterone (19-NA); Trenbolone; Clomiphene; GW1516; Non-Analytical: Use (IV and Blood Transfusion)",
  "Cannabinoids", "L-methamphetamine", "19-norandrosterone; 19-noretiocholanolone",
  "L-Methamphetamine", "Cannabinoids", "Modafinil", "Non-Analytical: Refusal to Submit to Sample Collection",
  "Prednisone", "Cannabinoids", "Non-Analytical: Possession, Use and Possession (EPO)",
  "Androgenic Anabolic Steroid", "Non-Analytical: Use (IV)", "Stanozolol",
  "Metoprolol", "Testosterone", "Erythropoietin (EPO); 19‐norandrosterone (19‐NA); Androgenic-anabolic steroids (AAS); Clostebol, Testosterone",
  "Androgenic Anabolic Steroid", "Ephedrine", "Non-Analytical: 3 Whereabouts Failures",
  "Norbolethone", "19-norandrosterone (19-NA); Testosterone", "Cannabinoids",
  "Non-Analytical: 3 Whereabouts Failures", "Non-Analytical: Refusal to Submit to Sample Collection",
  "Cannabinoids", "Non-Analytical: Use (EPO, hGH, Cortisone, Blood Tranfusions)",
  "Cocaine", "Non-Analytical: 3 Whereabouts Failures", "Non-Analytical: Refusal to Submit to Sample Collection",
  "Non-Analytical: Failure to Appear to Sample Collection", "Cocaine; D-methamphetamine",
  "Cannabinoids", "Non-Anatlyical: Administration and Trafficking",
  "Modafinil", "19-norandrosterone (19-NA) and 19-noretiocholanolone",
  "Meldonium", "Cannabinoids", "Cannabinoids", "Androgenic Anabolic Steroid",
  "Androgenic Anabolic Steroid, 19-Norandrosterone (19-NA), and Human Chorionic Gonadotrophin (hCG)",
  "Methylphenidate and its metabolite", "Non-Analytical: Use (IV)",
  "Cannabinoids", "Androgenic Anabolic Steroid", "BPC-157", "Androgenic Anabolic Steroid",
  "Clomiphene", "Drostanolone", "Nandrolone", "Non-Analytical: Use (Vilanterol)",
  "Ostarine", "Non-Analytical: 3 Whereabouts Failures", "19-norandrosterone and 19-noretiocholanolone",
  "Non-Analytical: Possession, Trafficking, and Administration",
  "Cannabinoids", "Modafinil", "Ephedrine", "Non-Analytical: Tampering, Administration (IV), and Complicity (Testosterone)",
  "Cannabinoids", "Hydrochlorothiazide and Chlorothiazide", "Cannabinoids",
  "Cannabinoids", "Elevated T/E", "Androsta-3,5-diene-7,17-dione",
  "Non-Analytical: Refusal to Submit to Sample Collection", "Trenbolone, Epitrenbolone",
  "Non-Analytical: 3 Whereabouts Failures", "Cannabinoids", "Elevated T/E",
  "Furosemide", "Androgenic Anabolic Steroid, Amphetamine, Drostanolone, Mesterolone and dehydrochloromethyltestosterone (DHCMT)",
  "Furosemide; Hydrochlorothiazide; Chlorothiazide; Thiazide metabolite 4-amino-6-chloro-1,3-benzenedisulfonamide (ACB)",
  "Non-Analytical: Blood Transfusion", "Drostanolone; Dehydrochloromethyltestosterone (DHCMT)",
  "Cannabinoids", "Hydrochlorothiazide, Chlorothiazide, Triamterene, 4-hydroxytriamterene",
  "Non-Analytical: Refusal to Submit to Sample Collection", "7-keto-DHEA; AOD-9064",
  "Erythropoietin (EPO)", "Androgenic Anabolic Steroid", "Phentermine",
  "Oxilofrine", "Drostanolone; Metandienone", "Clenbuterol, and Oxandrolone and its metabolite",
  "3α-hydroxy-5α-androst-1-en-17-one", "Zeranol", "Ipamorelin",
  "Androgenic Anabolic Steroid", "Spironolactone", "Oxilofrine",
  "Non-Analytical: Refusal to Submit to Sample Collection", "Boldenone",
  "Methyltestosterone; Stanozolol", "Elevated T/E", "Tamoxifen; Boldenone, Methandienone, Drostanolone, and Clenbuterol",
  "Non-Analytical: Possession and Use/Attempted Use"
), Sanction.Terms = c(
  "No Fault or Negligence",
  "2-Year Suspension - Loss of Results", "Public Warning", "3-Year Suspension; Loss of Results",
  "3-Month Suspension - Loss of Results", "Public Warning - Loss of Results",
  "2-Year Suspension", "3-Month Suspension with 3-Month Deferral - Loss of Results",
  "Public Warning - Loss of Results", "10-Month Suspension", "2-Year Suspension - Loss of Results",
  "18-Month Suspension - Loss of Results", "3-Month Suspension; Loss of Results",
  "2-Year Suspension - Loss of Results", "2-Year Suspension - Loss of Results",
  "6-Month Suspension", "20-Month Suspension", "3-Month Suspension with 3-Month Deferral - Loss of Results",
  "2-Year Suspension", "4-Year Suspension; Loss of Results", "8-Year Suspension; Loss of Results",
  "9-Month Suspension with 3 Months Deferral - Loss of Results",
  "1-Year Suspension - Loss of Results", "Lifetime Ban - Loss of Results - Sanction Reduced",
  "3-Year Suspension; Loss of Results", "1-Year Suspension - Loss of Results",
  "1-Year Suspension - Loss of Results", "4-Year Suspension - Loss of Results",
  "1-Month Suspension; Loss of Results", "6-Month Suspension - Loss of Results",
  "1-Month Suspension", "2-Year Suspension - Loss of Results; Sanction tolled due to retirement; Unretired - Eligible to compete starting 2/1/2019",
  "2-Year Suspension - Loss of Results", "2-Year Suspension - Loss of Results",
  "1-Year Suspension; Loss of Results", "3-Month Suspension with 3-Month Deferral - Loss of Results",
  "10 Year Suspension", "Public Warning - Loss of Results", "8-Month Suspension - Loss of Results",
  "3-Year Suspension; Loss of Results", "3-Month Suspension with 3-Month Deferral - Loss of Results",
  "3-Month Suspension with 3-Month Deferral - Loss of Results",
  "2-Year Suspension", "2-Year Suspension - Loss of Results", "9-Month Suspension - Loss of Results",
  "14 Month Suspension - Loss of Results", "6-Month Suspension with 3-Month Deferral - Loss of Results",
  "2-Year Sanction with 30% Reduction - Loss of Results", "4-Month Suspension",
  "2-Year Suspension - Loss of Results", "1-Year Suspension", "2-Year Suspension",
  "1-Year Suspension; Loss of Results", "3-Month Suspension - Loss of Results",
  "2-Year Suspension", "1-Year Suspension - Loss of Results", "2-Year Suspension - Loss of Results",
  "Lifetime Suspension", "3-Month Suspension; Loss of Results",
  "18-Month Suspension - Loss of Results", "Public Warning - Loss of Results",
  "4-Year Suspension", "6-Month Suspension with 3-Month Deferral - Loss of Results",
  "6-Month Suspension - Loss of Results", "12-Month Suspension with 6-Month Deferral; Loss of Results",
  "9-Month Suspension with 3-Month Deferral - Loss of Results; Second Violation",
  "2-Year Suspension - Loss of Results", "10-Month Suspension",
  "2-Year Suspension - Loss of Results; Sanction tolled due to retirement; Unretired - Eligible to compete starting 3/7/2020",
  "2-Year Suspension - Loss of Results", "1-Year Suspension - Loss of Results",
  "3-Month Suspension with 3-Month Deferral - Loss of Results",
  "2-Year Suspension - Loss of Results", "1-Year Suspension", "4-Year Suspension - Loss of Results",
  "6-Month Suspension", "6-Month Suspension", "16-Month Suspension",
  "Public Warning - Loss of Results", "3-Month Suspension - Loss of Results",
  "4-Year Suspension; Loss of Results", "6-Month Suspension", "4-Year Suspension - Loss of Results",
  "2-Year Suspension;  Loss of Results", "3-Year Suspension; Loss of Results",
  "18-Month Suspension - Loss of Results", "2-Year Suspension",
  "2-Year Suspension - Loss of Results; sanction tolled due to a whereabouts compliance failure",
  "6-Month Suspension", "No Fault or Negligence - Loss of Results",
  "2-Year Suspension", "2-Year Suspension - Loss of Results", "Public Warning",
  "6-Month Suspension - Loss of Results", "2-Year Suspension - Loss of Results",
  "2-Year Suspension", "Lifetime Suspension", "2-Year Suspension - Loss of Results",
  "2-Year Suspension - Loss of Results - Additional Loss of Results",
  "4-Year Suspension; Loss of Results"
), Sanction.Announced = c(
  "",
  "", "03/23/2018", "09/06/2022", "", "", "06/01/2023", "", "",
  "11/08/2021", "", "08/19/2016", "08/16/2022", "04/18/2014", "",
  "05/27/2022", "02/28/2020", "", "06/27/2023", "01/18/2019", "09/24/2020",
  "", "07/08/2014", "Original: 08/30/2002; Updated: 02/13/2017",
  "03/08/2023", "", "10/13/2014", "01/26/2018", "04/29/2021", "08/15/2013",
  "07/29/2021", "01/22/2015", "", "08/19/2014", "10/28/2021", "",
  "03/17/2011", "", "", "06/02/2022", "", "", "05/09/2022", "",
  "02/26/2014", "08/24/2016", "09/11/2015", "", "09/14/2023", "08/30/2013",
  "01/04/2017", "10/24/2019", "Original: 09/03/21; Updated: 01/25/22",
  "08/04/2016", "02/15/2018", "02/26/2012", "", "01/22/2015", "09/07/2022",
  "12/31/2012", "", "09/30/2019", "08/08/2018", "", "05/04/2020",
  "", "", "06/14/2019", "08/22/2017", "04/02/2015", "02/24/2012",
  "07/18/2011", "", "02/05/2018", "05/31/2017", "01/15/2019", "03/08/2018",
  "05/31/2019", "", "02/28/2014", "06/16/2021", "01/28/2021", "11/12/2018",
  "09/09/2020", "04/20/2022", "Original: 04/13/2010; Updated 12/10/2010",
  "12/18/2018", "11/14/2014", "09/18/2023", "", "09/18/2019", "08/23/2016",
  "12/06/2021", "", "10/25/2011", "04/08/2019", "04/01/2019", "",
  "Original: 10/28/2016; Updated: 09/26/2018", "01/05/2021"
), sourced = structure(c(
  19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711,
  19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711, 19711
), class = "Date"))

saveRDS(object = usada_test_raw, "tests/testthat/fixtures/usada_test_raw.rds")
