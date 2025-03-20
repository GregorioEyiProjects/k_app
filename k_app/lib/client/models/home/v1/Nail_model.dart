class Nail {
  final String? id;
  final String name;
  final String image;
  final String price;
  final String rating;
  final String description;

  Nail({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
  });

  //
  static List<Nail> nails = [
    Nail(
      name: "Dip Powder",
      image: "assets/images/image2.webp",
      price: "20",
      rating: "4.5",
      description: "Dip Powder",
    ),
    Nail(
      name: "Round nails",
      image: "assets/images/2.jpeg",
      price: "20",
      rating: "4.5",
      description: "Round nails",
    ),
    Nail(
      name: "Stiletto nails",
      image: "assets/images/3.png",
      price: "20",
      rating: "4.5",
      description: "Stiletto nails",
    ),
    Nail(
      name: "Acrylic manicure",
      image: "assets/images/image3.png",
      price: "20",
      rating: "4.5",
      description: "Acrylic manicure",
    ),
    Nail(
      name: "Almond nails",
      image: "assets/images/1.png",
      price: "20",
      rating: "4.5",
      description: "Almond nails",
    ),
    Nail(
      name: "Oval nails",
      image: "assets/images/2.jpeg",
      price: "20",
      rating: "4.5",
      description: "Oval nails",
    ),
  ];

  // Factory method to create a Nail object from a Map
  factory Nail.fromMap(Map<String, dynamic> data) {
    return Nail(
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? '',
      rating: data['rating'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
