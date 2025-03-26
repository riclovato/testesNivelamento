import logging
import requests
from typing import Optional
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

class WebScraper:
    """Classe principal para operações de web scraping
    
    Attributes:
        session: Sessão HTTP reutilizável
    """
    def __init__(self):
        self.session = requests.Session()
        self._set_default_headers()
        logger.debug("Nova instância do webScraper criada")

    def _set_default_headers(self) -> None:
        """ Config headers padrão para simular um navegador"""
        headers = {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7'
        }
        self.session.headers.update(headers)
        logger.info("Headers padrão configurados")

    def fetch_url(self, url: str) -> Optional[str]:
        """
        Obtém o conteúdo de uma página web

        Args:
            url: Endereço web

        Returns:
            Conteúdo HTML como string/None
        """
        try:
            logger.info(f"Iniciando requisição para {url}")
            response = self.session.get(url, timeout=10)
            response.raise_for_status()
            logger.debug(f"Resposta recebida. Status Code: {response.status_code}")
            return response.text
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Falha na requisição: {str(e)}")
            return None


def main():
    scraper = WebScraper()
    url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"

    if html_contect := scraper.fetch_url(url):
        print("Conteúdo obtido com sucesso!")
        print(html_contect)
    else:
        print("Falha ao obter conteúdo!")
    
if __name__ == "__main__":
    main()
