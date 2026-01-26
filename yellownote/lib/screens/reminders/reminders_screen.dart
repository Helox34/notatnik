import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_colors.dart';
import '../../models/reminder.dart';
import '../../widgets/app_drawer.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _showAddReminderDialog(BuildContext context, DateTime selectedDate) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nowe Przypomnienie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tytuł',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Opis (opcjonalnie)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Godzina'),
                  trailing: Text(selectedTime.format(context)),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;
                
                final dateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final reminder = Reminder(
                  title: titleController.text,
                  description: descriptionController.text,
                  dateTime: dateTime,
                );

                context.read<DataProvider>().addReminder(reminder);
                Navigator.pop(context);
              },
              child: const Text('Dodaj'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dataProvider = Provider.of<DataProvider>(context);
    final selectedDayReminders = _selectedDay != null
        ? dataProvider.getRemindersByDate(_selectedDay!)
        : <Reminder>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Przypomnienia'),
        elevation: 0,
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
      drawer: const AppDrawer(currentRoute: 'reminders'),
      body: Column(
        children: [
          // Calendar
          TableCalendar(
            locale: 'pl_PL',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => dataProvider.getRemindersByDate(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: AppColors.darkNavy,
                fontWeight: FontWeight.bold,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.yellow.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: isDark ? Colors.white : AppColors.darkNavy,
                fontWeight: FontWeight.bold,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.darkNavy,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Reminders list for selected day
          Expanded(
            child: selectedDayReminders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 64,
                          color: isDark ? Colors.grey[600] : AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Brak przypomnień na ten dzień',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : AppColors.darkGray,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedDayReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = selectedDayReminders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Checkbox(
                            value: reminder.isCompleted,
                            onChanged: (value) {
                              final updated = reminder.copyWith(
                                isCompleted: value ?? false,
                              );
                              dataProvider.updateReminder(updated);
                            },
                            activeColor: AppColors.yellow,
                            checkColor: AppColors.darkNavy,
                          ),
                          title: Text(
                            reminder.title,
                            style: TextStyle(
                              decoration: reminder.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (reminder.description.isNotEmpty)
                                Text(reminder.description),
                              const SizedBox(height: 4),
                              Text(
                                '${reminder.dateTime.hour.toString().padLeft(2, '0')}:${reminder.dateTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : AppColors.darkGray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Usuń przypomnienie'),
                                  content: const Text(
                                      'Czy na pewno chcesz usunąć to przypomnienie?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Anuluj'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Usuń'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                dataProvider.deleteReminder(reminder.id);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.yellow,
        onPressed: () {
          _showAddReminderDialog(context, _selectedDay ?? DateTime.now());
        },
        child: const Icon(Icons.add, color: AppColors.darkNavy),
      ),
    );
  }
}
