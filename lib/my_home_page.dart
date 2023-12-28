import 'package:first_dapp/life_meaning_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lifeMeaningProvider = Provider.of<LifeMeaningModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Consumer<LifeMeaningModel>(
        builder: (context, lifeMeaningModel, child) {
          print("LifeMeaningModel loading: ${lifeMeaningModel.loading}");
          return Center(
            child: lifeMeaningModel.loading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'The current meaning of life: ${lifeMeaningModel.lifeMeaning.toString()}'),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: inputController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'What is the meaning of life?'),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            print('get input: ${inputController.text}');
                            await lifeMeaningProvider.setMeaning(
                                BigInt.from(int.parse(inputController.text)));
                            inputController.clear();
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text('save'),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }
}
