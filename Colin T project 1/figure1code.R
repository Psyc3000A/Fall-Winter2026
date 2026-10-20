# Recreate Figure 1 from Hubeny, Nahon, & Gawronski (2026), Experiment 1
# Figure 1: Acceptance threshold (c) by team assignment and statement slant.

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# Point this to the analysis-ready workbook. If it is not in getwd(), choose it.
data_file <- "Data for R Analyses-Exp 1.xlsx"
if (!file.exists(data_file)) {
  data_file <- file.choose()  # Select “Data for R Analyses-Exp 1.xlsx”
}

# Import the complete Experiment 1 analysis dataset (N = 563).
dat <- tryCatch(
  read_excel(data_file, sheet = "Data"),
  error = function(e) stop("Could not read the workbook: ", conditionMessage(e), call. = FALSE)
)

required_columns <- c("Team", "RSDT_c_ProUK", "RSDT_c_ProFrance")
missing_columns <- setdiff(required_columns, names(dat))
if (length(missing_columns) > 0) {
  stop("Missing required column(s): ", paste(missing_columns, collapse = ", "), call. = FALSE)
}
if (nrow(dat) != 563) {
  warning("The article's Figure 1 uses all 563 Experiment 1 participants; this file has ", nrow(dat), " rows.")
}


plot_data <- dat %>%
  transmute(
    Team = factor(
      Team,
      levels = c("TeamUK", "TeamFrance", "Control"),
      labels = c("UK", "France", "No Team")
    ),
    `Pro-UK` = RSDT_c_ProUK,
    `Pro-France` = RSDT_c_ProFrance
  ) %>%
  pivot_longer(
    cols = c(`Pro-UK`, `Pro-France`),
    names_to = "Statement slant",
    values_to = "Acceptance threshold (c)"
  ) %>%
  filter(!is.na(Team), !is.na(`Acceptance threshold (c)`)) %>%
  group_by(Team, `Statement slant`) %>%
  summarise(
    n = n(),
    mean_c = mean(`Acceptance threshold (c)`),
    se = sd(`Acceptance threshold (c)`) / sqrt(n),
    # t-based 95% CI, matching the article's reporting convention.
    ci_half_width = qt(.975, df = n - 1) * se,
    ci_low = mean_c - ci_half_width,
    ci_high = mean_c + ci_half_width,
    .groups = "drop"
  ) %>%
  mutate(`Statement slant` = factor(`Statement slant`, levels = c("Pro-UK", "Pro-France")))

# Inspect the plotted values (means and their 95% CIs).
print(plot_data)

# Recreate Figure 1: group means with t-based 95% confidence-interval error bars.
dodge <- position_dodge(width = 0.35)
figure1 <- ggplot(plot_data, aes(x = Team, y = mean_c, shape = `Statement slant`)) +
  geom_point(position = dodge, size = 2.7, colour = "black") +
  geom_errorbar(
    aes(ymin = ci_low, ymax = ci_high),
    position = dodge, width = 0.12, linewidth = 0.55, colour = "black"
  ) +
  scale_shape_manual(values = c("Pro-UK" = 16, "Pro-France" = 17)) +
  scale_y_continuous(
    name = "Acceptance Threshold (c)",
    breaks = seq(-0.3, 0.1, by = 0.1),
    limits = c(-0.30, 0.10)
  ) +
  labs(x = "Team", shape = "Statement Slant") +
  theme_classic(base_size = 12) +
  theme(
    legend.position = "right",
    legend.title = element_text(size = 10),
    axis.title = element_text(size = 12),
    axis.text = element_text(colour = "black")
  )

print(figure1)

