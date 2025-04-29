from datetime import datetime
import sys
import os

# Adicionar o diretório pai ao PYTHONPATH
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import SessionLocal, engine
from app.models import Base, Player
from sqlalchemy import text

def init_db():
    # Criar todas as tabelas
    Base.metadata.create_all(bind=engine)
    
    # Criar uma sessão
    db = SessionLocal()
    
    try:
        # Limpar tabela de jogadores
        db.execute(text("DELETE FROM players"))
        db.commit()
        
        # Lista de jogadores inicial
        players = [
            # Levantadores (4)
            {
                "name": "Hugo",
                "number": 1,
                "position": "setter",
                "status": "active",
                "height": 182.0,
                "weight": 75.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 3,
                "defense": 4,
                "setting": 5,
                "reception": 4,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Carla",
                "number": 2,
                "position": "setter",
                "status": "active",
                "height": 175.0,
                "weight": 65.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 3,
                "defense": 4,
                "setting": 5,
                "reception": 4,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Pedro",
                "number": 3,
                "position": "setter",
                "status": "active",
                "height": 180.0,
                "weight": 73.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 3,
                "defense": 4,
                "setting": 5,
                "reception": 4,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Ana",
                "number": 4,
                "position": "setter",
                "status": "active",
                "height": 172.0,
                "weight": 63.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 3,
                "defense": 4,
                "setting": 5,
                "reception": 4,
                "serve": 4,
                "is_present": True
            },
            # Centrais (4)
            {
                "name": "Leo",
                "number": 5,
                "position": "middle",
                "status": "active",
                "height": 190.0,
                "weight": 85.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 3,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Art",
                "number": 6,
                "position": "middle",
                "status": "active",
                "height": 188.0,
                "weight": 82.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 3,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Marcus",
                "number": 7,
                "position": "middle",
                "status": "active",
                "height": 192.0,
                "weight": 87.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 3,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Julia",
                "number": 8,
                "position": "middle",
                "status": "active",
                "height": 180.0,
                "weight": 70.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 3,
                "serve": 4,
                "is_present": True
            },
            # Ponteiros (6)
            {
                "name": "Izi",
                "number": 9,
                "position": "outside",
                "status": "active",
                "height": 178.0,
                "weight": 72.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 5,
                "is_present": True
            },
            {
                "name": "Vivi",
                "number": 10,
                "position": "outside",
                "status": "active",
                "height": 175.0,
                "weight": 68.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 5,
                "is_present": True
            },
            {
                "name": "Zinho",
                "number": 11,
                "position": "outside",
                "status": "active",
                "height": 182.0,
                "weight": 76.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 5,
                "is_present": True
            },
            {
                "name": "Nath",
                "number": 12,
                "position": "outside",
                "status": "active",
                "height": 176.0,
                "weight": 67.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 5,
                "is_present": True
            },
            # Opostos (3)
            {
                "name": "Bruno",
                "number": 13,
                "position": "opposite",
                "status": "active",
                "height": 185.0,
                "weight": 80.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 4,
                "serve": 5,
                "is_present": True
            },
            {
                "name": "Sara",
                "number": 14,
                "position": "opposite",
                "status": "active",
                "height": 178.0,
                "weight": 70.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 4,
                "serve": 5,
                "is_present": True
            },
            {
                "name": "Dan",
                "number": 15,
                "position": "opposite",
                "status": "active",
                "height": 183.0,
                "weight": 78.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 5,
                "defense": 4,
                "setting": 3,
                "reception": 4,
                "serve": 5,
                "is_present": True
            },
            # Líberos (3)
            {
                "name": "Lucca",
                "number": 16,
                "position": "libero",
                "status": "active",
                "height": 170.0,
                "weight": 65.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 2,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Gus",
                "number": 17,
                "position": "libero",
                "status": "active",
                "height": 172.0,
                "weight": 68.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 2,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 4,
                "is_present": True
            },
            {
                "name": "Shama",
                "number": 18,
                "position": "libero",
                "status": "active",
                "height": 168.0,
                "weight": 63.0,
                "birth_date": datetime.now(),
                "nationality": "Brasileiro",
                "attack": 2,
                "defense": 5,
                "setting": 3,
                "reception": 5,
                "serve": 4,
                "is_present": True
            }
        ]
        
        # Adicionar jogadores ao banco de dados
        for player_data in players:
            player = Player(**player_data)
            db.add(player)
        
        # Commit das alterações
        db.commit()
        print("Banco de dados inicializado com sucesso!")
        print(f"Total de jogadores: {len(players)}")
        print("\nDistribuição por posição:")
        positions = {
            "setter": "Levantadores",
            "middle": "Centrais",
            "outside": "Ponteiros",
            "opposite": "Opostos",
            "libero": "Líberos"
        }
        for pos, name in positions.items():
            count = sum(1 for p in players if p["position"] == pos)
            print(f"{name}: {count}")
            
    except Exception as e:
        print(f"Erro ao inicializar banco de dados: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_db() 