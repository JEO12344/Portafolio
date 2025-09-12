library(readxl)
library(ggplot2)

setwd("C:/Users/Usuario/Downloads")
df <- read.csv("online_sales_dataset.csv", sep = ",")

summary(df)
# Filtrar valores positivos
positive_rows <- df$Quantity > 0 & df$UnitPrice > 0
df_clean <- df[positive_rows, ]

# Calcular nuevas columnas
df_clean$TotalSale <- df_clean$Quantity * df_clean$UnitPrice * (1 - df_clean$Discount)
df_clean$Profit <- df_clean$TotalSale - (df_clean$ShippingCost * df_clean$Quantity)
df_clean$InvoiceDate <- as.Date(df_clean$InvoiceDate, format = "%m/%d/%Y")

cat("Filas después de limpieza:", nrow(df_clean), "\n")

# Ventas totales por país
ventas_pais <- aggregate(TotalSale ~ Country, data = df_clean, sum, na.rm = TRUE)
ventas_pais <- ventas_pais[order(-ventas_pais$TotalSale), ]

barplot(ventas_pais$TotalSale[1:10], 
        names.arg = ventas_pais$Country[1:10],
        las = 2,
        main = "Top 10 Países por Ventas",
        col = "steelblue")

# Rentabilidad por categoría
profit_categoria <- aggregate(cbind(TotalSale, Profit) ~ Category, 
                              data = df_clean, 
                              sum, 
                              na.rm = TRUE)

profit_categoria$ProfitMargin <- profit_categoria$Profit / profit_categoria$TotalSale
profit_categoria <- profit_categoria[order(-profit_categoria$ProfitMargin), ]

print("Categorías más rentables:")
print(head(profit_categoria))



# Top clientes por gasto
clientes_top <- aggregate(TotalSale ~ CustomerID, 
                          data = df_clean[!is.na(df_clean$CustomerID), ], 
                          sum, 
                          na.rm = TRUE)

clientes_top <- clientes_top[order(-clientes_top$TotalSale), ]
print("Top 10 clientes por gasto:")
print(head(clientes_top, 10))


# Resumen ejecutivo de resultados
cat("=== RESUMEN EJECUTIVO ===\n")
cat("Total de ventas: $", sum(df_clean$TotalSale, na.rm = TRUE), "\n")
cat("Total de profit: $", sum(df_clean$Profit, na.rm = TRUE), "\n")
cat("Margen promedio: ", mean(profit_categoria$ProfitMargin, na.rm = TRUE) * 100, "%\n")
cat("País con más ventas: ", ventas_pais$Country[1], "\n")
cat("Categoría más rentable: ", profit_categoria$Category[1], "\n")

