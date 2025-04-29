import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/rating.dart';
import 'package:uuid/uuid.dart';

class RatingScreen extends StatefulWidget {
  final Player player;
  final Player rater;
  final Function(Rating) onSubmit;

  const RatingScreen({
    super.key,
    required this.player,
    required this.rater,
    required this.onSubmit,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  int attack = 5;
  int defense = 5;
  int setting = 5;
  int reception = 5;
  int serve = 5;
  int block = 5;
  String? comment;

  void _submitRating() {
    if (_formKey.currentState!.validate()) {
      final rating = Rating(
        id: _uuid.v4(),
        playerId: widget.player.id,
        raterId: widget.rater.id,
        date: DateTime.now(),
        attack: attack,
        defense: defense,
        setting: setting,
        reception: reception,
        serve: serve,
        block: block,
        comment: comment,
      );

      widget.onSubmit(rating);
      Navigator.pop(context);
    }
  }

  Widget _buildAttributeSlider({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 16),
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: value.toString(),
          onChanged: (double newValue) {
            setState(() {
              onChanged(newValue.round());
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliar ${widget.player.name}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Avalie as habilidades de ${widget.player.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildAttributeSlider(
                label: 'Ataque',
                value: attack,
                onChanged: (value) => attack = value,
              ),
              _buildAttributeSlider(
                label: 'Defesa',
                value: defense,
                onChanged: (value) => defense = value,
              ),
              _buildAttributeSlider(
                label: 'Levantamento',
                value: setting,
                onChanged: (value) => setting = value,
              ),
              _buildAttributeSlider(
                label: 'Recepção',
                value: reception,
                onChanged: (value) => reception = value,
              ),
              _buildAttributeSlider(
                label: 'Saque',
                value: serve,
                onChanged: (value) => serve = value,
              ),
              _buildAttributeSlider(
                label: 'Bloqueio',
                value: block,
                onChanged: (value) => block = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Comentário (opcional)',
                  hintText: 'Adicione um comentário sobre o jogador',
                ),
                maxLines: 3,
                onChanged: (value) => comment = value.isEmpty ? null : value,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitRating,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Enviar Avaliação',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
