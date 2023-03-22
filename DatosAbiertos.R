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

# importar datos 
inversiones <- read.csv("DETALLE_INVERSIONES.csv")
detalle <- read.csv("Detalle_Inversiones_Diccionario.csv")







