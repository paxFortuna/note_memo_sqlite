import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_memo_sqlite/screens/view_page.dart';
import 'package:note_memo_sqlite/screens/write_page.dart';

import '../database/data_form.dart';
import '../database/db_crud.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deleteid = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40, bottom: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text('메모메모',
                  style: TextStyle(fontSize: 36, color: Colors.blue)),
            ),
          ),
          Expanded(child: memoBuilder(context))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => WritePage()));
        },
        tooltip: '메모를 추가하려면 클릭하세요',
        label: const Text('메모 추가'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 경고'),
          content: const Text("정말 삭제하시겠습니까?\n삭제된 메모는 복구되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: const Text('삭제'),
              onPressed: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  deleteMemo(deleteid);
                });
                deleteid = '';
              },
            ),
            ElevatedButton(
              child: const Text('취소'),
              onPressed: () {
                deleteid = '';
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }

  Widget memoBuilder(BuildContext parentContext) {
    return FutureBuilder<List<Memo>>(
      builder: (context, Snap) {
        if (Snap.hasData == null) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '지금 바로 "메모 추가" 버튼을 눌러\n 새 메모를 추가해보세요!\n\n\n\n\n\n\n\n',
              style: TextStyle(fontSize: 15, color: Colors.blueAccent),
              textAlign: TextAlign.center,),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: Snap.data?.length,
          itemBuilder: (context, index) {
            Memo memo = Snap.data![index];
            return InkWell(
              onTap: (){
                Navigator.push(
                    parentContext, CupertinoPageRoute(
                    builder: (parentContext) => ViewPage(id: memo.id)));
              },
              onLongPress: (){
                deleteid = memo.id;
                showAlertDialog(parentContext);
              },
              child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    boxShadow: const [BoxShadow(color: Colors.blue,blurRadius: 3)],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(memo.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,),
                          Text(
                            memo.text,
                            style: const TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("최종 수정 시간: ${memo.editTime.split('.')[0]}",
                              style: const TextStyle(fontSize: 11),
                              textAlign: TextAlign.end),
                        ],
                      ),
                    ],
                  )),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}