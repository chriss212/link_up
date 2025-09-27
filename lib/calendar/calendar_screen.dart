import 'package:flutter/material.dart';
import 'package:link_up/config/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const name = 'calendar';
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeMode = RangeSelectionMode.toggledOff;

  @override
  Widget build(BuildContext context) {
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

      
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  
                  // ---------- Calendario ----------
                  TableCalendar(
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
                      rangeHighlightColor: const Color.fromARGB(255, 244, 114, 7),
                      outsideDaysVisible: true,
                    ),
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
                            : 'Selecciona un día o un rango',
                  ),

                  const SizedBox(height: 16),

                  // PERSONAS DISPONIBLES MOCKS CARDS
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Guest Availability',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Camila
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        
                        backgroundImage: AssetImage('assets/images/CM MUN FOTO .jpg'),
                      ),
                      title: Text('Camila', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Available', style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Christian
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/images/CHRISTIAN.jpeg'),
                      ),
                      title: Text('Christian', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Available', style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Levi
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(''),
                      ),
                      title: Text('Levi', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Available', style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Cristina
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(''),
                      ),
                      title: Text('Cristina', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Not Available', style: TextStyle(color: Colors.red)),
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
                                    ? 'Se registro exitosamente la fecha'
                                    : 'Ya casi terminas! primero elige una fecha',
                          ),
                        ),
                      );
                    },
                    child: const Text('Listo'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
