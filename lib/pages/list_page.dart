// import 'dart:js_interop';
import 'package:crud_practica/db/operacion.dart';
import 'package:crud_practica/models/note.dart';
import 'package:crud_practica/pages/save_page.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  static const String ROUTE = "/";

  @override
  Widget build(BuildContext context) {
    return _myList();
  }
}

class _myList extends StatefulWidget {
  @override
  State<_myList> createState() => _myListState();
}

class _myListState extends State<_myList> {
  List<Note> notes = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, SavePage.ROUTE, arguments: Note.empty())
              .then((value) => setState(() {
                    _loadData();
                  }));
        },
      ),
      appBar: AppBar(
        title: Text("Listado"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (_, i) => _createItem(i),
        ),
      ),
    );
  }

  _loadData() async {
    List<Note> auxNote = await operacion.notes();

    setState(() {
      notes = auxNote;
    });
  }

// Funciona para crear items en la lista y para eliminarlos
  _createItem(int i) {
    return Dismissible(
      key: Key(i.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(left: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete_rounded,
                color: Colors.white,
              ))),
      onDismissed: (direction) {
        print(direction);
        operacion.delete(notes[i]);
      },
      child: ListTile(
        title: Text(notes[i].title),
        trailing: MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, SavePage.ROUTE, arguments: notes[i])
                  .then((value) => setState(() {
                        _loadData();
                      }));
            },
            child: Icon(Icons.edit)),
      ),
    );
  }
}
