import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({super.key, required this.player});

  String _getPositionName(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.setter:
        return 'Levantador';
      case PlayerPosition.outside:
        return 'Ponteiro';
      case PlayerPosition.opposite:
        return 'Oposto';
      case PlayerPosition.middle:
        return 'Central';
      case PlayerPosition.libero:
        return 'Líbero';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(player.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(player.name),
        subtitle: Text(_getPositionName(player.position)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (player.position == PlayerPosition.setter) ...[
              Icon(
                Icons.star,
                size: 16,
                color: player.setting >= 4 ? Colors.amber : Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
            if (player.position == PlayerPosition.outside ||
                player.position == PlayerPosition.opposite) ...[
              Icon(
                Icons.sports_volleyball,
                size: 16,
                color: player.attack >= 4 ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
            if (player.position == PlayerPosition.middle) ...[
              Icon(
                Icons.block,
                size: 16,
                color: player.defense >= 4 ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
            if (player.position == PlayerPosition.libero) ...[
              Icon(
                Icons.shield,
                size: 16,
                color: player.defense >= 4 ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }
}
