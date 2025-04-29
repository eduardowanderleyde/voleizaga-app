from typing import List
from ..models import Player
from ..schemas import TeamDrawResponse
import random

def draw_teams(players: List[Player], number_of_teams: int) -> TeamDrawResponse:
    """
    Sorteia os times com base nos jogadores disponíveis.
    """
    present_players = [p for p in players if p.is_present]
    
    # Verificar número mínimo de jogadores
    min_players = number_of_teams * 6
    if len(present_players) < min_players:
        return TeamDrawResponse(
            teams=[],
            error=f'São necessários pelo menos {min_players} jogadores presentes para formar {number_of_teams} times'
        )

    # Separar jogadores por posição
    setters = [p for p in present_players if p.position.value == 'setter']
    outsides = [p for p in present_players if p.position.value == 'outside']
    middles = [p for p in present_players if p.position.value == 'middle']

    # Verificar número mínimo por posição
    min_per_position = number_of_teams * 2
    if (len(setters) < min_per_position or 
        len(outsides) < min_per_position or 
        len(middles) < min_per_position):
        return TeamDrawResponse(
            teams=[],
            error=f'São necessários pelo menos:\n- {min_per_position} levantadores\n- {min_per_position} ponteiros\n- {min_per_position} centrais'
        )

    # Gerar várias combinações e escolher a mais equilibrada
    best_teams = None
    min_score_diff = float('inf')

    for _ in range(5):  # Tentar 5 combinações diferentes
        # Embaralhar jogadores
        random.shuffle(setters)
        random.shuffle(outsides)
        random.shuffle(middles)

        # Criar times
        teams = [[] for _ in range(number_of_teams)]
        team_scores = [0.0 for _ in range(number_of_teams)]

        # Distribuir levantadores
        for i in range(number_of_teams):
            teams[i].extend(setters[i*2:(i+1)*2])
            team_scores[i] += sum(_calculate_player_score(p) for p in teams[i])

        # Distribuir ponteiros
        for i in range(number_of_teams):
            teams[i].extend(outsides[i*2:(i+1)*2])
            team_scores[i] += sum(_calculate_player_score(p) for p in teams[i][-2:])

        # Distribuir centrais
        for i in range(number_of_teams):
            teams[i].extend(middles[i*2:(i+1)*2])
            team_scores[i] += sum(_calculate_player_score(p) for p in teams[i][-2:])

        # Calcular diferença de pontuação
        score_diff = max(team_scores) - min(team_scores)

        # Atualizar melhor combinação
        if score_diff < min_score_diff:
            min_score_diff = score_diff
            best_teams = teams

    if best_teams is None:
        return TeamDrawResponse(
            teams=[],
            error='Não foi possível gerar times equilibrados'
        )

    return TeamDrawResponse(teams=best_teams, error=None)

def _calculate_player_score(player: Player) -> float:
    """
    Calcula a pontuação de um jogador com base em sua posição.
    """
    if player.position.value == 'setter':
        return (player.setting * 3 + 
                player.defense + 
                (player.communication or 5)) / 5.0
    
    elif player.position.value in ['outside', 'opposite']:
        return (player.attack * 2 + 
                player.reception * 2 + 
                player.serve) / 5.0
    
    elif player.position.value == 'middle':
        return (player.attack * 2 + 
                player.defense * 2 + 
                (player.speed or 5)) / 5.0
    
    elif player.position.value == 'libero':
        return (player.defense * 3 + 
                player.reception * 2) / 5.0
    
    return 0.0 