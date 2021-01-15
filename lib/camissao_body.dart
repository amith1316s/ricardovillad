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
import 'create.dart';

class Camiss_body extends StatefulWidget {
  final BuildContext context;
  Camiss_body({this.context});

  @override
  _Camiss_bodyState createState() => _Camiss_bodyState();
}

class _Camiss_bodyState extends State<Camiss_body> {
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
             SizedBox(height: 20.0,),
            Text(
              'CAMBISTA',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            
         
            Column(
              children: [
                SizedBox(height: 40.0,),
                Row(
                  children: [
                    ApostaItem('Valores de jodgos efetuados na semana', aposta1, () {
                      aposta1 = true;
                      aposta2 = false;
                      aposta3 = false;
                      aposta4 = false;
                      setState(() {
                       
                      });
                    }),
                  ], 
                ),
            SizedBox(height: 16),
                            Row(
                  children: [
                    ApostaItem('Valores de jogos efetuados no dia', aposta2, () {
                      aposta1 = true;
                      aposta2 = false;
                      aposta3 = false;
                      aposta4 = false;
                      setState(() {
                      
                      });
                    }),
                  ], 
                ),
            SizedBox(height: 16),
                            Row(
                  children: [
                    ApostaItem('Comissao a receber', aposta2, () {
                      aposta1 = true;
                      aposta2 = false;
                      aposta3 = false;
                      aposta4 = false;
                      setState(() {
                          Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CambistaCreateScreen()));
                      });
                    }),
                  ], 
                ),
            SizedBox(height: 16),
                            Row(
                  children: [
                    ApostaItem('Valor a pagar',  aposta2, () {
                      aposta1 = true;
                      aposta2 = false;
                      aposta3 = false;
                      aposta4 = false;
                      setState(() {
                      
                      });
                    }),
                  ], 
                ),
            SizedBox(height: 16),
              ],
            ),
            SizedBox(height: 20),
            
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
  final String name;

  final bool isSelected;
  final Function onPressed;

  ApostaItem(this.name, this.isSelected, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
            decoration: BoxDecoration(
                color: isSelected ? MyColors.orange : Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                border: Border.all(
                    color: isSelected ? MyColors.orange : Colors.transparent)),
            child: Column(
              children: [
                Text(
                  '$name ',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
