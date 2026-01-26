import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_colors.dart';
import 'list_detail_screen.dart';
import '../../models/list_model.dart' as model;
import '../../widgets/app_drawer.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listy'),
        leading: Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : null,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'lists'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddListDialog(context),
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.darkNavy,
        icon: const Icon(Icons.add),
        label: const Text('Nowa Lista'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          if (!dataProvider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final lists = dataProvider.standaloneLists;

          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list,
                    size: 80,
                    color: AppColors.mediumGray,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Brak list',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stwórz swoją pierwszą listę!',
                    style: TextStyle(
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return _ListCard(list: list);
            },
          );
        },
      ),
    );
  }

  void _showAddListDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ListDetailScreen(),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final model.ListModel list;

  const _ListCard({required this.list});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ListDetailScreen(list: list),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.listsBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.list,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      list.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (list.items.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...list.items.take(3).map((item) => _ChecklistItemWidget(
                      item: item,
                      onChanged: (value) {
                        // This updates the local UI optimistically
                        // In a real app with Hive, modifying the object directly
                        // and calling save() or notifying listener is needed.
                        // Since we are using HiveObject, `item.save()` might not work
                        // if it's not a standalone Hive object but part of a list.
                        // The DataProvider should handle the update.
                        
                        item.isCompleted = value ?? false;
                        Provider.of<DataProvider>(context, listen: false)
                            .updateList(list);
                      },
                    )),
                if (list.items.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+${list.items.length - 3} więcej',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistItemWidget extends StatelessWidget {
  final model.ChecklistItem item;
  final ValueChanged<bool?> onChanged;

  const _ChecklistItemWidget({
    required this.item,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: item.isCompleted,
              onChanged: onChanged,
              activeColor: AppColors.success,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: item.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: item.isCompleted ? AppColors.darkGray : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
