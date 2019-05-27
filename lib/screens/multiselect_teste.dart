import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/widget/multi_select.dart';

class MultiSelectScreen extends StatefulWidget { 
  @override
  _MultiSelectScreenState createState() => _MultiSelectScreenState();
}

class _MultiSelectScreenState extends State<MultiSelectScreen> {

  Firestore _firestore = Firestore.instance;

  List<dynamic> reportList = [];

  void _searchEsportes() async {
    var esportes = await _firestore.collection("esportes").orderBy("nome").getDocuments();
    reportList = esportes.documents.map((e){
      return e.data["nome"];
    }).toList();   
    //print(reportList); 
  }  

  List<dynamic> selectedReportList = List();

  _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Selecione os Esportes"),
            content: MultiSelect(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              }
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("confirmar"),
                onPressed: () {
                  //print(selectedReportList);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _searchEsportes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: RaisedButton(
            child: Text("Esportes"),
            onPressed: () => _showReportDialog(),
          ),
        ),
        Text(selectedReportList.join(" , ")),
      ],
    );
  }
}