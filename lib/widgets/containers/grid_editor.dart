import 'dart:math';

import 'package:dnd/models/game_object.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridEditor<T extends GameObject> extends StatelessWidget {
  const GridEditor({
    Key key,
    @required this.title,
    @required this.items,
    @required this.loadItems,
    @required this.goToItemEditor,
    @required this.deleteItem,
    @required this.controllerStatus,
    @required this.goToItem,
  }) : super(key: key);

  final List<T> items;
  final RxStatus controllerStatus;
  final VoidCallback loadItems;
  final void Function(T) goToItemEditor;
  final Future<void> Function(String) deleteItem;
  final void Function(T) goToItem;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToItemEditor(null),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controllerStatus == RxStatus.loading() && items.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (controllerStatus == RxStatus.empty()) {
      return NoItemsWidget(goToItemEditor: goToItemEditor);
    }

    if (controllerStatus == RxStatus.error()) {
      return ErrorStateWidget(loadItems: loadItems);
    }

    return Scrollbar(
      child: GridView.count(
        padding: const EdgeInsets.all(24.0),
        crossAxisCount: min(context.width ~/ 250, 4),
        mainAxisSpacing: 16,
        crossAxisSpacing: 24,
        childAspectRatio: 1.5,
        children: [
          for (final item in items)
            ItemWidget(
              item: item,
              loadItems: loadItems,
              deleteItem: deleteItem,
              goToItemEditor: goToItemEditor,
              goToItem: goToItem,
            ),
        ],
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({Key key, @required this.loadItems}) : super(key: key);

  final VoidCallback loadItems;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Не удалось загрузить объекты'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loadItems,
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }
}

class NoItemsWidget<T> extends StatelessWidget {
  const NoItemsWidget({Key key, @required this.goToItemEditor})
      : super(key: key);

  final void Function(T) goToItemEditor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Нет объектов'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => goToItemEditor(null),
            child: Text('Создать'),
          ),
        ],
      ),
    );
  }
}

class ItemWidget<T extends GameObject> extends StatelessWidget {
  const ItemWidget({
    Key key,
    @required this.item,
    @required this.deleteItem,
    @required this.goToItemEditor,
    @required this.loadItems,
    @required this.goToItem,
  }) : super(key: key);

  final T item;
  final void Function(T) goToItemEditor;
  final Future<void> Function(String) deleteItem;
  final VoidCallback loadItems;
  final void Function(T) goToItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToItem(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffcccccc),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(item.imageUrl),
                ),
              ),
              Container(
                constraints: BoxConstraints.expand(),
                color: Colors.grey.withAlpha(80),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => goToItemEditor(item),
                  child: Container(
                    height: 32,
                    width: 32,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => Get.dialog(
                    AlertDialog(
                      title: Text('Точно хочешь удалить?'),
                      actions: [
                        TextButton(onPressed: Get.back, child: Text('Отмена')),
                        TextButton(
                          onPressed: () async {
                            await deleteItem(item.id);

                            loadItems();
                            Get.back();
                          },
                          child: Text(
                            'Удалить',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  child: Container(
                    height: 32,
                    width: 32,
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  item.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
