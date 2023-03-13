import 'menu.dart';

class Menus {
  final List<dynamic> menus;

  const Menus({
    required this.menus,
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      menus: json['menus'],
    );
  }
}
