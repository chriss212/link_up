import 'package:flutter/material.dart';
import 'package:link_up/config/theme/app_colors.dart';

class SmartPlannerScreen extends StatefulWidget {
  static const name = 'smart_planner';
  const SmartPlannerScreen({super.key});

  @override
  State<SmartPlannerScreen> createState() => _SmartPlannerScreenState();
}

class _SmartPlannerScreenState extends State<SmartPlannerScreen> {
  final _messages = <_Msg>[
    _Msg(role: Role.assistant, text: 'Hello there, I am your Smart Planner. Tell me about your upcoming plans 👇'),
    _Msg(role: Role.assistant, text: 'For example, "Beach day for 8 people, budget \$40 each" or "City break 2 days, 3 people, budget \$70 p/p"'),
  ];
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _sending = true;
      _messages.add(_Msg(role: Role.user, text: text));
      _controller.clear();
    });
    _scrollToBottom();

    // --- MOCK de respuesta del “asistente” ---
    await Future.delayed(const Duration(milliseconds: 600));
    final reply = _mockPlannerReply(text);

    setState(() {
      _messages.add(_Msg(role: Role.assistant, text: reply));
      // Add the "Add trip to your feed" message with a button
      _messages.add(_Msg(role: Role.action, text: 'add_trip'));
      _sending = false;
    });
    _scrollToBottom();
  }

  String _mockPlannerReply(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('disneyland')) {
      return """
Awesome! 🎢

Quick draft:
Plan: Disneyland trip
• Location: Disneyland Park, Anaheim, CA
• Date: Saturday, August 10
• Time: 9:00 AM - 10:00 PM
• Participants: 4 people
• Budget: \$250 per person

Activities:
• Park admission and rides
• Character meet & greet
• Lunch at a themed restaurant
• Parade and fireworks

Budget breakdown:
• Park tickets: \$150 p/p (\$600 total)
• Meals/snacks: \$40 p/p (\$160 total)
• Souvenirs: \$30 p/p (\$120 total)
• Parking/transport: \$20 p/p (\$80 total)

Estimated total: \$960 (\$240 per person)
Let me know if you want to adjust the date or add more activities!
""";
    } else if (lower.contains('city break')) {
      return """
Great choice! 🏙️

Quick draft:
Plan: City break
• Location: Downtown San Francisco
• Dates: Friday, Sept 6 – Sunday, Sept 8
• Participants: 3 people
• Budget: \$70 per person

Activities:
• Walking tour of Fisherman’s Wharf
• Visit to a local museum
• Chinatown food crawl
• Golden Gate Park picnic

Budget breakdown:
• Accommodation: \$90/night (\$180 total, \$60 p/p)
• Food: \$30 p/p (\$90 total)
• Activities & transport: \$20 p/p (\$60 total)

Estimated total: \$330 (\$110 per person)
Let me know if you want to personalize your trip further!
""";
    } else {
      return """
Okay ✅

Quick draft:
Plan: Beach day
• Location: Santa Monica Beach
• Date: Saturday, July 20
• Time: 10:00 AM - 6:00 PM
• Participants: 8 people
• Budget: \$40 per person
Activities:
• Beach games (volleyball, frisbee)
• Swimming and sunbathing
• Picnic lunch
• Sunset walk along the shore

Budget breakdown:
• Beach games equipment rental: \$50
• Picnic lunch (sandwiches, drinks, snacks): \$120

In total, the estimated cost is \$170, which is approximately \$21.25 per person. This leaves some room in your budget for any additional expenses or activities you might want to include.
""";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orange = AppColors.orange;
    final surface = AppColors.surface;
    final assistantBg = AppColors.peach.withOpacity(0.85);

    return Scaffold(
      backgroundColor: surface,
      body: Stack(
        children: [
          // Optional: subtle background icon/illustration
          Positioned(
            top: 60,
            right: -40,
            child: Icon(Icons.lightbulb_circle_rounded,
                size: 180, color: AppColors.orange.withOpacity(0.06)),
          ),
          Column(
            children: [
              // Assistant header
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.orange,
                      child: Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Smart Planner",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Text(
                  "Plan your next adventure with AI suggestions!",
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Suggestion chips
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  children: [
                    _SuggestionChip(
                      text: 'Beach day for 8 people, \$40 each',
                      onTap: _fillPrompt,
                      color: AppColors.orange,
                    ),
                    const SizedBox(width: 8),
                    _SuggestionChip(
                      text: 'Disneyland trip, 4 people, budget \$250 p/p',
                      onTap: _fillPrompt,
                      color: AppColors.orange,
                    ),
                    const SizedBox(width: 8),
                    _SuggestionChip(
                      text: 'City break 2 days, 3 people, budget \$70 p/p',
                      onTap: _fillPrompt,
                      color: AppColors.orange,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.orange.withOpacity(0.10),
                ),
              ),
              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) {
                    final m = _messages[i];
                    final isUser = m.role == Role.user;
                    if (m.role == Role.action && m.text == 'add_trip') {
                      // Show the "Add trip to your feed" message with a button
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Add trip to your feed",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              FilledButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add_location_alt_rounded),
                                label: const Text("Add to Feed"),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.orange,
                                  foregroundColor: AppColors.surface,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: const BoxConstraints(maxWidth: 320),
                        decoration: BoxDecoration(
                          color: isUser
                              ? orange.withOpacity(0.93)
                              : assistantBg,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isUser ? 18 : 4),
                            bottomRight: Radius.circular(isUser ? 4 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textDark.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          m.text,
                          style: TextStyle(
                            color: isUser ? AppColors.surface : AppColors.textDark,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Input bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(22),
                  color: AppColors.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: orange),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Attachment (mock)')),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Describe your fabulous plan...',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _sending ? null : _send,
                          style: FilledButton.styleFrom(
                            backgroundColor: orange,
                            foregroundColor: AppColors.surface,
                            shape: const StadiumBorder(),
                            minimumSize: const Size(44, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                          ),
                          child: _sending
                              ? const SizedBox(
                                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.send_rounded, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _fillPrompt(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final void Function(String) onTap;
  final Color color;
  const _SuggestionChip({required this.text, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      onPressed: () => onTap(text),
      shape: const StadiumBorder(),
      backgroundColor: color.withOpacity(0.10),
      side: BorderSide(color: color.withOpacity(0.18)),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    );
  }
}

enum Role { user, assistant, action }

class _Msg {
  final Role role;
  final String text;
  _Msg({required this.role, required this.text});
}
