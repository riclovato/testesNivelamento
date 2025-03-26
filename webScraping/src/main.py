import logging
import re
import requests
from typing import Optional, Dict
from urllib.parse import urljoin
from bs4 import BeautifulSoup

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

class WebScraper:
   
    
    def __init__(self):
        self.session = requests.Session()
        self._set_default_headers()
        self.base_url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
        self.targets = {
        "Anexo I": {
            "url_pattern": r".*Anexo_I[^/]*\.pdf$",
            "text_clue": r"""
                Anexo\s+I      # Anexo I com possíveis espaços
                \.?            # Ponto opcional
                \s*            # Espaços opcionais
                pdf\s*         # pdf com espaços
                \)             # Fechamento de parênteses
            """
    },
    "Anexo II": {
            "url_pattern": r".*Anexo_II[^/]*\.pdf$",
            "text_clue": r"""
                Anexo\s+II     # Anexo II com possíveis espaços
                \.?            # Ponto opcional
                \s*            # Espaços opcionais
                pdf\s*         # pdf com espaços
                \)             # Fechamento de parênteses
            """
    }
}


    def _set_default_headers(self):
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7'
        }
        self.session.headers.update(headers)


    def fetch_page(self) -> Optional[str]:
        try:
            logger.info(f"Acessando página principal: {self.base_url}")
            response = self.session.get(self.base_url, timeout=15)
            response.raise_for_status()
            return response.text
        except requests.exceptions.RequestException as e:
            logger.error(f"Falha no acesso à página: {str(e)}")
            return None


    def find_pdf_links(self, html: str) -> Dict[str, str]:
        soup = BeautifulSoup(html, 'html.parser')
        found = {}
        
        for link in soup.find_all('a', href=True):
            href = link['href']
            
            # Filtra apenas PDFs
            if not href.lower().endswith('.pdf'):
                continue
                
            # Verifica cada padrão
            for name, target in self.targets.items():
                # Match no padrão do URL
                if re.fullmatch(target["url_pattern"], href, re.IGNORECASE):
                    # Captura contexto mais amplo
                    context_element = link.find_parent(['li', 'p', 'div']) or link
                    context_text = context_element.get_text(separator=" ", strip=True)
                    
                    if re.search(
                        rf'{target["text_clue"]}',
                        context_text, 
                        re.IGNORECASE | re.VERBOSE
                    ):
                        full_url = urljoin(self.base_url, href)
                        found[name] = full_url
                        logger.info(f"Link validado: {name} => {full_url}")
                        logger.debug(f"Contexto: '{context_text[:100]}...'")
                        break

        return found


    
def main():
    scraper = WebScraper()
    
    # Etapa 1: Obter conteúdo da página
    if (html := scraper.fetch_page()) is None:
        return

    # Etapa 2: Encontrar links dos PDFs
    pdf_links = scraper.find_pdf_links(html)
    
    if not pdf_links:
        logger.error("Nenhum anexo encontrado")
        return

    # Verificação final de anexos
    missing = [name for name in scraper.targets if name not in pdf_links]
    if missing:
        logger.error(f"Anexos faltantes: {', '.join(missing)}")
        return

if __name__ == "__main__":
    main()