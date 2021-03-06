# Carga de librer�as 
library(dplyr)
library(grid)
library(arules)
library(arulesViz) # para graficar
# Damos formato a cada transacci�n de Datos_a_priori
library(ggplot2) # para dividir de acuerdo a la colum transacci�n

#Leemos el archivo xls
Datos_a_priori <- read.csv("C:/Users/Alexis/Desktop/GamesPruebaV3.csv", sep=",", dec=".", header=TRUE)

# CONVERSI�N DE UN DATAFRAME A UN OBJETO TIPO TRANSACTION
# Se convierte el dataframe a una lista en la que cada elemento  contiene los items de una transacci�n
datos_split <- split(x = Datos_a_priori$Genre, f = Datos_a_priori$Client)
transacciones <- as(datos_split, Class = "transactions")
transacciones
# contenido y tama�o de los items que forman cada transacci�n
inspect(transacciones[1:5])

# Para extraer el tama�o de cada transacci�n se emplea la funci�n size()
tamanyos <- size(transacciones)
summary(tamanyos)
quantile(tamanyos, probs = seq(0,1,0.1))

# Distribuci�n del tama�o de las transacciones
data.frame(tamanyos) %>%
  ggplot(aes(x = tamanyos)) +
  geom_histogram() +
  labs(title = "Distribuci�n del tama�o de las transacciones",
       x = "Tama�o") +
  theme_bw()

# identificar cu�les son los items m�s frecuentes (los que tienen mayor soporte)
# dentro del conjunto de todas las transacciones
# - Por "frecuencia" se hace referencia al soporte de cada item, que es la 
# - fracci�n de transacciones que contienen dicho item respecto al total de todas las transacciones
#  itemFrequency: devuelve el n�mero de transacciones en las que aparece cada item.

frecuencia_items <- itemFrequency(x = transacciones, type = "relative")
frecuencia_items
# Hace referencia al soporte de cada item, que es la fracci�n de transacciones que contienen dicho
# item respecto al total de todas las transacciones.

# Se muestran los 5 productos que mas venta han tenido
frecuencia_items %>% sort(decreasing = TRUE) %>% head(5)


# Apriori a un objeto de tipo transactions y extraer tanto itemsets frecuentes 
#como reglas de asociaci�n que superen un determinado soporte y confianza

#support: soporte m�nimo que debe tener un itemset para ser considerado frecuente
# Se procede a extraer aquellos itemsets, incluidos los formados por un �nico item, que hayan sido comprados al menos 5 veces
soporte <- 5 / dim(transacciones)[1]
soporte
itemsets <- apriori(data = transacciones,
                    parameter = list(support = soporte,
                                     minlen = 2,
                                     maxlen = 6,
                                     target = "frequent itemset"))


summary(itemsets)
#summary: Se han encontrado un total de 501 itemsets frecuentes que superan el soporte 
#m�nimo de 0.005, la mayor�a de ellos (782) formados por el g�nero otros.

# Se muestran los top 20 itemsets de mayor a menor soporte
top_20_itemsets <- sort(itemsets, by = "support", decreasing = TRUE)[1:20]
inspect(top_20_itemsets)

# Para representarlos con ggplot(graficar) se convierte a dataframe 
as(top_20_itemsets, Class = "data.frame") %>%
  ggplot(aes(x = reorder(items, support), y = support)) +
  geom_col() +
  coord_flip() +
  labs(title = "Itemsets m�s frecuentes", x = "itemsets") +
  theme_bw()

# Se muestran los 20 itemsets m�s frecuentes formados por m�s de un item.
inspect(sort(itemsets[size(itemsets) > 1], decreasing = TRUE)[1:20])

# Se procede a identificar aquellos itemsets frecuentes que contienen el item "Racing"
itemsets_filtrado <- arules::subset(itemsets,
                                    subset = items %in% "Racing")
itemsets_filtrado

# Se muestran 10 de ellos que sale
inspect(itemsets_filtrado[1:10])

# Para encontrar los subsets dentro de un conjunto de itemsets, se compara el
# conjunto de itemsets con sigo mismo
subsets <- is.subset(x = itemsets, y = itemsets, sparse = FALSE)
subsets

#itemsets que son subsets de otros itemsets se cuenta el n�mero total de TRUE en la matriz resultante.
# La suma de una matriz l�gica devuelve el n�mero de TRUEs
sum(subsets)


#CREACION DE "REGLAS DE ASOCIACION"
# Soporte: El soporte del item o itemset X es el n�mero de transacciones que contienen X dividido entre el total de transacciones
soporte <- 5 / dim(transacciones)[1]
# Confianza: La confianza de una regla "Si X entonces Y"
# Se establece una confianza m�nima para que una regla se incluya en los resultados "0.70"
reglas <- apriori(data = transacciones,
                  parameter = list(support = soporte,
                                   confidence = 0.9,
                                   # Se especifica que se creen reglas
                                   target = "rules"))
summary(reglas)
# summary: Se han identificado un total de 22 reglas, la mayor�a de ellas formadas
#por 5 items en el antecedente (parte izquierda de la regla).

# Mostrar las reglas
# Par�metros: 
# -  Lift: el estad�stico lift compara la frecuencia observada de una regla con 
#   la frecuencia esperada simplemente por azar (si la regla no existe realmente)
# *(Cuanto m�s se aleje el valor de lift de 1, m�s evidencias de que la regla no 
#   se debe a un artefacto aleatorio, es decir, mayor la evidencia de que la regla representa un patr�n real.)
# - Coverage: es el soporte de la parte izquierda de la regla (antecedente). 
#   Se interpreta como la frecuencia con la que el antecedente aparece en el conjunto de transacciones.

inspect(sort(x = reglas, decreasing = TRUE, by = "confidence"))

#plot(reglas)

reglas_redundantes <- reglas[is.redundant(x = reglas, measure = "confidence")]

reglas_redundantes

reglas_redundantes <- is.redundant(reglas)
reglas_redundantes
# Quitamos las reglas redundantes (Eliminamos los FALSE)
# Dos reglas  id�nticas.
reglas_podadas <- reglas[!reglas_redundantes]

# Desplegamos las reglas sin las redundancias
inspect(reglas_podadas)

# Reglas de mayor a menor por Confianza
inspect(sort(x = reglas_podadas, decreasing = TRUE, by = "confidence"))
