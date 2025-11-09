import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:link_up/config/theme/app_colors.dart';
import 'package:link_up/events/models/event.dart';
import 'package:link_up/events/providers/events_feed_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static const name = 'calendar';
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeMode = RangeSelectionMode.toggledOff;

  List<Event> _getEventsForDay(DateTime day, List<Event> events) {
    return events.where((e) => isSameDay(e.startAt, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsFeedProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Trip Dates',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading events\n$err',
            textAlign: TextAlign.center,
          ),
        ),
        data: (events) {
          final selectedDayEvents = _selectedDay == null
              ? <Event>[]
              : _getEventsForDay(_selectedDay!, events);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ---------- Calendario ----------
                      TableCalendar<Event>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                        ),
                        selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        rangeSelectionMode: _rangeMode,
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.coral),
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Color(0xFFFF9B17),
                            shape: BoxShape.circle,
                          ),
                          rangeStartDecoration: const BoxDecoration(
                            color: Color(0xFFFF9B17),
                            shape: BoxShape.circle,
                          ),
                          rangeEndDecoration: const BoxDecoration(
                            color: Color(0xFFFF9B17),
                            shape: BoxShape.circle,
                          ),
                          rangeHighlightColor:
                              const Color.fromARGB(255, 244, 114, 7),
                          outsideDaysVisible: true,
                        ),
                        // 👇 AQUÍ ES DONDE SE CONECTA CON TUS EVENTOS DEL BACKEND
                        eventLoader: (day) => _getEventsForDay(day, events),
                        onPageChanged: (f) => _focusedDay = f,
                        onDaySelected: (selected, focused) {
                          setState(() {
                            _selectedDay = selected;
                            _focusedDay = focused;
                            _rangeStart = null;
                            _rangeEnd = null;
                            _rangeMode = RangeSelectionMode.toggledOff;
                          });
                        },
                        onRangeSelected: (start, end, focused) {
                          setState(() {
                            _selectedDay = null;
                            _focusedDay = focused;
                            _rangeStart = start;
                            _rangeEnd = end;
                            _rangeMode = RangeSelectionMode.toggledOn;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      // ---------- Texto de selección ----------
                      Text(
                        _rangeStart != null && _rangeEnd != null
                            ? 'Rango: ${_rangeStart!.toString().split(" ").first} → ${_rangeEnd!.toString().split(" ").first}'
                            : _selectedDay != null
                                ? 'Día: ${_selectedDay!.toString().split(" ").first}'
                                : 'Select a date or date range',
                      ),

                      const SizedBox(height: 16),

                      // ---------- Eventos del día seleccionado ----------
                      const Text(
                        'Events for this day',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_selectedDay == null)
                        const Text(
                          'Select a day to see events.',
                          style: TextStyle(color: Colors.grey),
                        )
                      else if (selectedDayEvents.isEmpty)
                        const Text(
                          'No events for this day.',
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        ...selectedDayEvents.map(
                          (e) => Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                e.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(e.formattedDate),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // ---------- Guest Availability (mock, lo dejo igual) ----------
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Guest Availability',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Camila
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/camila.jpg'),
                          ),
                          title: Text(
                            'Camila',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Available',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Christian
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/CHRISTIAN.jpg'),
                          ),
                          title: Text(
                            'Christian',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Available',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Levi
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/noeslevi.jpg'),
                          ),
                          title: Text(
                            'Levi',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Available',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Cristina
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                        child: const ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/foto_cristi.jpg'),
                          ),
                          title: Text(
                            'Cristina',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Not Available',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ---------- Botón ----------
                      FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _rangeStart != null && _rangeEnd != null
                                    ? 'Guardado rango'
                                    : _selectedDay != null
                                        ? 'Se registró exitosamente la fecha'
                                        : 'Ya casi terminas! primero elige una fecha',
                              ),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
