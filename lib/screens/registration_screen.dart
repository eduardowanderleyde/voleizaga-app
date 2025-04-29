import 'package:flutter/material.dart';
import '../models/player.dart';
import 'package:uuid/uuid.dart';

class RegistrationScreen extends StatefulWidget {
  final Function(Player) onRegister;

  const RegistrationScreen({super.key, required this.onRegister});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  String name = '';
  int number = 0;
  PlayerPosition position = PlayerPosition.outside;
  double height = 170.0;
  double weight = 70.0;
  String nationality = 'Brasileiro';
  String? phone;
  String? email;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final player = Player(
        id: _uuid.v4(),
        name: name,
        number: number,
        position: position,
        status: PlayerStatus.active,
        height: height,
        weight: weight,
        nationality: nationality,
        attack: 5,
        defense: 5,
        setting: 5,
        reception: 5,
        serve: 5,
        block: 5,
        phone: phone,
        email: email,
      );

      widget.onRegister(player);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Inicial'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bem-vindo ao Vôlei Zaga!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Por favor, preencha seus dados para começar:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'Digite seu nome completo',
                ),
                key: const Key('name_field'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu nome';
                  }
                  return null;
                },
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Número da Camisa *',
                  hintText: 'Digite o número da sua camisa',
                ),
                key: const Key('number_field'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o número da sua camisa';
                  }
                  final n = int.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Digite um número válido';
                  }
                  return null;
                },
                onChanged: (value) => number = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PlayerPosition>(
                value: position,
                key: const Key('position_field'),
                decoration: const InputDecoration(labelText: 'Posição *'),
                items: PlayerPosition.values.map((pos) {
                  return DropdownMenuItem(
                    value: pos,
                    child: Text(Player.positionToString(pos)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => position = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Altura (cm) *',
                        hintText: 'Ex: 180',
                      ),
                      key: const Key('height_field'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite sua altura';
                        }
                        final h = double.tryParse(value);
                        if (h == null || h <= 0) {
                          return 'Altura inválida';
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          height = double.tryParse(value) ?? 170.0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Peso (kg) *',
                        hintText: 'Ex: 75',
                      ),
                      key: const Key('weight_field'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite seu peso';
                        }
                        final w = double.tryParse(value);
                        if (w == null || w <= 0) {
                          return 'Peso inválido';
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          weight = double.tryParse(value) ?? 70.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '(XX) XXXXX-XXXX',
                ),
                key: const Key('phone_field'),
                onChanged: (value) => phone = value.isEmpty ? null : value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'seu.email@exemplo.com',
                ),
                key: const Key('email_field'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value.isEmpty ? null : value,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Registrar',
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
