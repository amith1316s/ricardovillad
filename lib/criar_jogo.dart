import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:baratinha/loader.dart';
import 'package:baratinha/services/aposta_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'mycolors.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class CriarJogo extends StatefulWidget {
  final BuildContext context;
  CriarJogo({this.context});

  @override
  _CriarJogoState createState() => _CriarJogoState();
}

class _CriarJogoState extends State<CriarJogo> {
  ApostaService _apostaService = ApostaService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  AudioPlayer audioPlayer = AudioPlayer();

  //selected number and price
  bool aposta1 = true, aposta2 = false, aposta3 = false, aposta4 = false;

  //boolean to find which number is selected and which is not. In starting its false because none is selected
  List<bool> numbers = List.generate(44, (index) => false);
  List<int> selectedNumbers = [];
  int selectableNumberCount = 6;
  double cost = 2.00;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha seus numeros:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 44,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (selectableNumberCount > selectedNumbers.length ||
                          numbers[index]) {
                        numbers[index] = !numbers[index];
                        //todo: add functionality to save selected numbers
                        setState(() {
                          if (numbers[index]) {
                            selectedNumbers.add(index + 1);
                          } else {
                            selectedNumbers.remove(index + 1);
                          }
                        });
                        selectedNumbers.sort();
                      } else {
                        final snackBar = SnackBar(
                          content: Text('Você excedeu sua quantia de números!'),
                          duration: Duration(seconds: 1),
                        );

                        ScaffoldMessenger.of(widget.context)
                            .showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: numbers[index]
                            ? MyColors.orange
                            : Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(numbers[index] ? 16 : 4),
                        ),
                        border: Border.all(
                          color:
                              numbers[index] ? MyColors.orange : Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: numbers[index] ? Colors.white : Colors.black,
                        ),
                      )),
                    ),
                  );
                }),
            SizedBox(height: 32),
            Text.rich(
              TextSpan(
                text: 'Numeros escolhidos: ',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  //todo: selected numbers come here
                  TextSpan(
                    text: selectedNumbers.length > 0
                        ? selectedNumbers.join(' - ')
                        : 'none',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Aposta com:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                ApostaItem('6', '2', aposta1, () {
                  aposta1 = true;
                  aposta2 = false;
                  aposta3 = false;
                  aposta4 = false;
                  setState(() {
                    selectableNumberCount = 6;
                    cost = 2.00;
                    if (selectedNumbers.length > 6) {
                      selectedNumbers.sublist(6).forEach((element) {
                        numbers[element - 1] = false;
                      });
                      selectedNumbers = selectedNumbers.sublist(0, 6);
                    }
                  });
                }),
                SizedBox(width: 4),
                ApostaItem('7', '4', aposta2, () {
                  aposta1 = false;
                  aposta2 = true;
                  aposta3 = false;
                  aposta4 = false;
                  setState(() {
                    selectableNumberCount = 7;
                    cost = 4.00;
                    if (selectedNumbers.length > 7) {
                      selectedNumbers.sublist(7).forEach((element) {
                        numbers[element - 1] = false;
                      });
                      selectedNumbers = selectedNumbers.sublist(0, 7);
                    }
                  });
                }),
                SizedBox(width: 4),
                ApostaItem('8', '16', aposta3, () {
                  aposta1 = false;
                  aposta2 = false;
                  aposta3 = true;
                  aposta4 = false;
                  setState(() {
                    selectableNumberCount = 8;
                    cost = 16.00;
                    if (selectedNumbers.length > 8) {
                      selectedNumbers.sublist(8).forEach((element) {
                        numbers[element - 1] = false;
                      });
                      selectedNumbers = selectedNumbers.sublist(0, 8);
                    }
                  });
                }),
                SizedBox(width: 4),
                ApostaItem('9', '36', aposta4, () {
                  aposta1 = false;
                  aposta2 = false;
                  aposta3 = false;
                  aposta4 = true;
                  setState(() {
                    selectableNumberCount = 9;
                    cost = 36.00;
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Text.rich(
              TextSpan(
                text: 'Valor da Aposta: ',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                children: [
                  //todo: selected price comes here
                  TextSpan(
                    text: 'R\$ ${cost.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    Loader.showLoadingScreen(context, _keyLoader);
                    var res =
                        await _apostaService.addTicket(selectedNumbers, cost);
                    Loader.stopLoadingScreen(context);
                    if (res) {
                      final file = new File(
                          '${(await getTemporaryDirectory()).path}/music.mp3');
                      await file.writeAsBytes(
                          (await loadAsset()).buffer.asUint8List());
                      final result =
                          await audioPlayer.play(file.path, isLocal: true);
                      await generateAndPrintPdf();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.orange,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Finalizar Aposta',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  loadAsset() async {
    return await rootBundle.load('assets/moneysound.mp3');
  }

  generateAndPrintPdf() async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
              format: PdfPageFormat.a3,
              html: '''<html><body>
              <h1>Baratinha</h1>
              <h3>Data : ${DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())}</h3>
              <h3>Valor de Aposta : R\$ ${cost.toStringAsFixed(2)}</h3>
              <h4>Numeros escolhidos</h4>
              <p>${selectedNumbers.length > 0 ? selectedNumbers.join(' - ') : 'none'}</p>
              </body></html>''',
            ));
  }
}

class ApostaItem extends StatelessWidget {
  final String number;

  final String price;
  final bool isSelected;
  final Function onPressed;

  ApostaItem(this.number, this.price, this.isSelected, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
                color: isSelected ? MyColors.orange : Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                border: Border.all(
                    color: isSelected ? MyColors.orange : Colors.black)),
            child: Column(
              children: [
                Text(
                  '$number numeros',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'R\$ $price,00',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
