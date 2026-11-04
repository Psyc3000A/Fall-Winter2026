# Killingsworth (2021): figure and descriptive table from supplied aggregated CSV
# Place income_wellbeing.csv in your R working directory.
# install.packages(c('ggplot2','tidyr','dplyr','scales'))
library(ggplot2)
library(tidyr)
library(dplyr)
library(scales)

raw <- read.csv('income_wellbeing.csv', check.names = FALSE)
needed <- c('household_income', 'experienced_wellbeing_zscore.Mean',
            'life_satisfaction_zscore.Mean',
            'experienced_wellbeing_zscore.personcount',
            'life_satisfaction_zscore.personcount')
stopifnot(all(needed %in% names(raw)))

figure_data <- raw %>%
  select(household_income, experienced_wellbeing_zscore.Mean,
         life_satisfaction_zscore.Mean) %>%
  pivot_longer(-household_income, names_to='Measure', values_to='Z_score') %>%
  mutate(Measure = recode(Measure,
                          'experienced_wellbeing_zscore.Mean'='Experienced well-being',
                          'life_satisfaction_zscore.Mean'='Life satisfaction')) %>%
  filter(household_income > 0) %>% arrange(household_income)

figure1 <- ggplot(figure_data, aes(household_income, Z_score, color=Measure)) +
  geom_line(linewidth=1) + geom_point(size=2) +
  geom_vline(xintercept=75000, linetype='dashed', color='gray45') +
  scale_x_log10(labels=label_dollar()) +
  labs(title='Income and well-being',
       subtitle='Recreation from aggregated data in Killingsworth (2021)',
       x='Annual household income (USD, log scale)',
       y='Mean standardized well-being (z-score)', color=NULL,
       caption='Dashed line: $75,000 reference; points are income-bin means.') +
  theme_minimal(base_size=12) + theme(legend.position='bottom')
print(figure1)
ggsave('Figure1_Income_Wellbeing.png', figure1, width=9, height=6, dpi=300)

# Table derived from the supplied CSV; NOT a recreation of published Table 1.
# Person counts can overlap across bins only if source data are non-disjoint;
# these are the original reported per-bin counts.
table1 <- raw %>%
  transmute(`Household income (USD)` = household_income,
            `Experienced well-being (z)` = round(experienced_wellbeing_zscore.Mean, 3),
            `Life satisfaction (z)` = round(life_satisfaction_zscore.Mean, 3),
            `N: experienced well-being` = experienced_wellbeing_zscore.personcount,
            `N: life satisfaction` = life_satisfaction_zscore.personcount)
write.csv(table1, 'Income_Wellbeing_Descriptive_Table.csv', row.names=FALSE)

# Save table image using base R grid (no extra package needed).
library(grid)
show <- table1
show[[1]] <- format(show[[1]], big.mark=',', trim=TRUE, scientific=FALSE)
for (j in 4:5) show[[j]] <- format(show[[j]], big.mark=',', trim=TRUE, scientific=FALSE)
png('Income_Wellbeing_Descriptive_Table.png', width=2000, height=1250, res=180)
grid.newpage()
grid.text('Income and well-being by household income', y=.97,
          gp=gpar(fontsize=18, fontface='bold'))
headers <- names(show)
xs <- c(.13,.37,.57,.77,.93)
for (j in seq_along(headers)) grid.text(headers[j], x=xs[j], y=.91, gp=gpar(fontsize=8, fontface='bold'))
for (i in seq_len(nrow(show))) {
  y <- .87 - (i-1)*.052
  if (i %% 2 == 0) grid.rect(x=.5,y=y,width=.98,height=.05,gp=gpar(fill='#f2f4f7',col=NA))
  for (j in seq_along(headers)) grid.text(as.character(show[i,j]), x=xs[j], y=y, gp=gpar(fontsize=9))
}
grid.text('Descriptive table calculated from uploaded aggregated CSV; not the paper’s regression Table 1.',
          y=.04, gp=gpar(fontsize=9, col='gray40'))
dev.off()
cat('Saved Figure1_Income_Wellbeing.png, Income_Wellbeing_Descriptive_Table.csv, and Income_Wellbeing_Descriptive_Table.png\n')

