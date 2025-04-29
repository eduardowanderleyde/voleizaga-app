# Voleizaga Backend

Backend da aplicação Voleizaga, desenvolvido com FastAPI e PostgreSQL.

## Requisitos

- Python 3.8+
- PostgreSQL
- pip (gerenciador de pacotes Python)

## Configuração

1. Crie um ambiente virtual:

```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
.\venv\Scripts\activate  # Windows
```

2. Instale as dependências:

```bash
pip install -r requirements.txt
```

3. Configure as variáveis de ambiente:

```bash
# Crie um arquivo .env com as seguintes variáveis
DATABASE_URL=postgresql://user:password@localhost:5432/voleizaga_db
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

4. Configure o banco de dados:

```bash
# Crie o banco de dados no PostgreSQL
createdb voleizaga_db

# Execute as migrações
alembic upgrade head
```

## Executando o servidor

```bash
uvicorn app.main:app --reload
```

O servidor estará disponível em `http://localhost:8000`

## Documentação da API

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Endpoints principais

### Jogadores

- `GET /api/players` - Lista todos os jogadores
- `GET /api/players/{id}` - Obtém um jogador específico
- `POST /api/players` - Cria um novo jogador
- `PUT /api/players/{id}` - Atualiza um jogador
- `DELETE /api/players/{id}` - Remove um jogador

### Times

- `POST /api/teams/draw` - Sorteia times com base nos jogadores selecionados

## Estrutura do projeto

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py           # Aplicação FastAPI
│   ├── database.py       # Configuração do banco de dados
│   ├── models.py         # Modelos SQLAlchemy
│   ├── schemas.py        # Schemas Pydantic
│   └── utils/
│       └── team_drawer.py # Lógica de sorteio de times
├── alembic/              # Migrações do banco de dados
├── requirements.txt      # Dependências do projeto
└── .env                  # Variáveis de ambiente
```
