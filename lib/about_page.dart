import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    // this sets the orientation of the route.
    // preferred orientation should be set for each route.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildBrandArea(context),
                const SizedBox(height: 40.0),
                _buildInfoArea(context),
                const SizedBox(height: 40.0),
                _buildFeedbackArea(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWriteDialogue(context),
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }

  // Build ...

  Widget _buildBrandArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'logo.png',
            height: 70,
          ),
          Text(
            'Moverviews',
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
  }

  Widget _buildInfoArea(BuildContext context) {
    return LayoutBuilder(

      builder: (BuildContext context, BoxConstraints constraints) {
        // the textStyle for some text is decided based on the width of the
        // column. I don't know why the conditional expression returns a
        // nullable type but I banged it anyway.
        TextStyle textStyle =
        ((constraints.biggest.width < 224.0) ?
            Theme.of(context).textTheme.caption :
            Theme.of(context).textTheme.bodyMedium)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'by Sami.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                const Icon(Icons.web),
                const SizedBox(
                  width: 4.0,
                ),
                Text('samibre.com', style: textStyle,)
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              children: <Widget>[
                const Icon(Icons.telegram),
                const SizedBox(
                  width: 4.0,
                ),
                Text('@sami_bre', style: textStyle,)
              ],
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              children: <Widget>[
                const Icon(Icons.email),
                const SizedBox(
                  width: 4.0,
                ),
                Text('samuelbirhanu121@gmail.com', style: textStyle,)
              ],
            ),
            const SizedBox(
              height: 4.0,
            ),
            const Text(
              'Shout-out to themoviedb API.',
              textScaleFactor: 1.2,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              'Illustration by Olga \nNesnova from Ouch!.',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        );
      },

    );
  }

  Widget _buildFeedbackArea(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'What do you think about this app? '
        'Are there any bugs you saw? '
        'You see something to improve or add? '
        'Then write to me.',
        textScaleFactor: 1.2,
      ),
    );
  }

  // Actions ...

  void _showWriteDialogue(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    String? message = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Write to me.'),
            content: TextField(
              controller: controller,
              maxLines: 2,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // if cancelled, we pop without sending a result
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // if send is pressed, we pop, sending the text in the TextEditor
                  Navigator.pop(context, controller.text);
                },
                child: const Text('Send'),
              )
            ],
          );
        });
    // everything after this line is a callback for the Future<String>.
    // check if the message exists and if it's non empty. then send it via email.
    if (message != null && message != '') {
      _sendEmail(message);
    }
  }

  void _sendEmail(String messageText) async {
    DateTime dateTime = DateTime.now();
    String username = 'moverviewapp@gmail.com';
    String password = 'efymhzcprymvtsok';
    /*I'm doing a deprecated thing here. the gmail() method will be removed from
    mailer package soon (according to the documentation). It's just that I'm lazy
    to discover alternatives. Nevertheless, I will have to change this if the app
    is gonna be anything serious.*/
    // if what you're seeing below confuses you, head to the documentation of
    // the mailer package.
    SmtpServer smtpServer = gmail(username, password);
    Message message = Message();
    message.from = Address(username, 'A moverviews app user');
    // I receive all emails in my personal email address.
    message.recipients.add('samuelbirhanu121@gmail.com');
    message.subject = 'A moverviews app user wants to tell you something. '
        'Date: ${dateTime.year}-${dateTime.month}-${dateTime.day}';
    message.text = 'The user said: \n$messageText';
    // get the scaffoldMessenger
    final ScaffoldMessengerState scaffoldMessenger = scaffoldKey.currentState!;
    try {
      await send(message, smtpServer);
      // show a snackBar telling message is sent successfully
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Message sent.',
              textScaleFactor: 1.1, textAlign: TextAlign.center),
        ),
        backgroundColor: Colors.blue,
      ));
    } on Exception {
      // show a snackBar telling the message was not sent due to network problems.
      scaffoldMessenger.showSnackBar(SnackBar(
        content: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Message not sent. Network problems.',
              textScaleFactor: 1.1, textAlign: TextAlign.center),
        ),
        backgroundColor: Colors.red[300],
      ));
    }
  }
}
