import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../UserState.dart';
import '../models/models.dart';
import '../state.dart';
import '../util/Formatter.dart';
import '../util/Popups.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpenditureListView(
          context: context,
        ),
      ),
    );
  }
}

class ListEntry extends StatelessWidget {
  Prop<Expenditure> expenditure;

  ListEntry({required this.expenditure, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () =>
            expenditurePopup(expenditure: expenditure, context: context),
        child: ListTile(
          //return new ListTile(
          leading: const CircleAvatar(
            //Todo CategoryIcons
            backgroundColor: Colors.blue,
            child: Text("Icon"),
          ),
          title: Row(children: <Widget>[
            $(
                expenditure,
                (e) => Text(
                    "${e.name}  ${e.amount.toString()}  ${dateFormatter(e.date)}")),
          ]),
        ));
  }
}

class ExpenditureListView extends StatelessWidget {
  late final BuildContext context;
  late final Prop<IList<Prop<Expenditure>>> expendList;

  ExpenditureListView({required this.context, super.key}) {
    expendList = UserState.of(context).expendList;
  }

  @override
  Widget build(BuildContext context) {
    return $(
        expendList,
        (expenditures) => ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: expendList.value.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // return the header
                  return Row(
                    children: const [
                      Text("Name       "),
                      Text("Amount       "),
                      Text("Date"),
                    ],
                  );
                }
                index -= 1;
                var exp = expendList.value.get(index);
                return ListEntry(expenditure: exp);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ));
  }
}

// Todo move anywhere else
Future<String> imageToText(String path) async {
  final InputImage inputImage = InputImage.fromFilePath(path);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final RecognizedText recognizedText =
  await textRecognizer.processImage(inputImage);

  for (TextBlock block in recognizedText.blocks) {
    final String text = block.text;
    final List<String> languages = block.recognizedLanguages;

    for (TextLine line in block.lines) {
      // Same getters as TextBlock
      for (TextElement element in line.elements) {
        // Same getters as TextBlock
      }
    }
  }

  textRecognizer.close();
  return recognizedText.text;
}
