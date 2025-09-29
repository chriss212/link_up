import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/feed/event_feed_screen.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  static const String name = 'new-event';

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  String? selectedCategory;
  bool isCreating = false;

  Future<void> _createEvent() async {
    setState(() => isCreating = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text("Event created successfully"),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        context.goNamed(EventFeedScreen.name);
      }
    }
  }

  Widget _buildTextField({
    required String label, 
    String? hint,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null 
                ? Icon(icon, color: Colors.grey.shade400, size: 20) 
                : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(
                color: Colors.grey.shade400, 
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              hintText: "Select event type",
              prefixIcon: Icon(Icons.tag, color: Colors.grey.shade400, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
            items: const [
              DropdownMenuItem(
                value: "chill", 
                child: Text("Chill", style: TextStyle(fontSize: 15)),
              ),
              DropdownMenuItem(
                value: "party", 
                child: Text("Party", style: TextStyle(fontSize: 15)),
              ),
              DropdownMenuItem(
                value: "work", 
                child: Text("Work", style: TextStyle(fontSize: 15)),
              ),
            ],
            onChanged: (val) => setState(() => selectedCategory = val),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Create Event",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: Colors.grey.shade600,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: "Event Name",
                hint: "Beach bonfire, movie night...",
                icon: Icons.event_outlined,
              ),
              
              const SizedBox(height: 24),
              
              _buildTextField(
                label: "Location",
                hint: "Where will this happen?",
                icon: Icons.location_on_outlined,
              ),
              
              const SizedBox(height: 24),
              
              _buildDropdown(),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "MM/DD/YYYY",
                              prefixIcon: Icon(
                                Icons.calendar_today_outlined, 
                                color: Colors.grey.shade400, 
                                size: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(16),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400, 
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "7:00 PM",
                              prefixIcon: Icon(
                                Icons.access_time_outlined, 
                                color: Colors.grey.shade400, 
                                size: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(16),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400, 
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              _buildTextField(
                label: "Description",
                hint: "What should people expect?",
                maxLines: 4,
                icon: Icons.notes_outlined,
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isCreating ? null : _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                  child: isCreating 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}