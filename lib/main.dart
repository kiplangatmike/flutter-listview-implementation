// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_import, prefer_final_fields, unused_element, unused_label, dead_code

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Favorite Books',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Favorite Books'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Book {
  final String title;
  final String author;
  final String genre;

  Book({required this.title, required this.author, required this.genre});
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Book> _books = [
    Book(
        title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Classic'),
    Book(title: 'Pride and Prejudice', author: 'Jane Austen', genre: 'Classic'),
    Book(title: '1984', author: 'George Orwell', genre: 'Classic'),
    Book(
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        genre: 'Classic'),
    Book(
        title: 'The Catcher in the Rye',
        author: 'J.D. Salinger',
        genre: 'Classic'),
    Book(
        title: 'Harry Potter and the Sorcerer\'s Stone',
        author: 'J.K. Rowling',
        genre: 'Fantasy'),
    Book(
        title: 'The Lord of the Rings',
        author: 'J.R.R. Tolkien',
        genre: 'Fantasy'),
    Book(
        title: 'The Hunger Games', author: 'Suzanne Collins', genre: 'Fantasy'),
    Book(
        title: 'Ender\'s Game',
        author: 'Orson Scott Card',
        genre: 'Science Fiction'),
    Book(title: 'Dune', author: 'Frank Herbert', genre: 'Science Fiction'),
  ];

  List<String> _genres = [
    'All',
    'Classic',
    'Fantasy',
    'Science Fiction',
  ];

  String _selectedGenre = 'All';

  Widget _buildBookList(BuildContext context) {
    List<Book> booksToDisplay = _selectedGenre == 'All'
        ? _books
        : _books.where((book) => book.genre == _selectedGenre).toList();

    return ListView.builder(
      itemCount: booksToDisplay.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(booksToDisplay[index].title),
          subtitle: Text(booksToDisplay[index].author),
        );
      },
    );
  }

  Widget _buildGenreGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3.0,
      children: List.generate(_genres.length, (index) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: _selectedGenre == _genres[index]
                  ? Colors.blue
                  : Colors.grey[200],
              border: Border.all(),
              borderRadius: BorderRadius.circular(5.0),
            ),
            alignment: Alignment.center,
            child: Text(_genres[index]),
          ),
          onTap: () {
            setState(() {
              _selectedGenre = _genres[index];
            });
          },
        );
      }),
    );
  }

  void _addBook(Book book) {
    setState(() {
      _books.add(book);
    });
  }

  void _removeBook(int index) {
    setState(() {
      _books.removeAt(index);
    });
  }

  void _editBook(int index, Book book) {
    setState(() {
      _books[index] = book;
    });
  }

  void _navigateAndAddBook(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookForm(addBook: _addBook)),
    );
  }

  void _navigateAndEditBook(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookForm(
                addBook: (book) => _editBook(index, book),
                initialBook: _books[index],
              )),
    );
  }

  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf'),
      ),
      body: _books.isEmpty
          ? Center(child: Text('No books yet'))
          : Column(children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(_books.length, (index) {
                    return GestureDetector(
                      onTap: () => _navigateAndEditBook(context, index),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(_books[index].title,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(_books[index].author),
                            Text(_books[index].genre),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                //   floatingActionButton: FloatingActionButton(
                //   onPressed: () => _navigateAndAddBook(context),
                //   tooltip: 'Add Book',
                //   child: Icon(Icons.add),
                // ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.book),
                      title: Text(_books[index].title),
                      subtitle: Text(_books[index].author),
                      trailing: Text(_books[index].genre),
                    );
                  },
                ),
              )
            ]),
    );
    floatingActionButton:
    FloatingActionButton(
      onPressed: () => _navigateAndAddBook(context),
      tooltip: 'Add Book',
      child: Icon(Icons.add),
    );
  }
}

class BookForm extends StatefulWidget {
  final Function addBook;
  final Book? initialBook;

  BookForm({required this.addBook, this.initialBook});

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _genre;

  @override
  void initState() {
    super.initState();
    if (widget.initialBook != null) {
      _title = widget.initialBook!.title;
      _author = widget.initialBook!.author;
      _genre = widget.initialBook!.genre;
    } else {
      _title = '';
      _author = '';
      _genre = 'Fiction';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialBook == null ? 'Add Book' : 'Edit Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(
                  labelText: 'Author',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
                onSaved: (value) => _author = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'genre',
                ),
                value: _genre,
                onChanged: (value) => setState(() => _genre = value!),
                items:
                    ['Fiction', 'Non-Fiction', 'Science Fiction', 'Biography']
                        .map((genre) => DropdownMenuItem<String>(
                              value: genre,
                              child: Text(genre),
                            ))
                        .toList(),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: ElevatedButton(
              //     // onPressed: _submitForm,
              //     child: Text('Save'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
