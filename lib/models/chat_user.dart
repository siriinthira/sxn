// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class ChatUser {
//   final String image;
  
//   final String createdAt;
  
//   final String isOnline;
  
//   final String lastActive;
  
//   final String id;
  
//   final String selfIntro;
  
//   final String pushToken;
  
//   final String email;
  
//   final String username;

//   //generate data class
//   ChatUser({
//     required this.image,
//     required this.createdAt,
//     required this.isOnline,
//     required this.lastActive,
//     required this.id,
//     required this.selfIntro,
//     required this.pushToken,
//     required this.email,
//     required this.username,
//   });


//   ChatUser copyWith({
//     String? image,
//     String? createdAt,
//     String? isOnline,
//     String? lastActive,
//     String? id,
//     String? selfIntro,
//     String? pushToken,
//     String? email,
//     String? username,
//   }) {
//     return ChatUser(
//       image: image ?? this.image,
//       createdAt: createdAt ?? this.createdAt,
//       isOnline: isOnline ?? this.isOnline,
//       lastActive: lastActive ?? this.lastActive,
//       id: id ?? this.id,
//       selfIntro: selfIntro ?? this.selfIntro,
//       pushToken: pushToken ?? this.pushToken,
//       email: email ?? this.email,
//       username: username ?? this.username,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'image': image,
//       'createdAt': createdAt,
//       'isOnline': isOnline,
//       'lastActive': lastActive,
//       'id': id,
//       'selfIntro': selfIntro,
//       'pushToken': pushToken,
//       'email': email,
//       'username': username,
//     };
//   }

//   factory ChatUser.fromMap(Map<String, dynamic> map) {
//     return ChatUser(
//       image: map['image'] as String,
//       createdAt: map['createdAt'] as String,
//       isOnline: map['isOnline'] as String,
//       lastActive: map['lastActive'] as String,
//       id: map['id'] as String,
//       selfIntro: map['selfIntro'] as String,
//       pushToken: map['pushToken'] as String,
//       email: map['email'] as String,
//       username: map['username'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatUser.fromJson(String source) => ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'ChatUser(image: $image, createdAt: $createdAt, isOnline: $isOnline, lastActive: $lastActive, id: $id, selfIntro: $selfIntro, pushToken: $pushToken, email: $email, username: $username)';
//   }

//   @override
//   bool operator ==(covariant ChatUser other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.image == image &&
//       other.createdAt == createdAt &&
//       other.isOnline == isOnline &&
//       other.lastActive == lastActive &&
//       other.id == id &&
//       other.selfIntro == selfIntro &&
//       other.pushToken == pushToken &&
//       other.email == email &&
//       other.username == username;
//   }

//   @override
//   int get hashCode {
//     return image.hashCode ^
//       createdAt.hashCode ^
//       isOnline.hashCode ^
//       lastActive.hashCode ^
//       id.hashCode ^
//       selfIntro.hashCode ^
//       pushToken.hashCode ^
//       email.hashCode ^
//       username.hashCode;
//   }
// }


class ChatUser {
  ChatUser({
    required this.image,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.selfIntro,
    required this.pushToken,
    required this.email,
    required this.username,
  });
  late final String image;
  late final String createdAt;
  late final bool isOnline;
  late final String lastActive;
  late final String id;
  late final String selfIntro;
  late final String pushToken;
  late final String email;
  late final String username;
  
  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'];
    createdAt = json['created_at'];
    isOnline = json['is_online'];
    lastActive = json['last_active'];
    id = json['id'];
    selfIntro = json['selfIntro'];
    pushToken = json['push_token'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['created_at'] = createdAt;
    _data['is_online'] = isOnline;
    _data['last_active'] = lastActive;
    _data['id'] = id;
    _data['selfIntro'] = selfIntro;
    _data['push_token'] = pushToken;
    _data['email'] = email;
    _data['username'] = username;
    return _data;
  }
}

// https://jsontodart.in/