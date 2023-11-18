class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String name;
  late String id;
  late String createdAt;
  late String lastActive;
  late String email;
  late String pushToken;
  late String isOnline;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['createdAt'] ?? '';
    isOnline = json['isOnline'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['lastActive'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['pushToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;

    data['email'] = email;
    data['push_token'] = pushToken;
    data['image'] = image;
    return data;
  }
}
