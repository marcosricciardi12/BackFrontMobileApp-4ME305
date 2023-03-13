class Menu {
  final int menuid;
  final double price;
  final String name;
  final String description;

  const Menu({
    required this.menuid,
    required this.price,
    required this.name,
    required this.description,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        menuid: json['id'],
        price: json['price'],
        name: json['name'],
        description: json['description']);
  }
}
