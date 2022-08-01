import 'package:flutter/material.dart';

import '../database/data_form.dart';
import '../database/db_crud.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  BuildContext? _context;

  String title = '';
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: updateDB,
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: loadBuilder()
        ));
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.data == null || snapshot.data == []) {
          return const Text("데이터를 불러올 수 없습니다.");
        } else {
          Memo memo = snapshot.data![0];
          title = memo.title;
          var tecTitle = TextEditingController();
          tecTitle.text = memo.title;

          text = memo.text;
          var tecText = TextEditingController();
          tecText.text = memo.text;

          createTime = memo.createTime;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: tecTitle,
                maxLines: 2,
                onChanged: (String title) {
                  this.title = title;
                },
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                //obscureText: true,
                decoration: const InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 제목을 적어주세요.',
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                controller: tecText,
                maxLines: 8,
                onChanged: (String text) {
                  this.text = text;
                },
                //obscureText: true,
                decoration: const InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 내용을 적어주세요.',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void updateDB() {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: widget.id,
      title: title,
      text: text,
      createTime: createTime,
      editTime: DateTime.now().toString(),
    );

    sd.updateMemo(fido);
    Navigator.pop(_context!);
  }

}