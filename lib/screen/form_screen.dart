import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/model/item_model.dart';
import 'package:mutabaah_yaumiyah/provider/local_database_provider.dart';
import 'package:mutabaah_yaumiyah/static/action_page_enum.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  final ActionPageEnum actionPageEnum;
  final Item? item;
  const FormScreen({super.key, required this.actionPageEnum, this.item});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late final TextEditingController _itemNameController =
      TextEditingController();
  late final TextEditingController _itemDescriptionController =
      TextEditingController();
  late final TextEditingController _itemStatusController =
      TextEditingController();
  bool _is_deleted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool isChecked = false;
    if (widget.actionPageEnum.isEdit) {
      _itemNameController.text = widget.item?.item_name ?? "";
      _itemDescriptionController.text = widget.item?.description ?? "";
      _itemStatusController.text = widget.item?.status ?? "";

      setState(() {
        _is_deleted = widget.item?.is_deleted ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Mutaba'ah Yaumiyah",
          style: TextStyle(fontWeight: FontWeight.w900),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _itemNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: "Input Item Name",
                    label: Text("Item Name"),
                    border: OutlineInputBorder()),
              ),
              const SizedBox.square(dimension: 16),
              TextField(
                controller: _itemDescriptionController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: "Input Description",
                    label: Text("Description"),
                    border: OutlineInputBorder()),
              ),
              const SizedBox.square(dimension: 16),
              TextField(
                controller: _itemStatusController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: "Apakah tugas sudah dilaksanakan",
                    label: Text("Status"),
                    border: OutlineInputBorder()),
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              FilledButton.icon(
                icon: Icon(
                    widget.actionPageEnum.isEdit ? Icons.edit : Icons.save),
                label: Text(widget.actionPageEnum.isEdit ? "Edit" : "Save"),
                onPressed: () async {
                  final localDatabaseProvider =
                      context.read<LocalDatabaseProvider>();
                  final item = Item(
                      description: _itemDescriptionController.text,
                      item_name: _itemNameController.text,
                      status: _itemStatusController.text,
                      inserted_at: DateTime.now().toString(),
                      updated_at: widget.actionPageEnum.isEdit
                          ? DateTime.now().toString()
                          : "",
                      is_deleted: false);
                  if (widget.actionPageEnum.isEdit) {
                    await localDatabaseProvider.updateItemById(
                        widget.item!.id!, item);
                  } else {
                    await localDatabaseProvider.saveItemValue(item);
                  }
                  await localDatabaseProvider.loadAllItemValue();

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
