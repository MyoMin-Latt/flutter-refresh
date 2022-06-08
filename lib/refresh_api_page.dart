import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RefreshApiPage extends StatefulWidget {
  const RefreshApiPage({Key? key}) : super(key: key);

  @override
  State<RefreshApiPage> createState() => _RefreshApiPageState();
}

class _RefreshApiPageState extends State<RefreshApiPage> {
  final controller = ScrollController();
  List<String> items = [];
  final limit = 25;
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    // print(
    //     'controller.position.maxScrollExtent == controller.offset => ${controller.position.maxScrollExtent} / ${controller.offset}');
    if (isLoading) return;
    isLoading = true;
    final url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List newItems = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        page++;
        items.addAll(newItems.map((item) => 'Item ${item['id']}').toList());
        if (newItems.length < limit) {
          hasMore = false;
        }
      });
    }
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
              itemCount: items.length + 1, // 25 + 1
              itemBuilder: (c, i) {
                if (i < items.length) {
                  return Card(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Text(items[i]),
                    ),
                  );
                } else {
                  // print('i < items.length => $i < ${items.length}');
                  return Center(
                    child: hasMore
                        ? const CircularProgressIndicator()
                        : const Text('No More Data'),
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

// print() in listview
// controller.offset = controller.position.pixels