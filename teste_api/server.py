from flask import Flask, request, jsonify
from flask_cors import CORS
import csv
from unidecode import unidecode

app = Flask(__name__)
CORS(app)  # Habilita CORS para todas as rotas

def normalize_text(text):
    """Normaliza texto para busca case-insensitive e sem acentos"""
    return unidecode(str(text)).lower()

def load_data():
    """Carrega dados do CSV com tratamento de erros"""
    data = []
    try:
        with open(r"C:\dados\Relatorio_cadop.csv", 'r', encoding='utf-8') as file:
            csv_reader = csv.DictReader(file, delimiter=';')
            for row in csv_reader:
                data.append(row)
            print("✅ Dados carregados com sucesso!")
            print("📂 Registros carregados:", len(data))
            print("📄 Exemplo do primeiro registro:", data[0])
            return data
    except FileNotFoundError:
        print("❌ Erro: Arquivo CSV não encontrado!")
        return []
    except Exception as e:
        print(f"❌ Erro crítico ao ler CSV: {str(e)}")
        return []

# Carrega dados ao iniciar o servidor
data = load_data()

@app.route('/search', methods=['GET'])
def search():
    """Endpoint de busca textual"""
    query = normalize_text(request.args.get('q', ''))
    
    if not query or not data:
        return jsonify([])
    
    results = []
    for row in data:
        # Campos para busca
        search_fields = [
            row.get('Razao_Social', ''),
            row.get('Nome_Fantasia', ''),
            row.get('Cidade', ''),
            row.get('UF', ''),
            row.get('Regiao_de_Comercializacao', '')
        ]
        
        # Verifica correspondência em qualquer campo
        if any(query in normalize_text(field) for field in search_fields):
            # Constrói resultado com todos os campos
            result = {field: row.get(field, '') for field in [
                'Registro_ANS', 'CNPJ', 'Razao_Social', 'Nome_Fantasia',
                'Modalidade', 'Logradouro', 'Numero', 'Complemento',
                'Bairro', 'Cidade', 'UF', 'CEP', 'DDD', 'Telefone',
                'Fax', 'Endereco_eletronico', 'Representante',
                'Cargo_Representante', 'Regiao_de_Comercializacao',
                'Data_Registro_ANS'
            ]}
            results.append(result)
    
    return jsonify(results[:50])  # Retorna até 50 resultados

if __name__ == '__main__':
    try:
        print("\n🚀 Iniciando servidor Flask...")
        app.run(
            debug=True,
            port=5000,
            host='0.0.0.0',  # Permite acesso externo
            threaded=True     # Melhora performance
        )
    except Exception as e:
        print(f"❌ Falha ao iniciar servidor: {str(e)}")