import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/player.dart';
import 'services/storage_service.dart';
import 'services/rating_service.dart';
import 'widgets/radar_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'screens/team_drawer_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/rating_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Cores do tema
const primaryColor = Color(0xFF1E88E5); // Azul principal
const secondaryColor = Color(0xFF43A047); // Verde para ações positivas
const backgroundColor = Color(0xFFF5F5F5); // Fundo claro
const surfaceColor = Colors.white;
const errorColor = Color(0xFFD32F2F); // Vermelho para erros

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Limpar todos os dados salvos e forçar o uso dos jogadores padrão
  await StorageService.clearAll();

  // Verificar se é o primeiro acesso
  final prefs = await SharedPreferences.getInstance();
  final isFirstAccess = prefs.getBool('is_first_access') ?? true;

  // Forçar isFirstAccess como false para pular a tela de registro
  await prefs.setBool('is_first_access', false);

  runApp(MyApp(isFirstAccess: false));
}

class MyApp extends StatelessWidget {
  final bool isFirstAccess;

  const MyApp({super.key, required this.isFirstAccess});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vôlei Zaga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          error: errorColor,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: Builder(
        builder: (context) => isFirstAccess
            ? RegistrationScreen(
                onRegister: (player) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('is_first_access', false);
                  await StorageService.savePlayers([player]);

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              )
            : const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  List<Player> regularPlayers = [];
  List<Player> waitingList = [];
  List<Player> guestList = [];

  int numberOfTeams = 2;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      final players = await StorageService.loadPlayers();
      if (kDebugMode) {
        print('Total de jogadores carregados: ${players.length}');
      }
      setState(() {
        regularPlayers =
            players.where((p) => p.status == PlayerStatus.active).toList();
        waitingList =
            players.where((p) => p.status == PlayerStatus.inactive).toList();
        guestList =
            players.where((p) => p.status == PlayerStatus.suspended).toList();

        if (kDebugMode) {
          print('Regulares: ${regularPlayers.length}');
          print('Lista de espera: ${waitingList.length}');
          print('Suspensos: ${guestList.length}');
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar jogadores: $e')),
        );
      }
    }
  }

  Future<void> _savePlayers() async {
    try {
      final allPlayers = [...regularPlayers, ...waitingList, ...guestList];
      await StorageService.savePlayers(allPlayers);
      if (kDebugMode) {
        print('Total de jogadores salvos: ${allPlayers.length}');
        print('Regulares: ${regularPlayers.length}');
        print('Lista de espera: ${waitingList.length}');
        print('Suspensos: ${guestList.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar jogadores: $e');
      }
      rethrow;
    }
  }

  void _addNewPlayer() {
    final newPlayer = Player(
      id: _uuid.v4(),
      name: '',
      number: 0,
      position: PlayerPosition.outside,
      status: PlayerStatus.active,
      height: 170.0,
      weight: 70.0,
      birthDate: DateTime.now(),
      nationality: 'Brasileiro',
      attack: 5,
      defense: 5,
      reception: 5,
      setting: 5,
      serve: 5,
      block: 5,
    );
    _editPlayer(newPlayer);
  }

  // Função auxiliar para calcular pontuação específica por posição
  double _getPositionScore(Player player) {
    switch (player.position) {
      case PlayerPosition.setter:
        return (player.setting * 3 +
                player.defense +
                (player.communication ?? 5)) /
            5.0;
      case PlayerPosition.outside:
        return (player.attack * 2 + player.reception * 2 + player.serve) / 5.0;
      case PlayerPosition.opposite:
        return (player.attack * 3 + player.serve * 2) / 5.0;
      case PlayerPosition.middle:
        return (player.attack * 2 + player.defense * 2 + (player.speed ?? 5)) /
            5.0;
      case PlayerPosition.libero:
        return (player.defense * 3 + player.reception * 2) / 5.0;
    }
  }

  void _sortTeams() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDrawerScreen(
          players: [...regularPlayers, ...waitingList, ...guestList],
          initialNumberOfTeams: numberOfTeams,
        ),
      ),
    );
  }

  Future<void> _pickImage(Function(String?) onImageSelected) async {
    if (!context.mounted) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null && context.mounted) {
        onImageSelected(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao selecionar imagem')),
        );
      }
    }
  }

  void _editPlayer(Player player) {
    String name = player.name;
    int number = player.number;
    PlayerStatus status = player.status;
    PlayerPosition position = player.position;
    String? photoUrl = player.photoUrl;
    double height = player.height;
    double weight = player.weight;
    DateTime? birthDate = player.birthDate;
    String nationality = player.nationality;
    int attack = player.attack;
    int defense = player.defense;
    int reception = player.reception;
    int setting = player.setting;
    int serve = player.serve;
    int block = player.block;
    int? speed = player.speed;
    int? communication = player.communication;
    String? phone = player.phone;
    String? email = player.email;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(player.id.isEmpty ? 'Novo Jogador' : 'Editar Jogador'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(
                      (path) => setDialogState(() => photoUrl = path)),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      image: photoUrl != null
                          ? DecorationImage(
                              image: FileImage(File(photoUrl!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: photoUrl == null
                        ? const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nome *',
                    hintText: 'Digite o nome do jogador',
                  ),
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Número *',
                    hintText: 'Digite o número da camisa',
                  ),
                  controller: TextEditingController(text: number.toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => number = int.tryParse(value) ?? 0,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Altura (cm) *',
                          hintText: 'Ex: 180',
                        ),
                        controller:
                            TextEditingController(text: height.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            height = double.tryParse(value) ?? 170.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Peso (kg) *',
                          hintText: 'Ex: 75',
                        ),
                        controller:
                            TextEditingController(text: weight.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            weight = double.tryParse(value) ?? 70.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nacionalidade *',
                    hintText: 'Ex: Brasileiro',
                  ),
                  controller: TextEditingController(text: nationality),
                  onChanged: (value) => nationality = value,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<PlayerStatus>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Status *'),
                  items: PlayerStatus.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(Player.statusToString(e)),
                          ))
                      .toList(),
                  onChanged: (value) => setDialogState(() => status = value!),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<PlayerPosition>(
                  value: position,
                  decoration: const InputDecoration(labelText: 'Posição *'),
                  items: PlayerPosition.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(Player.positionToString(e)),
                          ))
                      .toList(),
                  onChanged: (value) => setDialogState(() => position = value!),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Atributos Principais',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildAttributeSlider(
                  label: 'Ataque',
                  value: attack,
                  onChanged: (value) => setDialogState(() => attack = value),
                ),
                _buildAttributeSlider(
                  label: 'Defesa',
                  value: defense,
                  onChanged: (value) => setDialogState(() => defense = value),
                ),
                _buildAttributeSlider(
                  label: 'Recepção',
                  value: reception,
                  onChanged: (value) => setDialogState(() => reception = value),
                ),
                _buildAttributeSlider(
                  label: 'Levantamento',
                  value: setting,
                  onChanged: (value) => setDialogState(() => setting = value),
                ),
                _buildAttributeSlider(
                  label: 'Saque',
                  value: serve,
                  onChanged: (value) => setDialogState(() => serve = value),
                ),
                _buildAttributeSlider(
                  label: 'Bloqueio',
                  value: block,
                  onChanged: (value) => setDialogState(() => block = value),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Atributos Opcionais',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildAttributeSlider(
                  label: 'Velocidade',
                  value: speed ?? 5,
                  onChanged: (value) => setDialogState(() => speed = value),
                  isOptional: true,
                ),
                _buildAttributeSlider(
                  label: 'Comunicação',
                  value: communication ?? 5,
                  onChanged: (value) =>
                      setDialogState(() => communication = value),
                  isOptional: true,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contato',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: 'Ex: (11) 99999-9999',
                  ),
                  controller: TextEditingController(text: phone ?? ''),
                  onChanged: (value) => phone = value.isEmpty ? null : value,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Ex: jogador@email.com',
                  ),
                  controller: TextEditingController(text: email ?? ''),
                  onChanged: (value) => email = value.isEmpty ? null : value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Validação dos campos obrigatórios
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nome é obrigatório')),
                  );
                  return;
                }
                if (number <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Número da camisa deve ser maior que 0')),
                  );
                  return;
                }
                if (height <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Altura deve ser maior que 0')),
                  );
                  return;
                }
                if (weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Peso deve ser maior que 0')),
                  );
                  return;
                }
                if (nationality.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Nacionalidade é obrigatória')),
                  );
                  return;
                }

                final updatedPlayer = player.copyWith(
                  name: name,
                  number: number,
                  status: status,
                  position: position,
                  photoUrl: photoUrl,
                  height: height,
                  weight: weight,
                  birthDate: birthDate,
                  nationality: nationality,
                  attack: attack,
                  defense: defense,
                  reception: reception,
                  setting: setting,
                  serve: serve,
                  block: block,
                  speed: speed,
                  communication: communication,
                  phone: phone,
                  email: email,
                );

                // Atualizar as listas usando setState do widget principal
                setState(() {
                  if (player.id.isEmpty) {
                    // Novo jogador
                    switch (status) {
                      case PlayerStatus.active:
                        regularPlayers.add(updatedPlayer);
                        break;
                      case PlayerStatus.inactive:
                        waitingList.add(updatedPlayer);
                        break;
                      case PlayerStatus.suspended:
                        guestList.add(updatedPlayer);
                        break;
                      case PlayerStatus.injured:
                        // Não implementado ainda
                        break;
                    }
                  } else {
                    // Remover o jogador de todas as listas primeiro
                    regularPlayers.removeWhere((p) => p.id == player.id);
                    waitingList.removeWhere((p) => p.id == player.id);
                    guestList.removeWhere((p) => p.id == player.id);

                    // Adicionar na lista correta
                    switch (status) {
                      case PlayerStatus.active:
                        regularPlayers.add(updatedPlayer);
                        break;
                      case PlayerStatus.inactive:
                        waitingList.add(updatedPlayer);
                        break;
                      case PlayerStatus.suspended:
                        guestList.add(updatedPlayer);
                        break;
                      case PlayerStatus.injured:
                        // Não implementado ainda
                        break;
                    }
                  }
                });

                try {
                  await _savePlayers();
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Jogador salvo com sucesso!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar jogador: $e')),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeSlider({
    required String label,
    required int value,
    required Function(int) onChanged,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 14,
            color: isOptional ? Colors.grey[600] : Colors.black87,
          ),
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: value.toString(),
          onChanged: (double newValue) {
            onChanged(newValue.round());
          },
        ),
      ],
    );
  }

  Widget _buildPlayerList(List<Player> players) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[200],
              backgroundImage: player.photoUrl != null
                  ? FileImage(File(player.photoUrl!))
                  : null,
              child: player.photoUrl == null
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            title: Text(
              player.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Player.positionToString(player.position),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  'Média: ${player.averageSkills.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.star_border, color: Colors.amber),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingScreen(
                          player: player,
                          rater: regularPlayers
                              .first, // Temporário: usar o primeiro jogador como avaliador
                          onSubmit: (rating) async {
                            await RatingService.saveRating(rating);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Avaliação enviada com sucesso!'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                  tooltip: 'Avaliar jogador',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editPlayer(player),
                  tooltip: 'Editar jogador',
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: player.isPresent,
                    onChanged: (value) {
                      setState(() {
                        final updatedPlayer =
                            player.copyWith(isPresent: value ?? false);
                        switch (player.status) {
                          case PlayerStatus.active:
                            final index = regularPlayers
                                .indexWhere((p) => p.id == player.id);
                            if (index != -1)
                              regularPlayers[index] = updatedPlayer;
                            break;
                          case PlayerStatus.inactive:
                            final index = waitingList
                                .indexWhere((p) => p.id == player.id);
                            if (index != -1) waitingList[index] = updatedPlayer;
                            break;
                          case PlayerStatus.suspended:
                            final index =
                                guestList.indexWhere((p) => p.id == player.id);
                            if (index != -1) guestList[index] = updatedPlayer;
                            break;
                          case PlayerStatus.injured:
                            // Não implementado ainda
                            break;
                        }
                      });
                      _savePlayers();
                    },
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Atributos Principais:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAttributeRow('Ataque', player.attack),
                    _buildAttributeRow('Defesa', player.defense),
                    _buildAttributeRow('Recepção', player.reception),
                    _buildAttributeRow('Levantamento', player.setting),
                    _buildAttributeRow('Saque', player.serve),
                    _buildAttributeRow('Bloqueio', player.block),
                    if (player.speed != null ||
                        player.communication != null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Atributos Opcionais:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (player.speed != null)
                        _buildAttributeRow('Velocidade', player.speed!),
                      if (player.communication != null)
                        _buildAttributeRow(
                            'Comunicação', player.communication!),
                    ],
                    if (player.phone != null || player.email != null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Contato:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (player.phone != null)
                        Text('Telefone: ${player.phone}'),
                      if (player.email != null) Text('Email: ${player.email}'),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _editPlayer(player),
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text(
                                    'Deseja realmente excluir o jogador ${player.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Excluir'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && mounted) {
                              setState(() {
                                regularPlayers
                                    .removeWhere((p) => p.id == player.id);
                                waitingList
                                    .removeWhere((p) => p.id == player.id);
                                guestList.removeWhere((p) => p.id == player.id);
                              });
                              await _savePlayers();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Jogador excluído com sucesso')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Excluir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gráfico de Atributos:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PlayerRadarChart(player: player),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttributeRow(String label, int value) {
    return Row(
      children: [
        Text('$label: '),
        LinearProgressIndicator(
          value: value / 10,
          backgroundColor: Colors.grey[200],
          color: _getColorForValue(value),
          minHeight: 8,
        ),
        const SizedBox(width: 8),
        Text(value.toString()),
      ],
    );
  }

  Color _getColorForValue(int value) {
    if (value >= 8) return Colors.green;
    if (value >= 6) return Colors.blue;
    if (value >= 4) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Vôlei Zaga',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.group), text: 'Ativos'),
              Tab(icon: Icon(Icons.watch_later), text: 'Lista de Espera'),
              Tab(icon: Icon(Icons.person_add), text: 'Suspensos'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _sortTeams,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Sortear Times'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<int>(
                      value: numberOfTeams,
                      dropdownColor: Colors.green,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      underline: Container(),
                      items: [2, 3, 4].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Times'),
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
                  ),
                  ElevatedButton.icon(
                    onPressed: _loadPlayers,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPlayerList(regularPlayers),
                  _buildPlayerList(waitingList),
                  _buildPlayerList(guestList),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewPlayer,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
