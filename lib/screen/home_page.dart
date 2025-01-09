import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/model/item_model.dart';
import 'package:mutabaah_yaumiyah/provider/local_database_provider.dart';
import 'package:mutabaah_yaumiyah/screen/form_screen.dart';
import 'package:mutabaah_yaumiyah/static/action_page_enum.dart';
import 'package:mutabaah_yaumiyah/widget/item_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllItemValue();
    });
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
            children: [
              ItemWidget(
                item: Item(
                    item_name: "Tilawah",
                    description: "Mengaji",
                    inserted_at: DateTime.now().toString(),
                    updated_at: DateTime.now().toString(),
                    status: "Sudah",
                    is_deleted: false),
              ),
              Consumer<LocalDatabaseProvider>(builder: (context, value, child) {
                if (value.itemList == null) {
                  return const SizedBox();
                }
                final itemList = value.itemList!;
                return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      final item = itemList[index];
                      return ItemWidget(
                        item: item,
                        onTapRemove: () async {
                          if (item.id != null) {
                            final localDatabaseProvider =
                                context.read<LocalDatabaseProvider>();
                            await localDatabaseProvider
                                .deleteValueById(item.id!);
                            await localDatabaseProvider.loadAllItemValue();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("This item cannot be deleted")),
                            );
                          }
                        },
                        onTapEdit: () {
                          if (item.id != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormScreen(
                                          actionPageEnum: ActionPageEnum.edit,
                                          item: item,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("This item cannot be Edited")));
                          }
                        },
                      );
                    });
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FormScreen(
                        actionPageEnum: ActionPageEnum.add,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
