## code to prepare `m1_method` dataset goes here
m1_method <-
  c("allogenic (homologous)",
    "autologous",
    "blood transfusion",
    "efaproxiral (rsr13)",
    "enhancing delivery of oxygen",
    "enhancing transport",
    "enhancing uptake",
    "haemoglobin-based blood substitutes",
    "efaproxiral",
    "heterologous blood",
    "intravascular manipulation of the blood or blood components by physical or chemical means",
    "microencapsulated haemoglobin products",
    "modified haemoglobin products",
    "perfluorochemicals",
    "red blood cell products")
usethis::use_data(m1_method, overwrite = TRUE)
