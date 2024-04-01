class Note {
  final int? id;
  final String title;
  final String content;

  Note({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {'title': title, 'content': content};
  }

  static Note empty() {
    return Note(id: 0, title: '', content: '');
  }
}
