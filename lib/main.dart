// ===================================================================
// ATIVIDADE DE REVISÃO - SA02
// Lista de Compras
// ===================================================================

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
      home: const TelaLista(),
    );
  }
}

// TODO 1: classe/modelo Item
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

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // TODO 2: lista que guarda os itens
  final List<Item> itens = [];

  // Conta quantos itens já foram marcados como comprados
  int get totalComprados => itens.where((item) => item.comprado).length;

  // TODO 3: abre a tela de cadastro e recebe o item de volta
  Future<void> abrirTelaAdicionar() async {
    final novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (context) => const TelaAdicionarItem()),
    );

    // Garante que a tela ainda existe depois do await
    if (!mounted) return;

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${novoItem.nome} adicionado à lista')),
      );
    }
  }

  // TODO 4: remove o item da posição indicada
  void removerItem(int indice) {
    final removido = itens[indice];

    setState(() {
      itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${removido.nome} removido da lista')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        // TODO 5: contador "X de Y comprados"
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$totalComprados de ${itens.length} comprados',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),

      // TODO 6: ListView.builder com um Card para cada item
      body: ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, indice) {
          final item = itens[indice];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              subtitle: Text('x${item.quantidade}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removerItem(indice),
              ),
            ),
          );
        },
      ),

      // TODO 7: botão flutuante que abre a tela de cadastro
      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  // TODO 8: controllers dos campos de texto
  final nomeController = TextEditingController();
  final quantidadeController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  // TODO 9: valida os dados e devolve o novo item
  void salvar() {
    final nome = nomeController.text.trim();
    int quantidade = int.tryParse(quantidadeController.text) ?? 1;

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do item')),
      );
      return;
    }

    // Evita quantidade zero ou negativa
    if (quantidade < 1) {
      quantidade = 1;
    }

    Navigator.pop(context, Item(nome: nome, quantidade: quantidade));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TODO 10: campo do nome
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // TODO 11: campo da quantidade
            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // TODO 12: botão Salvar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}