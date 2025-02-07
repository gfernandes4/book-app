import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.green, secondary: Colors.blue, error: Colors.red),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Fundo branco
            foregroundColor: Colors.green, // Texto e ícone verde
            side: const BorderSide(color: Colors.green), // Borda verde
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Borda arredondada
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            // Quando não está selecionado
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            // Quando está selecionado
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Colors.green, width: 2), // Borda verde
          ),
          labelStyle: const TextStyle(
              color: Colors.green), // Cor do rótulo quando focado
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var titulo = "";
  var itemCount = 0;
  bool isLoading = false;

  void _buscarLivros() async {
    setState(() {
      isLoading = true;
    });
    titulo = _controller.text;
    final url =
        Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': titulo});
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      itemCount = jsonResponse['totalItems'];
      print('Número de livros sobre $titulo: $itemCount.');
    } else {
      print('Falha na solicitação com status: ${response.statusCode}.');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Remove o foco quando tocar fora
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              TextField(
                controller: _controller,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _buscarLivros,
                icon: const Icon(Icons.search),
                label: const Text('Pesquisa'),
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      "Foram encontrados $itemCount livros sobre $titulo",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 32,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
