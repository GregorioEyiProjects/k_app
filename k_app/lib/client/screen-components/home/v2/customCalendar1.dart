import 'package:calendar_viewer/calendar_viewer.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';

//import 'package:calendar_view/calendar_view.dart';
class CustomCalendar1 extends StatefulWidget {
  const CustomCalendar1({super.key});

  @override
  State<CustomCalendar1> createState() => _CustomcalendarState();
}

class _CustomcalendarState extends State<CustomCalendar1> {
  final DateTime initialDate = DateTime.now();
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  final Map<DateTime, List<String>> events = {
    DateTime(2025, 2, 21): ['Event 1'],
  };

  void _showAddEventDialog(DateTime selectedDate) {
    final TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        print('Selected date: $selectedDate');
        return AlertDialog(
          title: Text('Add Event on ${selectedDate.toLocal()}'),
          content: TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: 'Enter event name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final eventList = events[selectedDate] ?? [];
                  eventList.add(eventController.text);
                  events[selectedDate] = eventList;
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /*CalendarViewer(
        initialDate: initialDate, months: months, weekdays: weekdays); */
  @override
  Widget build(BuildContext context) {
    return CleanCalendar(
      enableDenseSplashForDates: true,
      calendarDatesSectionMaxHeight: 250,
      datePickerCalendarView: DatePickerCalendarView.monthView,
      selectedDates: events.keys.toList(),
      selectedDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
            datesBorderColor: Colors.pinkAccent,
            datesBackgroundColor: Colors.pinkAccent),
      ),
      headerProperties: HeaderProperties(
        navigatorDecoration: NavigatorDecoration(
          navigatorResetButtonIcon: const Icon(
            Icons.restart_alt,
            color: Colors.pinkAccent,
          ),
          navigateLeftButtonIcon: const Icon(
            Icons.arrow_circle_left,
            color: Colors.pinkAccent,
          ),
          navigateRightButtonIcon: const Icon(
            Icons.arrow_circle_right,
            color: Colors.pinkAccent,
          ),
        ),
      ),
      onSelectedDates: (List<DateTime> value) {
        print('Selected dates: $value');
        final selectedDate = value.isNotEmpty ? value.first : null;

        if (selectedDate != null) {
          _showAddEventDialog(selectedDate);
        }
      },
    );
  }
}
