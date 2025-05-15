class CategoryModel {
  final String name;
  final String image;

  CategoryModel({required this.name, required this.image});

  factory CategoryModel.fromJson(String name) {
    // توليد صورة عشوائية مؤقتة
    final imageUrl = 'https://source.unsplash.com/random/200x200/?$name';
    return CategoryModel(name: name, image: imageUrl);
  }
}
