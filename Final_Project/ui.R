library(shiny)
library(ggplot2)



fluidPage(
  
  titlePanel("Proyecto A priori", tags$head()),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Elija un archivo csv",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
    ),
    mainPanel(
      tableOutput("contents")
    )
  ),
  sidebarPanel(
    
    sliderInput('sup', "Soporte", min = 1, max = 10, value =5, step = 0.1),
    
    sliderInput('conf', 'Confianza ', min = 0.01, max =1, value = 0.9, step = 0.005),
    
    sliderInput('len', 'Longitud minima', min = 1, max =15, value = 3, step = 1),
    
    sliderInput('mlen', 'Longitud maxima', min = 1, max =15, value = 7, step = 1),
    
    sliderInput('time', 'Tiempo Maximo', min = 1, max =25, value = 3, step = 1)
    
    
  ),
  
  mainPanel(
    tabsetPanel(id = 'mytab',
                tabPanel('Reglas', value = 'datatable', dataTableOutput("rules")),
                tabPanel('Gráfico', value = 'graph',plotOutput('plot')),
                tabPanel("Términos",
                         fluidRow(
                           column(width = 12,h4("Soporte:"),
                             helpText("Se refiere a la popularidad predeterminada de un artículo y se puede calcular 
                                      encontrando el número de transacciones que contienen un artículo en particular 
                                      dividido por el número total de transacciones.
                                      soporte mínimo que debe tener un itemset para ser considerado frecuente.")),
                           column(width = 12,h4("Confianza:"),
                                  helpText("Se refiere a la probabilidad de que también se compre un artículo B 
                                           (consecuente) si se compra el artículo A (antecedente).
                                           Tener una confianza igual a 1, significa que aunque no se 
                                           vendan mucho, siempre se venden juntos.")),
                           column(width = 12,h4("Lift = 1:"),
                                  helpText("Indica que ese conjunto aparece una cantidad de veces acorde a lo 
                                           esperado bajo condiciones de independencia. ")),
                           column(width = 12,h4("Lift > 1:"),
                                  helpText("Indica que ese conjunto aparece una cantidad de veces superior a 
                                           lo esperado bajo condiciones de independencia (por lo que se puede 
                                           intuir que existe una relación que hace que los productos se encuentren 
                                           en el conjunto más veces de lo normal). ")),
                           column(width = 12,h4("Lift < 1:"),
                                  helpText("Indica que ese conjunto aparece una cantidad de veces inferior a lo 
                                           esperado bajo condiciones de independencia (por lo que se puede intuir
                                           que existe una relación que hace que los productos no estén formando parte 
                                           del mismo conjunto más veces de lo normal).")),
                           column(width = 12,h4("Maxtime:"),
                                  helpText("Tiempo máximo que puede estar el algoritmo buscando subsets.")),
                           column(width = 12,h4("Nota"),
                                  helpText("Cuanto más se aleje el valor de lift de 1, más evidencias de que la regla 
                                           no se debe a un producto aleatorio, es decir, mayor la evidencia de que la 
                                           regla representa un patrón real.")),
                         ))),
  ),
  
)