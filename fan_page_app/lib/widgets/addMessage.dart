import 'package:fan_page_app/services/database.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.messageController,
    required this.databaseService,
  }) : super(key: key);

  final TextEditingController messageController;
  final DatabaseServices databaseService;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Add new message'),
                  content: TextField(
                    style: TextStyle(fontSize: 17),
                    controller: messageController,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Message...',
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        )),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, ''),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, messageController.text),
                      child: const Text('Send'),
                    ),
                  ],
                )).then((value) {
          if (value != "") {
            databaseService.sendMessagetoFirestore(messageController.text);
          }
          messageController.text = "";
        });
      },
    );
  }
}
