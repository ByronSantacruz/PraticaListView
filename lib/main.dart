import 'package:flutter/material.dart';
import 'email.dart';
import 'backend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListViewDemoPage(),
    );
  }
}

class ListViewDemoPage extends StatefulWidget {
  ListViewDemoPage({Key? key}) : super(key: key);

  @override
  _ListViewDemoPageState createState() => _ListViewDemoPageState();
}

class _ListViewDemoPageState extends State<ListViewDemoPage> {
  final List<Email> emails = Backend().getEmails();

  void markAsRead(Email email) {
    setState(() {
      email.read = true;
    });
  }

  void deleteEmail(Email email) {
    setState(() {
      Backend().deleteEmail(email.id);
      emails.remove(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock mail'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          final email = emails[index];
          return Dismissible(
            key: Key(email.id.toString()),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                deleteEmail(email);
              }
            },
            child: ListTile(
              leading: Visibility(
                visible: !email.read,
                child: CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: 6,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${email.dateTime.year}-${email.dateTime.month}-${email.dateTime.day}',
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  Text(
                    email.from,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // Cambiar el color del texto "From"
                    ),
                  ),
                  Text(
                    email.subject,
                    style: TextStyle(
                        color: Colors
                            .black), // Cambiar el color del texto "Subject"
                  ),
                  Divider(),
                ],
              ),
              onTap: () {
                setState(() {
                  Backend().markEmailAsRead(emails[index].id);
                  emails[index].read = true;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(email: emails[index]),
                  ),
                );
              },
              onLongPress: () {
                setState(() {
                  Backend().markEmailAsRead(emails[index].id);
                  emails[index].read = true;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Email email;

  DetailScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Functional programming'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'From: ${email.from}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          Text(email.subject),
          Text(email.dateTime.toString()),
          Divider(),
          Text(email.body),
        ],
      ),
    );
  }
}
