class Book {
  final int? id;
  final String title;
  final int price;
  final String author;

  Book({
    this.id,
    required this.title,
    required this.price,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {'_id': id, '_title': title, '_price': price, '_author': author};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['_id'],
      title: map['_title'],
      price: map['_price'],
      author: map['_author'],
    );
  }
}
