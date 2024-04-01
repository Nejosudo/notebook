// ignore_for_file: deprecated_member_use
import 'package:crud_practica/db/operacion.dart';
import 'package:crud_practica/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SavePage extends StatefulWidget {
  static const String ROUTE = "/save";

  //SavePage({Key? key, required BuildContext context}) : super(key: key);
  SavePage({Key? key}) : super(key: key);

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  final _formkey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Note? note = ModalRoute.of(context)?.settings.arguments as Note?;

    _init(note);

    return Scaffold(
      appBar: AppBar(
        title: Text("Guardar"),
      ),
      body: Container(
        child: _buildForm(context, note),
      ),
    );
  }

  _init(Note? note) {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    }
  }

  Widget _buildForm(BuildContext context, Note? note) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que ingresar datos";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Titulo",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: contentController,
              maxLines: 8,
              maxLength: 1000,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tiene que ingresar datos";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Contenido",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            ElevatedButton(
              child: Text("Guardar"),
              onPressed: () async {
                if (_formkey.currentState?.validate() ?? false) {
                  int result = 0;

                  if (note?.id != null && note!.id! > 0) {
                    //actualizacion
                    Note updateNote = Note(
                      id: note.id,
                      title: titleController.text,
                      content: contentController.text,
                    );
                    result = await operacion.update(updateNote);
                  } else {
                    result = await operacion.insert(Note(
                      title: titleController.text,
                      content: contentController.text,
                    ));
                  }

                  if (result != null && result > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nota Guardada')),
                    );
                    titleController.clear();
                    contentController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al guardar la nota')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
