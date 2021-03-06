# only `stratum` assignment is necessary to generate strata
data(vaccinations)
ggplot(vaccinations,
       aes(y = freq,
           x = survey, stratum = response,
           fill = response)) +
  stat_stratum(width = .5)

# lode data, positioning with y labels
ggplot(vaccinations,
       aes(y = freq,
           x = survey, stratum = response, alluvium = subject,
           label = freq)) +
  stat_stratum(geom = "errorbar") +
  geom_text(stat = "stratum")
# alluvium data, positioning with stratum labels
ggplot(as.data.frame(Titanic),
       aes(y = Freq,
           axis1 = Class, axis2 = Sex, axis3 = Age, axis4 = Survived)) +
  geom_text(stat = "stratum", infer.label = TRUE) +
  stat_stratum(geom = "errorbar") +
  scale_x_discrete(limits = c("Class", "Sex", "Age", "Survived"))

# omit labels for strata outside a y range
ggplot(vaccinations,
       aes(y = freq,
           x = survey, stratum = response,
           fill = response, label = response)) +
  stat_stratum(width = .5) +
  geom_text(stat = "stratum", min.y = 100)

# date-valued axis variables
survey_dates <- data.frame(
  survey = levels(vaccinations$survey),
  start = as.Date(c("2010-09-22", "2015-06-04", "2016-09-27")),
  end = as.Date(c("2010-10-25", "2015-10-05", "2016-10-25"))
)
ggplot(merge(vaccinations, survey_dates, by = "survey"),
       aes(x = end, y = freq, stratum = response, alluvium = subject,
           fill = response)) +
  stat_alluvium(geom = "flow", lode.guidance = "forward",
                width = 30, knot.pos = 0) +
  stat_stratum(width = 30) +
  labs(x = "Survey date", y = "Number of respondents")

# use negative y values to encode rejection versus acceptance
admissions <- as.data.frame(UCBAdmissions)
admissions <- transform(admissions, Count = Freq * (-1) ^ (Admit == "Rejected"))
ggplot(admissions,
       aes(y = Count, axis1 = Dept, axis2 = Gender)) +
  geom_alluvium(aes(fill = Dept), width = 1/12) +
  geom_stratum(width = 1/12, fill = "black", color = "grey") +
  geom_label(stat = "stratum", infer.label = TRUE, min.y = 200) +
  scale_x_discrete(limits = c("Department", "Gender"), expand = c(.05, .05))
