# Carga de librerías 
library("arules")
library("arulesViz") # para graficar

#Leemos el archivo xls
Datos_a_priori <- read.csv("C:/Users/Alexis/Desktop/Games.csv", sep=",", dec=".", header=TRUE)

# Structure -> Transacciones deben ser numericas y los productos factores
str(Datos_a_priori)

# Damos formato a cada transacción de Datos_a_priori
library(plyr) # para dividir de acuerdo a la colum transacción

# Para cada transaccion se creara una fila (dataframe) que tendrá los productos en una columna separada por comas
Lista_productos <- ddply(Datos_a_priori, c("Platform"),function(df1)paste(df1$Genre, collapse = ","))

# Quitamos la columna de las transacciones, ya que no se emplean en el algoritmo
Lista_productos$Platform <- NULL

# GUardamos los productos como csv, para tener los datos disponibles.
write.csv(Lista_productos, "C:/Users/Alexis/Desktop/Lista_productos.csv", quote = FALSE, row.names = FALSE)

# Leemos el archivo modificado con las transacciones
transacciones <- read.transactions("C:/Users/Alexis/Desktop/Lista_productos.csv", format = "basket", sep=",", header = TRUE)

# Mostramos las transacciones 
raw <- (transacciones)
inspect(raw)

# Implementamos el algoritmo apriori
gr_rules <- apriori(raw, parameter =list(supp = .1, conf = .8))
inspect(gr_rules[1:5])

