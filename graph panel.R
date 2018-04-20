library(tidyverse)

results = read.csv("qale tidy results calibrated.csv")

results$Wealth = factor(results$Wealth, c("Poorest","Poorer","Middle","Richer","Richest","Overall"))
results$Geography = factor(results$Geography, c("Urban","Rural","Overall"))
results$Gender = factor(results$Gender, c("Male","Female","Overall"))

graph_data = results %>% 
  filter(Wealth != "Overall") %>%
  mutate(Life.expectancy = round(Life.expectancy,0))

plot = ggplot(graph_data, aes(Wealth, Life.expectancy)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=Life.expectancy, y=Life.expectancy+3, fontface = "bold"), color="red",
            position=position_dodge(0.9), vjust=0,
            size=2.5) +
  facet_grid(Geography ~ Gender) +
  ggtitle("Life expectancy at birth (calibrated to SRS)") +
  xlab("Wealth quintile group") +
  ylab("Life expectancy at birth (years)") +
  theme_bw() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave(filename="life_expectancy_plots_calibrated.jpg", plot=plot, device="jpeg", width=7, height=6, units="cm", dpi=300, scale=3)


results = read.csv("qale tidy results uncalibrated.csv")

results$Wealth = factor(results$Wealth, c("Poorest","Poorer","Middle","Richer","Richest","Overall"))
results$Geography = factor(results$Geography, c("Urban","Rural","Overall"))
results$Gender = factor(results$Gender, c("Male","Female","Overall"))

graph_data = results %>% 
  filter(Wealth != "Overall") %>%
  mutate(Life.expectancy = round(Life.expectancy,0))

plot = ggplot(graph_data, aes(Wealth, Life.expectancy)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=Life.expectancy, y=Life.expectancy+3, fontface = "bold"), color="red",
            position=position_dodge(0.9), vjust=0,
            size=2.5) +
  facet_grid(Geography ~ Gender) +
  ggtitle("Life expectancy at birth (uncalibrated)") +
  xlab("Wealth quintile group") +
  ylab("Life expectancy at birth (years)") +
  theme_bw() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave(filename="life_expectancy_plots_uncalibrated.jpg", plot=plot, device="jpeg", width=7, height=6, units="cm", dpi=300, scale=3)
