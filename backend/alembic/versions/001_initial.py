"""initial

Revision ID: 001
Revises: 
Create Date: 2024-01-01 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '001'
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
    # Criar enum types
    op.execute("CREATE TYPE player_position AS ENUM ('setter', 'outside', 'opposite', 'middle', 'libero')")
    op.execute("CREATE TYPE player_status AS ENUM ('active', 'inactive', 'injured', 'suspended')")
    
    # Criar tabela players
    op.create_table(
        'players',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('number', sa.Integer(), nullable=False),
        sa.Column('position', postgresql.ENUM('setter', 'outside', 'opposite', 'middle', 'libero', name='player_position'), nullable=False),
        sa.Column('status', postgresql.ENUM('active', 'inactive', 'injured', 'suspended', name='player_status'), nullable=False),
        sa.Column('height', sa.Float(), nullable=False),
        sa.Column('weight', sa.Float(), nullable=False),
        sa.Column('photo_url', sa.String(), nullable=True),
        sa.Column('birth_date', sa.DateTime(), nullable=False),
        sa.Column('nationality', sa.String(), nullable=False),
        sa.Column('is_present', sa.Boolean(), nullable=False, default=True),
        
        # Habilidades
        sa.Column('attack', sa.Integer(), nullable=False),
        sa.Column('defense', sa.Integer(), nullable=False),
        sa.Column('setting', sa.Integer(), nullable=False),
        sa.Column('reception', sa.Integer(), nullable=False),
        sa.Column('serve', sa.Integer(), nullable=False),
        sa.Column('speed', sa.Integer(), nullable=True),
        sa.Column('communication', sa.Integer(), nullable=True),
        
        # Contato
        sa.Column('phone', sa.String(), nullable=True),
        sa.Column('email', sa.String(), nullable=True),
        
        # Timestamps
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('now()')),
        sa.Column('updated_at', sa.DateTime(), nullable=False, server_default=sa.text('now()')),
        
        # Constraints
        sa.PrimaryKeyConstraint('id'),
        sa.CheckConstraint('attack >= 0 AND attack <= 5', name='check_attack_range'),
        sa.CheckConstraint('defense >= 0 AND defense <= 5', name='check_defense_range'),
        sa.CheckConstraint('setting >= 0 AND setting <= 5', name='check_setting_range'),
        sa.CheckConstraint('reception >= 0 AND reception <= 5', name='check_reception_range'),
        sa.CheckConstraint('serve >= 0 AND serve <= 5', name='check_serve_range'),
        sa.CheckConstraint('speed IS NULL OR (speed >= 0 AND speed <= 5)', name='check_speed_range'),
        sa.CheckConstraint('communication IS NULL OR (communication >= 0 AND communication <= 5)', name='check_communication_range'),
        sa.CheckConstraint('height > 0', name='check_height_positive'),
        sa.CheckConstraint('weight > 0', name='check_weight_positive'),
        sa.CheckConstraint('number >= 0', name='check_number_positive'),
    )

def downgrade() -> None:
    op.drop_table('players')
    op.execute('DROP TYPE player_position')
    op.execute('DROP TYPE player_status') 