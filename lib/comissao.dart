import 'package:flutter/material.dart';

import 'camissao_body.dart';
import 'gerente_body.dart';
import 'mycolors.dart';
import 'home.dart';

class Camisso extends StatefulWidget {
  @override
  _CamissoState createState() => _CamissoState();
}

class _CamissoState extends State<Camisso> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //todo: add new tabs here
  var tabs = [];

  @override
  void initState() {
    tabs = [
      Camiss_body(context: context),
     Camiss_body(),
      Camiss_body(),
      Camiss_body(),
    ];
    super.initState();
  }

  //selected tab
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: MyColors.blue,
      appBar: AppBar(
        backgroundColor: MyColors.blue,
        title: Image.asset(
          'assets/logo.jpg',
          height: 70,
        ),
        actions: [
          Row(
            children: [
              Text(
                'Bem Vindo, Cambista',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(6),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.person, color: MyColors.orange),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 8,
                top: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  TabItem(9, currentIndex, 0, 'Criar Jogooo', () {
                    setState(() {
                      currentIndex = 0;
                    });
                  }),
                  TabItem(9, currentIndex, 1, 'Resultados', () {
                    setState(() {
                      currentIndex = 1;
                    });
                  }),
                  TabItem(8, currentIndex, 2, 'Comissao', () {
                    
                    setState(() {
                    /*   Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home())); */
                      currentIndex = 2;
                    });
                  
                  }),
                  TabItem(4, currentIndex, 3, 'Sair', () {
                    //todo: logout
                  }),
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: tabs[currentIndex],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    ));
  }
}

class TabItem extends StatelessWidget {
  final int flex;
  final int index;
  final int currentIndex;
  final String text;
  final Function onPressed;

  TabItem(this.flex, this.index, this.currentIndex, this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: index == currentIndex ? MyColors.orange : Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: index == currentIndex ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ));
  }
}
