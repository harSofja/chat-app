import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Σχετικά με την εφαρμογή',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Image.asset('assets/images/chat_logo.png', height: 120),
              const SizedBox(height: 24),
              Text(
                'Καλώς ήρθατε στο Chats - μια απλή εφαρμογή ανταλλαγής μηνυμάτων.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                ' Στην εφαρμογή χρησιμοποιήθηκε το Firebase για την αποθήκευση και διαχείριση δεδομένων σε πραγματικό χρόνο. Οι χρήστες μπορούν να δημιουργήσουν λογαριασμό, να στείλουν περιορισμένο αριθμό μηνυμάτων (max 30), μπορείτε επίσης να ανεβάσετε δική σας φωτογραφία προφίλ από τη συσκευή σας, να αλλάξετε κωδικό και username. Τέλος, μπορείτε να αποσυνδεθείτε και να διαγράψετε το λογαριασμό σας μόνιμα. ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Για το front-end χρησιμοποιήθηκε Flutter και Dart.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Ένα ειδικό ευχαριστώ στον υπεύθυνο του προγράμματος κ. Αθανάσιο Ανδορούτσο καθώς και τους καθηγητές του Coding Facory που μας υποστήριξαν καθ\' όλη τη διάρκεια αυτού του ταξιδιού.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              Text(
                '“Ο καλύτερος τρόπος να προβλέψεις το μέλλον είναι να το εφεύρεις.”\n– Alan Kay',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/chat_icon.png', height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
