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


def extract_tables_pdf(pdf_path, max_pages = None):
    """Extrai dados do pdf"""
    logger = logging.getLogger(__name__)
    data = []

    try:
        with pdfplumber.open(pdf_path) as pdf:
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

def normalize_text(text):
    """Normaliza texto removendo caracteres especiais e problemas de encoding"""
    if not text:
         return""
    
    text = unicodedata.normalize('NFKC', str(text))

    return text.strip()


def process_data(raw_data):
    """Valida e normaliza estrutura dos dados"""
    logger = logging.getLogger(__name__)
    processed_data = []
    
    try:
        logger.info("Normalizando dados e substituindo abreviações")
        for line in raw_data:
            # Aplica normalização
            processed_line = [normalize_text(cell) for cell in line]
            
            # Substitui valores OD → Seg. Odontológica e AMB → Seg. Ambulatorial
            if len(processed_line) >= 5:
                # Substitui diretamente o conteúdo das células
                processed_line[3] = "Seg. Odontológica" if processed_line[3].strip() else ""
                processed_line[4] = "Seg. Ambulatorial" if processed_line[4].strip() else ""
            
            # Garante 13 colunas
            processed_line = processed_line[:13] + [''] * (13 - len(processed_line))
            processed_data.append(processed_line)
            
        return processed_data
    except Exception as e:
        logger.error(f"ERRO: Falha no processamento - {str(e)}")
        sys.exit(1)


def generate_file(data):
    """Gera arquivos CSV com os dados processados"""
    logger = logging.getLogger(__name__)
    columns = [
        "PROCEDIMENTO", "RN (alteração)", "VIGÊNCIA",
        "Seg. Odontológica", "Seg. Ambulatorial", "HCO", "HSO", "REF", "PAC", "DUT",
        "SUBGRUPO", "GRUPO", "CAPÍTULO"
    ]

    try:
        logger.info("Criando dataframe")
        df = pd.DataFrame(data, columns=columns)
        #remove linhas vazias
        df = df.dropna(how='all')

        logger.info("Gerando arquivo CSV")
        df.to_csv(
            "procedimentos_saude.csv",
            index=False,
            encoding='utf-8-sig',
            sep=';',
            quoting=1
        )
        logger.info("Arquivos gerados com sucesso")
        
    except Exception as e:
        logger.error(f"Erro ao gerar arquivos: {str(e)}")
        sys.exit(1)



def main():
    logger = logging.getLogger(__name__)
    logger.info(f"Iniciando extração do arquivo {PDF_PATH}")

    if not os.path.exists(PDF_PATH):
        logger.error("PDF não encontrado")
        sys.exit(1)
    
    parser = argparse.ArgumentParser(description="Extract tables from PDF")
    parser.add_argument("--pages", type=int, help="Número máximo de páginas para processar")
    args = parser.parse_args()
    
   
    raw_data = extract_tables_pdf(PDF_PATH, args.pages)
    processed_data = process_data(raw_data)
    generate_file(processed_data)
    logger.info("Processo concluído com sucesso")


  



if __name__ == "__main__":
    main()