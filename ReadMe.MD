# Procesamiento de imagenes

En este repositorio se consolida el procesamiento de imagenes y su posterior analisis y clasificación segun sus caracteristicas.
- se uso MatLab
- se realizo la clasificacion manual de tipos de objetos
- segun el nombre de los archivos ordenados cada 5 archivos es un tipo de objeto
- para entrenamiento se usaron los primeros 3 objetos y para validacion los 2 ultimos por cada tipo
- modelos de machine learning usados: Random Fores y Redes Neuronales (ANN)

## Procesador de Imagenes
1. Se leen las imágenes de entrenamiento
2. Se procesa las imágenes mediante las herramientas que nos permitirán entregar las características, entre ellas morfológicas a tener en cuenta para el análisis con las herramientas de Machine Learning.
3. Se extraen los descriptores, es decir, las características de los objetos que se encuentran en las imágenes
4. Se genera la base de datos de descriptores que son el insumo de los algoritmos de Machine Learning.
5. Nombre del archivo de salida: **Descriptores_entrenamiento**.


## Modelos de machine Learnin
    Para los dos algoritmos se realizaron prueba inicial y se mejoró mediante entrenamiento d ellos mismos.

## Random Forest (RF)
1. se lee la base de datos en formato .xlsx denominada Descriptores_Prueba_Final
2. se establecen una configuración inicial donde se tiene en cuenta:
    - No de elementos de las categorías
    - No de elementos de prueba
    - Las características identificadas que pueden influir de mejor forma en el rendimiento del
algoritmo
3. Establecer el número de arboles
4. Se leen los parámetros de entrenamientos
5. Separamos datos de entrenamientos y prueba mediante la función CreaPruebaTest
6. se establece el Random Forest y se evalúan los resultados del entrenamiento versus la
validación

## Redes Neuronales (ANN)
1. se lee la base de datos en formato .xlsx denominada Descriptores_Prueba_Final
2. se establecen una configuración inicial donde se tiene en cuenta:
    - No de elementos de las categorías
    - No de elementos de prueba
    - Las características identificadas que pueden influir de mejor forma en el rendimiento del
algoritmo
3. Se establece las capas de las redes neuronales
4. Se leen los parámetros de entrenamiento
5. Separamos datos de entrenamientos y prueba mediante la función CreaPruebaTest
6. se establece la red Neuronal y se evalúan los resultados del entrenamiento versus la
validación.

