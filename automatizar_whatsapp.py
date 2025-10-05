import pywhatkit
import pandas as pd
import time
import random

# Cargar contactos desde Excel
df = pd.read_excel("celular3.xlsx")  # columnas: Nombre, Numero, clave

for index, row in df.iterrows():
    numero = f"+549{row['numero']}"  # agregar código de país y '9' de WhatsApp
    mensaje = f"""
Hola,esto es un mensaje para  {row['Nombre']} para pasarle su clave {row['clave']}

"""

    pywhatkit.sendwhatmsg_instantly(numero, mensaje, wait_time=20, tab_close=True)
    print(f"Mensaje enviado a {numero}")
    time.sleep(random.randint(5, 15))
