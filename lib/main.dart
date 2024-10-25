import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoadingLogin = false;
  bool isLoadingRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoadingLogin
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: signIn,
                    child: const Text('Login'),
                  ),
            SizedBox(height: 20),
            isLoadingRegister
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: const Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    setState(() {
      isLoadingLogin = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Simula um delay de 1 segundo antes de navegar
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DataEntryPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao fazer login: $e')),
      );
    } finally {
      setState(() {
        isLoadingLogin = false;
      });
    }
  }

  Future<void> register() async {
    setState(() {
      isLoadingRegister = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      // Simula um delay de 1 segundo antes de permitir que o botão seja clicado novamente
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao cadastrar: $e')),
      );
    } finally {
      setState(() {
        isLoadingRegister = false;
      });
    }
  }
}

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({Key? key}) : super(key: key);

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController primeiroNomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  bool isLoading = false;

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('aula2410flutter').add({
        'primeiroNome': primeiroNomeController.text,
        'sobrenome': sobrenomeController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados salvos com sucesso!')),
      );

      // Simula um delay de 1 segundo antes de permitir que o botão seja clicado novamente
      await Future.delayed(const Duration(seconds: 1));
      primeiroNomeController.clear();
      sobrenomeController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao salvar dados: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: primeiroNomeController,
              decoration: InputDecoration(labelText: 'Primeiro Nome'),
            ),
            TextField(
              controller: sobrenomeController,
              decoration: InputDecoration(labelText: 'Sobrenome'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveData,
                    child: const Text('Salvar Dados'),
                  ),
          ],
        ),
      ),
    );
  }
}
