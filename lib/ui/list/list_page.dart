import 'package:firstband/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Item {
  final String filePath;
  final String name;
  final String imagePath;

  Item(this.filePath, this.name, this.imagePath);
}

class ListPageController extends GetxController {
  final list = [
    Item(
        'assets/darthvador.json', 'Imperial March', 'assets/first-item@3x.png'),
    Item(
        'assets/dancemonkey.json', 'Dance Monkey', 'assets/second-item@3x.png'),
    Item(
      'assets/alliwant.json',
      'All I Want For Christmase is you',
      'assets/list-item@3x.png',
    ),
  ];
}

class ListPage extends GetView<ListPageController> {
  static const name = '/list';
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: const Color.fromARGB(0xFF, 0xA1, 0xBF, 0x3B),
        title: const Text(
          'Your Musics',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(0xFF, 0xA1, 0xBF, 0x3B),
          ),
        ),
        backgroundColor: const Color.fromARGB(0xFF, 0x2A, 0x2A, 0x2A),
      ),
      body: Container(
        color: const Color.fromARGB(0xFF, 0x2A, 0x2A, 0x2A),
        child: ListView.builder(
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            final item = controller.list[index];
            final image = Image.asset(
              item.imagePath,
              fit: BoxFit.fitWidth,
            );
            return GestureDetector(
              onTap: () {
                Get.toNamed(MainPage.name, arguments: item.filePath);
              },
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: index == 0
                      ? const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8.0,
                          top: 24,
                        )
                      : const EdgeInsets.all(8.0),
                  child: image,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
