
tab <- read.csv("Games.csv", header=TRUE)

plot(tab$Global_Sales~tab$Prom_Score)
str(tab)
modelo <- lm(tab$Global_Sales~tab$Prom_Score)
summary(modelo)
modelo$coefficients
grafica = ggplot(tab, aes(Prom_Score, Global_Sales))
grafica + geom_point()
grafica + geom_point() + geom_smooth(method = "lm", color = "red")

Y =  (26.84334 * 100) -1157.20312
Y


plot(tab$Prom_Score~tab$Global_Sales)
str(tab)
modelo <- lm(tab$Prom_Score~tab$Global_Sales)
summary(modelo)
modelo$coefficients
grafica = ggplot(tab, aes(Global_Sales, Prom_Score))
grafica + geom_point()
grafica + geom_point() + geom_smooth(method = "lm", color = "red")

Y =  (0.002007578 * 100) + 69.625193564
Y
