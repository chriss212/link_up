import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileData {
  final String name;
  final String email;
  final String phone;
  final List<String> cards;

  const ProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.cards,
  });

  ProfileData copyWith({
    String? name,
    String? email,
    String? phone,
    List<String>? cards,
  }) {
    return ProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cards: cards ?? this.cards,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileData> {
  @override
  ProfileData build() {
    return const ProfileData(
      name: "Sophia Bennett",
      email: "sophia@email.com",
      phone: "+503 7777-8888",
      cards: ["**** **** **** 1234", "**** **** **** 9876"],
    );
  }

  void updateProfile(String name, String email, String phone) {
    state = state.copyWith(name: name, email: email, phone: phone);
  }

  void reset() {
    state = const ProfileData(
      name: "Sophia Bennett",
      email: "sophia@email.com",
      phone: "+503 7777-8888",
      cards: ["**** **** **** 1234", "**** **** **** 9876"],
    );
  }
}

/// Provider para consumir en la UI
final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileData>(ProfileNotifier.new);
