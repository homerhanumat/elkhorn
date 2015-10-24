library(tigerstats)

# sat
temp <- cut(sat$frac, breaks = c(0,20,60,85), labels = c("low","medium","high"))
# xyplot(sat~salary|temp, data = sat, layout = c(3,1), type = c("p","r"))
sat$frac_category <- temp
write.csv(x = sat, file = "../data/sat.csv", row.names = F)

# influential points and outliers
set.seed(2020)


