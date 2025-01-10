import 'package:flutter/material.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen =
              constraints.maxWidth >= 700; // Deteksi layar lebar

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<LocalDatabaseProvider>(
                builder: (context, value, child) {
                  if (value.itemList == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final itemList = value.itemList!;
                  if (itemList.isEmpty) {
                    return const Center(
                      child: Text("No items available"),
                    );
                  }

                  // GridView untuk 2 kolom pada layar lebar, 1 kolom pada layar kecil
                  return GridView.builder(
                    primary: false,
                    shrinkWrap:
                        true, // Untuk menyesuaikan tinggi di dalam SingleChildScrollView
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          isWideScreen ? 2 : 1, // Dua kolom untuk layar lebar
                      mainAxisSpacing: 16, // Jarak antar baris
                      crossAxisSpacing: 16, // Jarak antar kolom
                      childAspectRatio: 3, // Rasio lebar : tinggi untuk item
                    ),
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
                                content: Text("This item cannot be deleted"),
                              ),
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
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("This item cannot be Edited"),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormScreen(
                actionPageEnum: ActionPageEnum.add,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
