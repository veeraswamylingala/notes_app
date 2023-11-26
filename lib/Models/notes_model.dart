class NotesModel {
  final int? id;
  final String nDescription;
  final String nDateTime;
  final String nTitle;

  const NotesModel({
    this.id,
    required this.nDescription,
    required this.nDateTime,
    required this.nTitle,
  });

  Map<String, dynamic> mapTransaction() {
    return {
      'id': id,
      'description': nDescription,
      'title': nTitle,
      'datetime': nDateTime,
    };
  }
}
