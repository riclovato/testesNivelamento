import pdfplumber
import pandas as pd
import unicodedata
import argparse
import sys
import logging
import os

# Configurações do path relativo
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PDF_PATH = os.path.join(BASE_DIR, '..','..', 'webScraping', 'downloads','Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf')

#Configurações de logging
logging.basicConfig(
    level =logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("extracao.log"),
        logging.StreamHandler()
    ]
)



def main():
    logger = logging.getLogger(__name__)
    logger.info(f"Iniciando extração do arquivo {PDF_PATH}")

    #Verifica se o arquivo existe
    if not os.path.exists(PDF_PATH):
        logger.error("PDF não encontrado")
        
    
    parser = argparse.ArgumentParser(description="Extrai tabelas do PDF")
    parser.add_argument("--pages", type=int, help="Número máximo de páginas para processar")
    parser = parser.parse_args()
  



if __name__ == "__main__":
    main()