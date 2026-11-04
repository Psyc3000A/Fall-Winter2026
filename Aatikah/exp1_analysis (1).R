#Authors: "Anna Lorenzoni & Mario Dalmaso"
#Date: "July 2026"; R version --> R version 4.2.2 (2022-10-31 ucrt)
#This document shows the analysis for experiment 1 reported in the paper:
#"Investigating the reversed congruency effect of gaze through the lens of joint attention"

rm(list=ls())

#install all packages
library(dplyr)
library(magrittr)
library(readr)
library(ggpubr)
library(lme4)
library(sjPlot)
library(ggplot2)
library(emmeans)
library(tidyr)
library(broom.mixed)

dati<-read.csv("Results_exp1.csv")


#just important variables
d<-dati[,c("pos_target","fixation","participant","cord_target","condizione","tipo_fissazione","target.corr","tipo_stimolo","congruenza","target.rt","target.keys","stimolo_target","dir_target")]
d<-replace(d,d=="", NA)

#eliminate trials and test subjects
d=subset(d, participant !="872665" & participant !="159319" & condizione=="esperimento",)

# drop unused factor levels for participant after removing 2 subjects
d$participant <- droplevels(factor(d$participant))

#rename variables in english
#1_congruency
d <- d %>%
  mutate(Congruency = recode(congruenza, "c" = "Congruent", "i" = "Incongruent")) %>%
  select(-congruenza)

#2_Fixation
d <- d %>%
  mutate(Fixation = recode(tipo_fissazione, "croce" = "cross", "oggetto" = "real-object")) %>%
  select(-tipo_fissazione)

#3_Target_Stimulus
d <- d %>%
  mutate(Target_Stimulus = recode(tipo_stimolo, "freccia" = "arrows", "sguardo" = "face")) %>%
  select(-tipo_stimolo)

d$target.rt<-d$target.rt*1000 #from s to ms

# explicitly fix factor level order before assigning contrasts,
d$pos_target<-factor(d$pos_target)
d$participant<-factor(d$participant)
d$Fixation<-factor(d$Fixation, levels = c("cross", "real-object"))
d$target.corr<-factor(d$target.corr)
d$Target_Stimulus<-factor(d$Target_Stimulus, levels = c("arrows", "face"))
d$Congruency<-factor(d$Congruency, levels = c("Congruent", "Incongruent"))
d$dir_target<-factor(d$dir_target)
d$target.keys<-factor(d$target.keys)


#sanity checks
nlevels( d$participant) #sanity check number of participants
15360/60 #sanity check for number of trials/participant
summary(d) #sanity check factorial design dataset


#error percentage
summary (d$target.corr)
(738/15360)*100


#missing
summary (d$target.keys)
(80/15360)*100


d= d[d$target.rt >200,]
d= d[d$target.rt <1300,]


dacc=d 
dacc=subset(d, target.corr!= "NA") #dataset for accuracy
d= d[d$target.corr!= "0" & !is.na(d$target.rt),] #dataset for RTs

min(table(d$Target_Stimulus,d$Fixation, d$Congruency))

##analysis
#RTS

# explicit, labeled sum/deviation (-0.5/+0.5) coding
c_congruency <- matrix(c(-0.5, 0.5), ncol = 1,
                       dimnames = list(levels(d$Congruency), "Incongr_vs_Congr"))
c_fixation <- matrix(c(-0.5, 0.5), ncol = 1,
                     dimnames = list(levels(d$Fixation), "RealObj_vs_Cross"))
c_stimulus <- matrix(c(-0.5, 0.5), ncol = 1,
                     dimnames = list(levels(d$Target_Stimulus), "Face_vs_Arrows"))

contrasts(d$Congruency) <- c_congruency
contrasts(d$Fixation) <- c_fixation
contrasts(d$Target_Stimulus) <- c_stimulus

cat("=== Contrast coding used in the models ===\n")
print(contrasts(d$Congruency))
print(contrasts(d$Fixation))
print(contrasts(d$Target_Stimulus))


#### -----------------------------------------------------------------
#### Model comparison for RANDOM effects structure
#### -----------------------------------------------------------------
r0 = glmer(target.rt ~  (1 | participant),
           family = Gamma(link = "identity"), data = d)
r1 = glmer(target.rt ~  (1 + Congruency | participant),
           family = Gamma(link = "identity"), data = d)
r2 = glmer(target.rt ~  (1 + Congruency + Target_Stimulus | participant),
           family = Gamma(link = "identity"), data = d) #does not converge
r3 = glmer(target.rt ~  (1 + Congruency * Target_Stimulus | participant),
           family = Gamma(link = "identity"), data = d) #does not converge
anova(r0,r1) #best model: r1, i.e. random intercept + random slope for Congruency (correlated)


#### -----------------------------------------------------------------
#### Model comparison for FIXED effects (nAGQ=0 for speed during selection)
#### -----------------------------------------------------------------
m0 = glmer(target.rt ~  1 + (1 + Congruency | participant),
           nAGQ=0, family = Gamma(link = "identity"), data = d)
m1 = glmer(target.rt ~  Congruency + (1 + Congruency | participant),
           nAGQ=0, family = Gamma(link = "identity"), data = d)
m2 = glmer(target.rt ~  Congruency + Fixation + (1 + Congruency | participant),
           nAGQ=0, family = Gamma(link = "identity"), data = d)
m3 = glmer(target.rt ~  Congruency + Fixation + Target_Stimulus + (1 + Congruency | participant),
           nAGQ=0, family = Gamma(link = "identity"), data = d)
m4 = glmer(target.rt ~  Congruency*Fixation + Congruency*Target_Stimulus + Fixation*Target_Stimulus + (1 + Congruency | participant),
           nAGQ=0, family = Gamma(link = "identity"), data = d) 
m5 = glmer(target.rt ~  Congruency*Fixation*Target_Stimulus + (1 + Congruency | participant),
           nAGQ=0, family = Gamma(link = "identity"), data = d)


#table for model comparison (Table s1)
model_list  <- list(m0, m1, m2, m3, m4, m5)
model_names <- c("m0","m1","m2","m3","m4","m5")

summ.table <- do.call(rbind, lapply(model_list, broom.mixed::glance))
table.cols <- c("deviance", "df.residual","AIC")
reported.table <- summ.table[table.cols]
names(reported.table) <- c("Resid. Dev","Resid. Df","AIC")
reported.table[['dAIC']] <-  with(reported.table, AIC - min(AIC))
reported.table[['weight']] <- with(reported.table, exp(- 0.5 * dAIC) / sum(exp(- 0.5 * dAIC)))
reported.table$AIC <- NULL
reported.table$weight <- round(reported.table$weight, 2)
reported.table$dAIC <- round(reported.table$dAIC, 1)
reported.table <- as.data.frame(reported.table)
rownames(reported.table) <- model_names
reported.table

#Resid. Dev Resid. Df   dAIC weight
#m0   682.6725     14598 4836.9    0.0
#m1   682.6881     14597 4826.2    0.0
#m2   682.6773     14596 4828.0    0.0
#m3   502.5796     14595  349.1    0.0
#m4   490.5459     14592    0.0    0.7
#m5   490.5367     14591    1.7    0.3

##### FINAL REFIT (nAGQ=1) for inference, following model selection
m4 = glmer(target.rt ~  Congruency*Fixation + Congruency*Target_Stimulus + Fixation*Target_Stimulus + (1 + Congruency | participant),
          family = Gamma(link = "identity"), data = d) 
m5 = glmer(target.rt ~  Congruency*Fixation*Target_Stimulus + (1 + Congruency | participant),
           family = Gamma(link = "identity"), data = d) 

relgrad2 <- with(m4@optinfo$derivs, solve(Hessian, gradient))
max(abs(relgrad2))
#### On target.rt (ms), the model does not converge with nAGQ=1 (relgrad=0.045),
#### due to numerical scale issues. This is resolved by rescaling the DV (/100);
#### Estimates and standard errors are then multiplied by 100 for reporting in ms.
#### The t-value and p-value remain unchanged by the rescaling.

#rescale
d$target.rt_100 <- d$target.rt / 100
m4_rescaled <- glmer(target.rt_100 ~ Congruency*Fixation + Congruency*Target_Stimulus + Fixation*Target_Stimulus + (1 + Congruency | participant),
                     family = Gamma(link = "identity"), data = d)

s <- summary(m4_rescaled)$coefficients
s[, 1:2] <- s[, 1:2] * 100  
ci_low  <- s[, 1] - 1.96 * s[, 2]
ci_high <- s[, 1] + 1.96 * s[, 2]

s <- cbind(s, CI_low = ci_low, CI_high = ci_high)
s <- round(s, 4)
print(s)

                                                        #Estimate Std. Error  t value Pr(>|z|)   CI_low  CI_high
#(Intercept)                                              548.2028    10.9864  49.8982   0.0000 526.6694 569.7362
#CongruencyIncongr_vs_Congr                                11.7097     3.3434   3.5023   0.0005   5.1566  18.2628
#FixationRealObj_vs_Cross                                  -1.1807     1.6086  -0.7340   0.4630  -4.3337   1.9722
#Target_StimulusFace_vs_Arrows                            116.0593     1.6167  71.7874   0.0000 112.8905 119.2280
#CongruencyIncongr_vs_Congr:FixationRealObj_vs_Cross        3.4795     3.1512   1.1042   0.2695  -2.6968   9.6557
#CongruencyIncongr_vs_Congr:Target_StimulusFace_vs_Arrows -60.9800     3.2313 -18.8714   0.0000 -67.3135 -54.6466
#FixationRealObj_vs_Cross:Target_StimulusFace_vs_Arrows     3.5654     3.2234   1.1061   0.2687  -2.7524   9.8832

library(emmeans)
emm1 <- emmeans(m4_rescaled, ~ Congruency | Target_Stimulus)
library(dplyr)

pairs(emm1) %>%
  as.data.frame() %>%
  mutate(across(c(estimate, SE), ~ round(.x * 100, 2)))
                 #contrast Target_Stimulus estimate   SE  df    z.ratio      p.value
#1 Congruent - Incongruent          arrows   -42.20 3.56 Inf -11.853326 2.068155e-32
#2 Congruent - Incongruent            face    18.78 3.86 Inf   4.864816 1.145631e-06

library(dplyr)
options(pillar.sigfig = 6)

desc <- d %>%
  group_by(Congruency, Target_Stimulus) %>%
  summarise(
    M  = round(mean(target.rt), 2),
    SD = round(sd(target.rt), 2),
    SE = round(sd(target.rt) / sqrt(n()), 2),
    n  = n(),
    .groups = "drop"
  )
desc

descCong <- d %>%
  group_by(Congruency) %>%
  summarise(
    M  = round(mean(target.rt), 2),
    SD = round(sd(target.rt), 2),
    SE = round(sd(target.rt) / sqrt(n()), 2),
    n  = n(),
    .groups = "drop"
  )
descCong

descTarget <- d %>%
  group_by(Target_Stimulus) %>%
  summarise(
    M  = round(mean(target.rt), 2),
    SD = round(sd(target.rt), 2),
    SE = round(sd(target.rt) / sqrt(n()), 2),
    n  = n(),
    .groups = "drop"
  )
descTarget

m5_rescaled = glmer(target.rt_100 ~  Congruency*Fixation*Target_Stimulus + (1 + Congruency | participant),
                    family = Gamma(link = "identity"), data = d)

s <- summary(m5_rescaled)$coefficients
s[, 1:2] <- s[, 1:2] * 100
ci_low  <- s[, 1] - 1.96 * s[, 2]
ci_high <- s[, 1] + 1.96 * s[, 2]

s <- cbind(s, CI_low = ci_low, CI_high = ci_high)
s <- round(s, 4)
print(s)


#accuracy
dacc$Congruency <- factor(dacc$Congruency, levels = c("Congruent", "Incongruent"))
dacc$Fixation <- factor(dacc$Fixation, levels = c("cross", "real-object"))
dacc$Target_Stimulus <- factor(dacc$Target_Stimulus, levels = c("arrows", "face"))

contrasts(dacc$Congruency) <- c_congruency
contrasts(dacc$Fixation) <- c_fixation
contrasts(dacc$Target_Stimulus) <- c_stimulus

m0acc = glmer(target.corr ~  1 + (1 | participant), family=binomial, data = dacc)
m1acc = glmer(target.corr ~  Congruency + (1 | participant), family=binomial, data = dacc)
m2acc = glmer(target.corr ~  Congruency+Fixation+(1 | participant), family=binomial, data = dacc)
m3acc = glmer(target.corr ~  Congruency+Fixation+Target_Stimulus+(1 | participant), family=binomial, data = dacc)
m4acc = glmer(target.corr ~  Congruency*Fixation + Congruency*Target_Stimulus + Fixation*Target_Stimulus+(1 | participant), family=binomial, data = dacc)
m5acc = glmer(target.corr ~  Congruency*Fixation*Target_Stimulus+(1 | participant), family=binomial, data = dacc)
anova(m0acc,m1acc,m2acc,m3acc,m4acc,m5acc)
summary(m4acc)
tab_model(m4acc)
emm1acc <- emmeans(m4acc, ~ Congruency | Target_Stimulus)
confint(emm1acc)          
pairs(emm1acc)             
summary(dacc$target.corr)

library(dplyr)
dacc %>% group_by(Congruency) %>% 
  summarise(M = round(mean(as.numeric(as.character(target.corr))), 3), 
            SD = round(sd(as.numeric(as.character(target.corr))), 3))

dacc %>% group_by(Target_Stimulus) %>% 
  summarise(M = round(mean(as.numeric(as.character(target.corr))), 3), 
            SD = round(sd(as.numeric(as.character(target.corr))), 3))

dacc %>% group_by(Congruency, Target_Stimulus) %>% 
  summarise(M = round(mean(as.numeric(as.character(target.corr))), 3), 
            SD = round(sd(as.numeric(as.character(target.corr))), 3), .groups="drop")
summary(m5acc)
#######
#BIN-distribution analysis

### RT Distribution analysis
summary(d$Fixation)
dobject=subset(d, Fixation=="real-object")
dcross=subset(d, Fixation=="cross")

#Fixation: real-object
summary(dobject)
DistributionRT <- dobject %>%
  mutate(target.rt = as.numeric(target.rt)) %>%
  dplyr::group_by(participant, Target_Stimulus, Congruency) %>%
  dplyr::mutate(Bin = case_when(
    target.rt < quantile(target.rt, 1/4, na.rm = TRUE) ~ "1",
    target.rt < quantile(target.rt, 2/4, na.rm = TRUE) ~ "2",
    target.rt < quantile(target.rt, 3/4, na.rm = TRUE) ~ "3",
    TRUE ~ "4"  # RT piu' lenti
  )) %>%
  group_by(participant, Target_Stimulus, Congruency, Bin) %>%
  dplyr::summarise(meanRT=mean(target.rt))


mean_rt_per_bin <- dobject %>%
  mutate(target.rt = as.numeric(target.rt)) %>%
  dplyr::group_by(participant, Target_Stimulus, Congruency) %>%
  dplyr::mutate(Bin = case_when(
    target.rt < quantile(target.rt, 1/4, na.rm = TRUE) ~ "1",
    target.rt < quantile(target.rt, 2/4, na.rm = TRUE) ~ "2",
    target.rt < quantile(target.rt, 3/4, na.rm = TRUE) ~ "3",
    TRUE ~ "4"
  )) %>%
  group_by(Bin) %>%
  summarise(meanRT = mean(target.rt, na.rm = TRUE))


print(mean_rt_per_bin)

CongruencyEffectRT <- DistributionRT %>%
  group_by(participant, Target_Stimulus, Bin) %>%
  pivot_wider(names_from = Congruency, values_from = meanRT) %>%
  mutate(SCE=Incongruent-Congruent) %>%
  select(participant, Target_Stimulus, Bin, SCE)

delta_data <- CongruencyEffectRT %>%
  group_by(Bin, Target_Stimulus) %>%
  summarise(mean_SCE = mean(SCE, na.rm = TRUE)) %>%
  ungroup()

#Plot
ggplot(delta_data, aes(x = Bin, y = mean_SCE, color = Target_Stimulus, group = Target_Stimulus)) +
  geom_line(size = 0.8) +
  geom_point(size = 1)   +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  scale_color_grey(start = 0.2, end = 0.7) +
  scale_x_discrete(labels = setNames(scales::number_format(accuracy = 1)(mean_rt_per_bin$meanRT), mean_rt_per_bin$Bin)) +
  labs(title = "Delta Plot - Congruency Effect for real-object Fixation",
       x = "RT Bin",
       y = "SCE (Incongruent - Congruent)",
       color = "Target_Stimulus") +
  theme_minimal()

#Fixation: cross
summary(dcross)
DistributionRT <- dcross %>%
  mutate(target.rt = as.numeric(target.rt)) %>%
  dplyr::group_by(participant, Target_Stimulus, Congruency) %>%
  dplyr::mutate(Bin = case_when(
    target.rt < quantile(target.rt, 1/4, na.rm = TRUE) ~ "1",
    target.rt < quantile(target.rt, 2/4, na.rm = TRUE) ~ "2",
    target.rt < quantile(target.rt, 3/4, na.rm = TRUE) ~ "3",
    TRUE ~ "4"
  )) %>%
  group_by(participant, Target_Stimulus, Congruency, Bin) %>%
  dplyr::summarise(meanRT=mean(target.rt))


mean_rt_per_bin <- dcross %>%
  mutate(target.rt = as.numeric(target.rt)) %>%
  dplyr::group_by(participant, Target_Stimulus, Congruency) %>%
  dplyr::mutate(Bin = case_when(
    target.rt < quantile(target.rt, 1/4, na.rm = TRUE) ~ "1",
    target.rt < quantile(target.rt, 2/4, na.rm = TRUE) ~ "2",
    target.rt < quantile(target.rt, 3/4, na.rm = TRUE) ~ "3",
    TRUE ~ "4"
  )) %>%
  group_by(Bin) %>%
  summarise(meanRT = mean(target.rt, na.rm = TRUE))

print(mean_rt_per_bin)

CongruencyEffectRT <- DistributionRT %>%
  group_by(participant, Target_Stimulus, Bin) %>%
  pivot_wider(names_from = Congruency, values_from = meanRT) %>%
  mutate(SCE=Incongruent-Congruent) %>%
  select(participant, Target_Stimulus, Bin, SCE)

delta_data <- CongruencyEffectRT %>%
  group_by(Bin, Target_Stimulus) %>%
  summarise(mean_SCE = mean(SCE, na.rm = TRUE)) %>%
  ungroup()

# plot
ggplot(delta_data, aes(x = Bin, y = mean_SCE, color = Target_Stimulus, group = Target_Stimulus)) +
  geom_line(size = 0.8) +
  geom_point(size = 1)   +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  scale_color_grey(start = 0.2, end = 0.7) +
  scale_x_discrete(labels = setNames(scales::number_format(accuracy = 1)(mean_rt_per_bin$meanRT), mean_rt_per_bin$Bin)) +
  labs(title = "Delta Plot - Congruency Effect for cross Fixation",
       x = "RT Bin",
       y = "SCE (Incongruent - Congruent)",
       color = "Target_Stimulus") +
  theme_minimal()



