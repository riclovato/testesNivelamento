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


def extract_tables_pdf(PDF_PATH, max_pages = None):
    """Extrai dados do pdf"""
    logger = logging.getLogger(__name__)
    data = []

    try:
        with pdfplumber.open(PDF_PATH) as pdf:
            total_pages = len(pdf.pages)
        
            for i, page in enumerate(pdf.pages):
                if max_pages and i >= max_pages:
                    break
                    
                logger.info(f"Processando página {i + 1}/{total_pages}")
                tables = page.extract_tables()
                
                for table in tables:
                    for line in table:
                        if line and "PROCEDIMENTO" not in str(line[0]):
                            data.append([cell.strip() if cell else "" for cell in line])
        logger.info(f"Extraídas {len(data)} linhas")
        return data
    except Exception as e:
        logger.error(f"Erro na extração: {str(e)}")
        sys.exit(1)


def main():
    logger = logging.getLogger(__name__)
    logger.info(f"Iniciando extração do arquivo {PDF_PATH}")

    #Verifica se o arquivo existe
    if not os.path.exists(PDF_PATH):
        logger.error("PDF não encontrado")
        sys.exit(1)
        
    
    parser = argparse.ArgumentParser(description="Extrai tabelas do PDF")
    parser.add_argument("--pages", type=int, help="Número máximo de páginas para processar")
    args = parser.parse_args()

    #Extração
    data = extract_tables_pdf(PDF_PATH, args.pages)
    logger.info("Extração concluída com sucesso")
  



if __name__ == "__main__":
    main()