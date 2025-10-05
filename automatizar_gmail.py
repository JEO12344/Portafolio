import os
from dotenv import load_dotenv
import smtplib
import pandas as pd
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
# se debe crear un archivo env que tenga EMAIL y contraseña de app de la cuenta que se quiera utilizar
load_dotenv()

EMAIL = os.getenv("EMAIL")
PASSWORD = os.getenv("EMAIL_PASSWORD")

# cargar contactos desde Excel
df = pd.read_excel("enviar.xlsx")  # columnas: Nombre, Email, Mensaje

server = smtplib.SMTP("smtp.gmail.com", 587)
server.starttls()
server.login(EMAIL, PASSWORD)

for _, row in df.iterrows():
    usuario = row["usuario"]
    destinatario = row["correo"]
    clave = row["clave"]

    msg = MIMEMultipart()
    msg["From"] = EMAIL
    msg["To"] = destinatario
    msg["Subject"] = f"Asunto importante"

    cuerpo = f"""
    Hola esto es un mensaje
    """
    msg.attach(MIMEText(cuerpo, "plain"))

    server.sendmail(EMAIL, destinatario, msg.as_string())
    print(f"Correo enviado a {destinatario}")

server.quit()
