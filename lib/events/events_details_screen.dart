import 'package:flutter/material.dart';
import 'widgets/colaborative_date_selector.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  // 👇 Nombre para GoRouter
  static const String name = 'event-details';

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Info"),
            Tab(text: "Invitados"),
            Tab(text: "Encuestas"),
            Tab(text: "Chat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildGuestsTab(),
          _buildSurveysTab(),
          _buildChatTab(),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Weekend Getaway",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Date: July 15, 2024"),
          Text("Time: 10:00 AM - 6:00 PM"),
          Text("Location: Mountain View Trail"),
          SizedBox(height: 16),
          CollaborativeDateSelector(),
        ],
      ),
    );
  }

  Widget _buildGuestsTab() {
    return const Center(child: Text("Lista de invitados (mock)"));
  }

  Widget _buildSurveysTab() {
    return const Center(child: Text("Encuestas y resultados"));
  }

  Widget _buildChatTab() {
    return const Center(child: Text("Chat del evento"));
  }
}
