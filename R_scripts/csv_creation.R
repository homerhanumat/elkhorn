library(tigerstats)

# sat
temp <- cut(sat$frac, breaks = c(0,20,60,85), labels = c("low","medium","high"))
# xyplot(sat~salary|temp, data = sat, layout = c(3,1), type = c("p","r"))
sat$frac_category <- temp
write.csv(x = sat, file = "../data/sat.csv", row.names = F)

# influential points and outliers
set.seed(3070)
cx <- rnorm(10, mean = 5, sd = 1)
cy <- rnorm(10, mean = 5, sd = 1)
x <- c(cx,15)
y <- c(cy,15)
type <- c(rep("herd",10),"influential")
df <- data.frame(x,y,type)
# xyplot(y~x,data=df,type=c("p","r"))
write.csv(x = df, file = "../data/influential.csv", row.names = F)

set.seed(2020)
ox <- 20:60
oy <- ox + rnorm(41, mean = 0, sd = 2)
x <- c(ox,40)
y <- c(oy,10)
type <- c(rep("herd",41),"outlier")
df <- data.frame(x,y,type)
# xyplot(y~x,data=df,type=c("p","r"))
write.csv(x = df, file = "../data/outlier.csv", row.names = F)
