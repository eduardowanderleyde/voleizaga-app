import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/team_drawer.dart';
import '../widgets/player_card.dart';

class TeamDrawerScreen extends StatefulWidget {
  final List<Player> players;
  final int initialNumberOfTeams;

  const TeamDrawerScreen({
    super.key,
    required this.players,
    this.initialNumberOfTeams = 2,
  });

  @override
  State<TeamDrawerScreen> createState() => _TeamDrawerScreenState();
}

class _TeamDrawerScreenState extends State<TeamDrawerScreen> {
  late int numberOfTeams;

  @override
  void initState() {
    super.initState();
    numberOfTeams = widget.initialNumberOfTeams;
  }

  @override
  Widget build(BuildContext context) {
    final result =
        TeamDrawer.drawTeams(widget.players, numberOfTeams: numberOfTeams);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Times Sorteados'),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Número de Times: ',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 16),
                            DropdownButton<int>(
                              value: numberOfTeams,
                              items: [2, 3, 4].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    '$value Times',
                                    style: const TextStyle(fontSize: 18),
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
                      ),
                    ),
                    const SizedBox(height: 16),
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
