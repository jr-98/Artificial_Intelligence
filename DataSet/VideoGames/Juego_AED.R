library(ggplot2)
library(readr)
library(dplyr)
library(RColorBrewer)
library(reshape2)
library(gridExtra)
library(scales)
library(ggthemes)
library(ggplot2)
library(reshape2)

df  <- read.csv("C:/Users/USUARIO/Desktop/GamesData.csv", header=TRUE)
head(df)
summary(df)

#juegos realizados para cada plataforma
plataforma = df %>% group_by(Platform) %>% summarise(Count = n())
p1 = ggplot(aes(x = Platform , y = Count , fill=Count) , data=plataforma) +
  geom_bar(colour='black',stat='identity') +
  theme_bw()+
  theme(axis.text.x = element_text(angle=45,hjust=1) , 
        plot.title = element_text(hjust=0.5))+  ## title center
  ggtitle('Platform Count')+
  scale_fill_distiller(palette = 'RdYlBu') +
  ylab('Cantidad')
grid.arrange(p1, ncol = 1)



#ventas por cada plataforma
venta_plataforma = df %>% group_by(Platform) %>% summarise(Global_Sales = sum(Global_Sales),
                                                         NA_Sales = sum(NA_Sales),
                                                         EU_Sales = sum(EU_Sales),
                                                         JP_Sales = sum(JP_Sales))

venta_plataforma = melt(venta_plataforma)
names(venta_plataforma) = c('Plataforma','Tipo_Venta','Ventas')
ggplot(data = venta_plataforma,aes(x = Plataforma ,y = Ventas , fill = Tipo_Venta)) + 
  geom_bar(colour='black',stat='identity',position='dodge') + 
  theme_bw()+
  theme(axis.text.x = element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5))+
  ggtitle('Ventas Plataforma') +
  scale_fill_brewer(palette = 'YlGnBu')


#Ventas por cada genero 
ventas_genero = df %>% group_by(Genre) %>% summarise(GlobalSales = sum(Global_Sales),
                                                   NA_Sales = sum(NA_Sales),
                                                   EU_Sales = sum(EU_Sales),
                                                   JP_Sales = sum(JP_Sales)) 
ventas_genero = melt(ventas_genero)
names(ventas_genero) = c('Genero','Tipo_venta','Ventas')

ggplot(data=ventas_genero,aes(x = Genero,y = Ventas,fill=Tipo_venta)) + 
  geom_bar(colour='black' , stat='identity', position='dodge') +  
  theme_bw()+
  theme(axis.text.x = element_text(hjust=1,angle=45),
        plot.title = element_text(hjust=0.5)) + ## center 
  ggtitle('Ventas por Genero') + 
  scale_fill_brewer(palette = 'YlGnBu')+
  ylab('Ventas')


#Cantidad de juegos por genero
C_genero = df %>% group_by(Genre) %>% summarise(Count = n())

ggplot(data=C_genero , aes(x = Genre,y=Count,fill=Count)) +
  geom_bar(colour='black',stat='identity') +
  theme_bw()+
  ggtitle('Genero') + 
  theme(axis.text.x = element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5)) +
  scale_fill_distiller(palette = 'RdYlBu') + 
  ylab('Cantidad')


#Genero mas popular por año
genero_popular_por_año = df %>% group_by(Year_of_Release,Genre) %>% 
  summarise(GlobalSales = sum(Global_Sales)) %>%
  arrange(desc(GlobalSales)) %>%
  arrange(Year_of_Release) %>% top_n(1)

ggplot(data = genero_popular_por_año , 
       aes(x = Year_of_Release, y = GlobalSales,fill=Genre)) +
  geom_bar(colour='black',stat='identity') +
  ggtitle('Genero mas popular por año') +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=.5)) +
  scale_fill_brewer(palette = 'RdYlBu')


#Ventas de cada platafotma en cada region
platform_sales <-df %>%
  group_by(Platform) %>%
  summarise(GlobalSales = sum(Global_Sales),
            NA_Sales = sum(NA_Sales),
            EU_Sales = sum(EU_Sales),
            JP_Sales = sum(JP_Sales),.groups = 'drop') %>%
  arrange(desc(GlobalSales))
platform_sales11 <- head(platform_sales,11)
platform_sales11 = melt(platform_sales11)
names(platform_sales11) = c('Platform','SaleDistrict','Sales')

options(repr.plot.width = 16, repr.plot.height = 8)
ggplot(data=platform_sales11,aes(x = SaleDistrict,y = Sales, fill=Platform))+
  geom_bar(stat='identity', position='dodge',colour='black' )+
  ggtitle("Popularidad de plataformas por region") +
  xlab("Ventas por region") +
  ylab("En millones") +
  theme_stata()+
  theme(legend.position="right")

#10 juegos mas populares
games_sales10 <-df %>%
  group_by(Name) %>%
  summarise(sum_global_sales = sum(Global_Sales),.groups = 'drop') %>%
  arrange(desc(sum_global_sales))
games_totalsales <- head(games_sales10,10)

options(repr.plot.width = 16, repr.plot.height = 8)
ggplot(data= games_totalsales, aes(x= Name, y=sum_global_sales)) +
  geom_bar(stat = "identity",  aes(x= Name, y=sum_global_sales,fill=Name))+
  ggtitle("Juegos mas vendidos") +
  xlab("Juegos") +
  ylab("En millones") +
  theme_stata()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position="none")

