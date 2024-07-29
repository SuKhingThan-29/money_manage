
class UserGuide{
  final String id;
  final String image;
  final String name;
  UserGuide({required this.id,required this.image,required this.name});
  factory UserGuide.fromJson(Map<String,dynamic> jsonData){
    return UserGuide(id: jsonData['id'], image: jsonData['image'], name: jsonData['name']);
  }
}