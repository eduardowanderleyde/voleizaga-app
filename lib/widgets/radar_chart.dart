import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/player.dart';

class PlayerRadarChart extends StatelessWidget {
  final Player player;

  const PlayerRadarChart({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final titles = ['Ataque', 'Defesa', 'Recepção', 'Levantamento', 'Saque'];
    final values = [
      player.attack.toDouble(),
      player.defense.toDouble(),
      player.reception.toDouble(),
      player.setting.toDouble(),
      player.serve.toDouble(),
    ];

    if (player.speed != null) {
      titles.add('Velocidade');
      values.add(player.speed!.toDouble());
    }

    if (player.communication != null) {
      titles.add('Comunicação');
      values.add(player.communication!.toDouble());
    }

    return SizedBox(
      height: 200,
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              entryRadius: 2,
              dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
            ),
          ],
          radarBackgroundColor: Colors.grey[200],
          getTitle: (index, angle) {
            if (index < titles.length) {
              return RadarChartTitle(
                text: titles[index],
                angle: angle,
              );
            }
            return RadarChartTitle(text: '', angle: angle);
          },
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
          radarBorderData: BorderSide(color: Colors.grey[300]!),
          tickCount: 5,
          ticksTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
          tickBorderData: BorderSide(color: Colors.grey[300]!),
          gridBorderData: BorderSide(color: Colors.grey[300]!),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.black.withValues(alpha: 128),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
