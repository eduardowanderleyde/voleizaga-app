import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/team_drawer.dart';
import '../widgets/player_card.dart';

class TeamDrawerScreen extends StatefulWidget {
  final List<Player> players;

  const TeamDrawerScreen({super.key, required this.players});

  @override
  State<TeamDrawerScreen> createState() => _TeamDrawerScreenState();
}

class _TeamDrawerScreenState extends State<TeamDrawerScreen> {
  int numberOfTeams = 2;

  @override
  Widget build(BuildContext context) {
    final result =
        TeamDrawer.drawTeams(widget.players, numberOfTeams: numberOfTeams);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Times Sorteados'),
        actions: [
          DropdownButton<int>(
            value: numberOfTeams,
            items: [2, 3, 4].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('$value Times'),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  numberOfTeams = newValue;
                });
              }
            },
          ),
        ],
      ),
      body: result.error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  result.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < result.teams.length; i++) ...[
                      Text(
                        'Time ${i + 1}',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              for (var player in result.teams[i])
                                PlayerCard(player: player),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
