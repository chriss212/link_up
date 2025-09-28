import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileData {
  String name;
  String email;
  String phone;
  List<String> cards;

  ProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.cards,
  });
}

class ProfileNotifier extends StateNotifier<ProfileData> {
  ProfileNotifier()
      : super(ProfileData(
          name: "Sophia Bennett",
          email: "sophia@email.com",
          phone: "+503 7777-8888",
          cards: ["**** **** **** 1234", "**** **** **** 9876"],
        ));

  void updateProfile(String name, String email, String phone) {
    state = ProfileData(
      name: name,
      email: email,
      phone: phone,
      cards: state.cards,
    );
  }

  void reset() {
    state = ProfileData(
      name: "Sophia Bennett",
      email: "sophia@email.com",
      phone: "+503 7777-8888",
      cards: ["**** **** **** 1234", "**** **** **** 9876"],
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileData>(
  (ref) => ProfileNotifier(),
);
