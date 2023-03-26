#### Configuraciones iniciales

setwd("C:/Users/percy/Downloads/USB/EP - Visualizacion de datos/EXAMEN/Examen_EPC")

rm(list = ls())
library(tidyverse)
library(grid)
library(gridExtra)
library(sf)
library(janitor)
library(RColorBrewer)
library(data.table)
library(readxl)
library(readr)
library(readr)
library(dplyr)

#Carguemos los datos de Datos Abiertos
#https://datosabiertos.mef.gob.pe/dataset/detalle-de-inversiones


# buscar la ruta del archivo de csv
# file.choose()

#### Inversiones Perú (2021) ####
# Copiar ruta de la consola y guardar en variable
ruta_csv_a <- "C:\\Users\\percy\\Downloads\\USB\\EP - Visualizacion de datos\\EXAMEN\\DETALLE_INVERSIONES.csv"
ruta_csv_b <- "C:\\Users\\percy\\Downloads\\USB\\EP - Visualizacion de datos\\EXAMEN\\Detalle_Inversiones_Diccionario.csv"


#####################################
# 2. importar csv con código de R #
#####################################

# importar datos 
inversiones <- read_csv(ruta_csv_a)
detalle <- read_csv(ruta_csv_b)

# mirar datos
head(inversiones)
list.files()

# Nombre de las columnas 
colnames(inversiones)
unique(inversiones$SITUACION)
# 

# Ordenemos el dataframe en funcion a la columna NIVEL
inversiones %>% 
    arrange(MONTO_VALORIZACION) %>% 
    # == comparación
    filter(SECTOR == "AGRICULTURA Y RIEGO")%>% 
    # = asignación (se usa para asignar valores a los argumentos)
    ggplot(mapping = aes(x = COSTO_ACTUALIZADO))+
    geom_histogram()


# Valores faltantes
colSums(is.na(inversiones))
unique(inversiones$DEPARTAMENTO)


# Separemos los datos por DEPARTAMENTO 
departamentos <- inversiones %>% 
    filter(is.na(inversiones["DEPARTAMENTO"]) == FALSE )


unique(departamentos$DEPARTAMENTO)
colnames(departamentos)


# Eliminemos variables en columns
dep <- select(departamentos, NIVEL, SECTOR, ENTIDAD, ESTADO, SITUACION, 
              MONTO_VIABLE, COSTO_ACTUALIZADO, FECHA_REGISTRO, FECHA_VIABILIDAD,
              FUNCION, PROGRAMA, SUBPROGRAMA, MARCO, TIPO_INVERSION, REGISTRADO_PMI, 
              EXPEDIENTE_TECNICO, INFORME_CIERRE, TIENE_F9, TIENE_AVAN_FISICO, 
              AVANCE_FISICO, AVANCE_EJECUCION, MONTO_VALORIZACION, SANEAMIENTO, DEPARTAMENTO,
              PROVINCIA, DISTRITO, UBIGEO, LATITUD, LONGITUD, FEC_FIN_EJECUCION, 
              FEC_INI_EJEC_FISICA, FEC_FIN_EJEC_FISICA, BENEFICIARIO, AÑO_PROCESO)




# Nombre de las columnas 
colnames(dep)
unique(dep$AVANCE_EJECUCION)

# Ordenemos el dataframe en funcion a la columna NIVEL
dep %>% 
    arrange(MONTO_VALORIZACION) %>% 
    # == comparación
    filter(SECTOR == "AGRICULTURA Y RIEGO")%>% 
    # = asignación (se usa para asignar valores a los argumentos)
    ggplot(mapping = aes(x = AVANCE_EJECUCION))+
    geom_histogram()


# Valores faltantes
colSums(is.na(inversiones))
unique(inversiones$DEPARTAMENTO)


# Separemos los datos del departamento de LIMA 
lima <- dep %>% 
    filter(DEPARTAMENTO == "LIMA" )

unique(lima$DEPARTAMENTO)
colSums(is.na(lima))

# Veamos los valores perdidos por columnas 
colSums(is.na(lima))
# 

# Veamos los valores perdidos por columnas 
colSums(is.na(dep))


# Numero de expedientes por privincia en el departamento de Lima 
NumExpedientes <- lima %>% 
    group_by(PROVINCIA) %>%
    # N(): cuenta el numero de observaciones en cada grupo
    summarise(NumEmpresas = n())


# Eliminemos las observaciones con NA // Lima
lima_a <- lima %>% 
    drop_na()


install.packages("openxlsx2")
library(openxlsx)
write.xlsx(lima_a, "datos.xlsx", asTable = TRUE)



#########################################################################
# ***********************ELABORACION DEL MAPA ***********************
#########################################################################

setwd("C:/Users/percy/Downloads/USB/EP - Visualizacion de datos/EXAMEN/Examen_EPC")

pacman::p_load(sp, sf, purr, ggrepel, raster, tidyverse, ggplot2, tmap, tidygeocoder, ggspatial)
library(pacman)
#install.packages("broom", type="binary")
#install.packages("withr")

provincias<-st_read("Region Lima_Provincia.shp")
puntos<-st_read("data.shp")

class(provincias)
class(puntos)

summary(provincias)
summary(puntos)


#sistema de proyeccion
st_geometry(provincias)
st_geometry(puntos)

#metadatos
st_crs(provincias)
st_crs(puntos)

#grafica
plot(provincias, axes = T,cex.axis=0.7)
plot(puntos, axes = T,cex.axis=0.7)

#plot solo la geometria
plot(st_geometry(provincias))
plot(st_geometry(puntos))

#usando la libreria ggplot2
ggplot(data = provincias) +
    geom_sf(fill = "yellow", color = "black")

ggplot(data = puntos) +
    geom_sf(fill = "yellow", color = "black")


#añadir titulo y etiqueta de los ejes
ggplot(data = provincias) +
    geom_sf(aes(fill=NOMBPROV)) +
    geom_sf(data = puntos) +
    xlab("Longitud") + ylab("Latitud") +
    ggtitle("Distritos de la Provincia de Lima",
            subtitle = "Realizado por: Percy M. Huancoillo Ticona")

#Flecha norte y escala
#install.packages('ggspatial')
install.packages('yarrr')
install.packages('ggpubr')
library(ggspatial)
library(ggpubr)
library(yarrr)


# Dispositivo PNG
png("mapa.png")
# introducimos el codigo

ggplot(data = provincias) + 
    geom_sf(color='black') +
    geom_sf(data = puntos, color='black', size=1.5) +
    xlab("Longitud") + ylab("Latitud") +
    ggtitle("Proyectos de Inversion en el departamento de Lima",
            subtitle = "Realizado por: Percy M. Huancoillo Ticona") +
    annotation_scale() +
    annotation_north_arrow(location = "br", whih_north = "true", style = north_arrow_nautical ())+
    coord_sf()

# retirar el fondo gris
theme_bw() 

# Cerramos el dispositivo
dev.off()

