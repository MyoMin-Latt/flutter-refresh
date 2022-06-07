import 'package:flutter/material.dart';

class RefreshApiPage extends StatefulWidget {
  const RefreshApiPage({Key? key}) : super(key: key);

  @override
  State<RefreshApiPage> createState() => _RefreshApiPageState();
}

class _RefreshApiPageState extends State<RefreshApiPage> {
  final controller = ScrollController();
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      items.addAll(['A', 'B', 'C', 'D', 'E']);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pull To Refresh'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  items = items.sublist(0, 7);
                });
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Column(
        children: [
          const Text(
            'Data',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 26),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemExtent: 100.0,
              itemCount: items.length + 1,
              itemBuilder: (c, i) {
                if (i < items.length) {
                  // print('i < items.length => $i < ${items.length}');
                  return Card(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text(items[i]),
                    ),
                  );
                } else {
                  // print('i < items.length => $i < ${items.length}');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // from 1.5.0, it is not necessary to add this line
  //@override
  // void dispose() {
  //  _refreshController.dispose();
  //  super.dispose();
  // }
}
