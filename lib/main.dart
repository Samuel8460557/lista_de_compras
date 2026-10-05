import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      home: const TelaLista(),
    );
  }
}

// Modelo do item
class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

// Tela principal
class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // Lista que guarda os itens
  List<Item> itens = [];

  // Abre a tela para adicionar um novo item
  Future<void> abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoItem.nome} adicionado à lista'),
        ),
      );
    }
  }

  // Remove um item da lista
  void removerItem(int indice) {
    final String nomeItem = itens[indice].nome;

    setState(() {
      itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nomeItem removido da lista'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Conta quantos itens foram comprados
    final int comprados =
        itens.where((item) => item.comprado).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$comprados de ${itens.length} comprados',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),

      // Lista de itens
      body: itens.isEmpty
          ? const Center(
              child: Text(
                'Nenhum item na lista.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, indice) {
                final item = itens[indice];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.comprado,
                      onChanged: (valor) {
                        setState(() {
                          item.comprado = valor!;
                        });
                      },
                    ),

                    title: Text(
                      item.nome,
                      style: TextStyle(
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    subtitle: Text(
                      'Quantidade: ${item.quantidade}',
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        removerItem(indice);
                      },
                    ),
                  ),
                );
              },
            ),

      // Botão para adicionar item
      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Tela de cadastro
class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  // Controllers dos campos
  final TextEditingController nomeController =
      TextEditingController();

  final TextEditingController quantidadeController =
      TextEditingController();

  // Salva o novo item
  void salvar() {
    final String nome = nomeController.text.trim();

    final int quantidade =
        int.tryParse(quantidadeController.text) ?? 1;

    // Verifica se o nome foi preenchido
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite o nome do item.',
          ),
        ),
      );

      return;
    }

    // Devolve o item para a tela principal
    Navigator.pop(
      context,
      Item(
        nome: nome,
        quantidade: quantidade,
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Item'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo do nome
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Campo da quantidade
            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Botão salvar
            ElevatedButton(
              onPressed: salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
