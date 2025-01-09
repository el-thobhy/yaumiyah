import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/model/item_model.dart';
import 'package:mutabaah_yaumiyah/widget/item_row_widget.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final Function? onTapEdit;
  final Function? onTapRemove;

  const ItemWidget(
      {super.key, required this.item, this.onTapEdit, this.onTapRemove});

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleMedium;
    final borderRadius = BorderRadius.circular(10);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: InkWell(
        onTap: () {},
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.item_name,
                      style:
                          titleTextStyle?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox.square(dimension: 4),
                    ItemRowWidget(
                      title: "Description",
                      subtitle: item.description,
                    ),
                    const SizedBox.square(dimension: 4),
                    ItemRowWidget(
                      title: "Status",
                      subtitle: "${item.status}",
                    ),
                    const SizedBox.square(dimension: 4),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: onTapEdit != null ? () => onTapEdit!() : null,
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed:
                        onTapRemove != null ? () => onTapRemove!() : null,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
