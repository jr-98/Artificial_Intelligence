library(readr)
datos<- read_csv("Locales/U/Sistemas/9Ciclo_Octubre_Marzo_2020_2021/IA/DataSet/VideoGames/Games.csv")
View(datos)

#LANZAMIENTO
#Seleccionar datos de interes para ordenarlos por año de lanzamiento
Publ <- select(datos, c(Name,Platform,Year_of_Release, Genre,Publisher))
dim(Publ)
str(Publ)
View(Publ)
#Ordenar por año de lanzamiento
Publ2 <- arrange(Publ, desc(Year_of_Release))
view(Publ2)
str(Publ2)
#En que se lanzaron mas juegos
moreYearsGames <- arrange(Year_of_Release,Name)
Int_years <- c(1980:2000)

Int_rep <- table(datos$Year_of_Release)
view(Int_rep)

plot(Int_rep,
     main = "Gráfica de los años con mayor numero de lanzamientos en videojuegos",
     xlab ="Años",
     ylab="Cantidad de juegos lanzados")

barplot(prop.table(table(datos$Year_of_Release)),col = c("Yellow","blue","green"))
