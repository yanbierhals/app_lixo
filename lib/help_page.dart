import 'package:flutter/material.dart';
import 'main_page.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int? expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      "question": "Quantos pontos posso fazer por dia?",
      "answer": "Você pode fazer até X pontos por dia,o scanner ainda funciona apos esse numero de vezes, porem não contabilizara pontos."
    },
    {
      "question": "Quero excluir minha conta",
      "answer": "Para excluir sua conta, contate o suporte pelo email pedindo para exclusão da conta,."
    },
    {
      "question": "Qual o limite de desconto que eu posso conseguir?",
      "answer": "O limite de desconto varia, mas pode chegar a X% em algumas situações. tudo varia de acordo com o seu reciclar!!"
    },
    {
      "question": "Quero falar com o suporte",
      "answer": "Você pode entrar em contato pelo nosso email 'emailteste@gmail.com' estamos sempre a disposição."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Perguntas Frequentes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          faqs[index]["question"]!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onExpansionChanged: (isOpen) {
                          setState(() {
                            expandedIndex = isOpen ? index : null;
                          });
                        },
                        children: expandedIndex == index
                            ? [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              faqs[index]["answer"]!,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ]
                            : [],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                icon: Icon(Icons.arrow_back),
                label: Text("Voltar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
