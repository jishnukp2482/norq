import 'package:hive/hive.dart';

class HiveService {
  Future<Box<T>> getBox<T>({required String boxName}) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    } else {
      return await Hive.openBox<T>(boxName);
    }
  }

  isExists({required String boxName}) async {
    final openBox = await getBox(boxName: boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await getBox<T>(boxName: boxName);
    final existingItems = openBox.values.toList();

    for (var item in items) {
      if (existingItems.contains(item)) {
        // prettyPrint(msg: "item exits $item");
        existingItems.asMap().forEach((key, value) {
          if (value == item) {
            openBox.putAt(key, item);
          }
        });
      } else {
        // prettyPrint(msg: "item added $item");
        openBox.add(item);
      }
    }
  }

  clearAllValues<T>(String boxName) async {
    final openBox = await getBox<T>(boxName: boxName);
    await openBox.clear();
  }

  getBoxes<T>(String boxName) async {
    List<T> boxList = <T>[];

    final openBox = await getBox<T>(boxName: boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i) as T);
    }

    return boxList;
  }

  deleteBoxes<T>(String boxName, {required int index}) async {
    final openBox = await getBox<T>(boxName: boxName);
    openBox.deleteAt(index);
  }
}
