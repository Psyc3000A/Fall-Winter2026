# Recreate Table 2 from Hubeny, Nahon, & Gawronski (2026), Experiment 1
# Uses the analysis-ready workbook supplied with the article materials.
# Required packages: readxl, dplyr, tidyr, purrr

library(readxl)
library(dplyr)
library(tidyr)
library(purrr)

# Point this to the workbook. If it is not in getwd(), choose it interactively.
data_file <- "Data for R Analyses-Exp 1.xlsx"
if (!file.exists(data_file)) {
  data_file <- file.choose()  # Select “Data for R Analyses-Exp 1.xlsx”
}

# Import before any calculation. Stop here with a useful message if import fails.
dat <- tryCatch(
  read_excel(data_file, sheet = "Data"),
  error = function(e) stop("Could not read the workbook: ", conditionMessage(e), call. = FALSE)
)
if (!is.data.frame(dat) || nrow(dat) == 0) {
  stop("The workbook was read but contains no rows on the 'Data' sheet.", call. = FALSE)
}
message("Loaded ", nrow(dat), " participants from: ", normalizePath(data_file))

table2_vars <- c("ProUKTrue", "ProUKFalse", "ProFranceTrue", "ProFranceFalse")

dat <- dat %>%
  mutate(
    across(
      all_of(table2_vars),
      ~ suppressWarnings(as.numeric(.x))
    )
  )

if (anyNA(dat[table2_vars])) {
  bad_columns <- table2_vars[vapply(dat[table2_vars], \(x) anyNA(x), logical(1))]
  stop(
    "Table 2 score columns contain non-numeric or missing values after conversion: ",
    paste(bad_columns, collapse = ", "),
    "\nMake sure you selected the supplied analysis-ready file ",
    "'Data for R Analyses-Exp 1.xlsx'.",
    call. = FALSE
  )
}



cell_summary <- function(x, conf_level = .95) {
  x <- x[!is.na(x)]
  n <- length(x)
  mean_x <- mean(x)
  half_width <- qt((1 + conf_level) / 2, df = n - 1) * sd(x) / sqrt(n)
  tibble(
    n = n,
    M = mean_x,
    CI_low = mean_x - half_width,
    CI_high = mean_x + half_width
  )
}
table2_long <- dat %>%
  transmute(
    Group = factor(
      Team,
      levels = c("TeamUK", "TeamFrance", "Control"),
      labels = c("Team UK", "Team France", "No team")
    ),
    `Pro-UK True` = ProUKTrue,
    `Pro-UK False` = ProUKFalse,
    `Pro-France True` = ProFranceTrue,
    `Pro-France False` = ProFranceFalse
  ) %>%
  pivot_longer(-Group, names_to = "cell", values_to = "accepted_true") %>%
  group_by(Group, cell) %>%
  summarise(cell_summary(accepted_true), .groups = "drop") %>%
  mutate(
    cell = factor(
      cell,
      levels = c("Pro-UK True", "Pro-UK False", "Pro-France True", "Pro-France False")
    ),
    # Match article presentation (two decimals and bracketed 95% CI).
    `95% CI` = sprintf("[%.2f, %.2f]", CI_low, CI_high),
    M = sprintf("%.2f", M)
  )

table2 <- table2_long %>%
  select(Group, cell, M, `95% CI`) %>%
  pivot_wider(
    names_from = cell,
    values_from = c(M, `95% CI`),
    names_glue = "{cell}_{.value}"
  ) %>%
  select(
    Group,
    `Pro-UK True_M`, `Pro-UK True_95% CI`,
    `Pro-UK False_M`, `Pro-UK False_95% CI`,
    `Pro-France True_M`, `Pro-France True_95% CI`,
    `Pro-France False_M`, `Pro-France False_95% CI`
  )
print(table2, n = Inf)




