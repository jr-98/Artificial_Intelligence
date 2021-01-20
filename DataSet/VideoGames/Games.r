library(readr)
datos<- read_csv("Locales/U/Sistemas/9Ciclo_Octubre_Marzo_2020_2021/IA/DataSet/VideoGames/Video_Games_Sales_as_at_22_Dec_2016.csv")
View(datos)

#LANZAMIENTO
#Seleccionar datos de interes para ordenarlos por a�o de lanzamiento
Publ <- select(datos, c(Name,Platform,Year_of_Release, Genre,Publisher))
dim(Publ)
str(Publ)
View(Publ)
#Ordenar por a�o de lanzamiento
Publ2 <- arrange(Publ, desc(Year_of_Release))
view(Publ2)
str(Publ2)
#En que se lanzaron mas juegos
moreYearsGames <- arrange(Year_of_Release,Name)
Int_years <- c(1980:2000)

Int_rep <- table(datos$Year_of_Release)
view(Int_rep)

plot(Int_rep,
     main = "Gr�fica de los a�os con mayor numero de lanzamientos en videojuegos",
     xlab ="A�os",
     ylab="Cantidad de juegos lanzados")

barplot(prop.table(table(datos$Year_of_Release)),col = c("Yellow","blue","green"))
