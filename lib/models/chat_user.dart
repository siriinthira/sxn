// data class 

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



//json to dart version 1 : basic info
// class ChatUser {
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
//   late final String image;
//   late final String createdAt;
//   late final bool isOnline;
//   late final String lastActive;
//   late final String id;
//   late final String selfIntro;
//   late final String pushToken;
//   late final String email;
//   late final String username;
  
//   ChatUser.fromJson(Map<String, dynamic> json){
//     image = json['image'];
//     createdAt = json['created_at'];
//     isOnline = json['is_online'];
//     lastActive = json['last_active'];
//     id = json['id'];
//     selfIntro = json['selfIntro'];
//     pushToken = json['push_token'];
//     email = json['email'];
//     username = json['username'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['image'] = image;
//     _data['created_at'] = createdAt;
//     _data['is_online'] = isOnline;
//     _data['last_active'] = lastActive;
//     _data['id'] = id;
//     _data['selfIntro'] = selfIntro;
//     _data['push_token'] = pushToken;
//     _data['email'] = email;
//     _data['username'] = username;
//     return _data;
//   }
// }


// json to dart version 2 : full info 



class ChatUser {

  //constructor and required parameters
  ChatUser({
    required this.image,
    required this.occupation,
    required this.createdAt,
    required this.educationLevel,
    required this.experience,
    required this.certification,
    required this.skills,
    required this.universities,
    required this.schools,
    required this.hobbies,
    required this.location,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.selfIntro,
    required this.email,
    required this.pushToken,
    required this.username,
  });

  //declare properties to store the user's attributes
  //late final  can be initialized after object creation but cannot be changed once set.
  late  String selfIntro;
  late  String username;
  late  String image;
  late  bool isOnline;
  late String pushToken;
  late String lastActive;
  late String id;
  late String email;
  late String createdAt;
  late List<String> occupation;
  late List<String> educationLevel;
  late List<String> experience;
  late List<String> certification;
  late List<String> skills;
  late List<String> universities;
  late List<String> schools;
  late List<String> hobbies;
  late String location;


 
  
  // It takes a Map<String, dynamic> as input.
  // It extracts values from the JSON map and assigns them to the corresponding properties of the ChatUser object.


  ChatUser.fromJson(Map<String, dynamic> json){

    image = json['image'];
    occupation = List.castFrom<dynamic, String>(json['occupation']);
    createdAt = json['created_at'];

    // Handle fields that can be either a String or List<dynamic>

    educationLevel = (json['educationLevel'] is List)
        ? (json['educationLevel'] as List).cast<String>()
        : <String>[json['educationLevel']];
        
    experience = (json['experience'] is List)
        ? (json['experience'] as List).cast<String>()
        : <String>[json['experience']];
        
    certification = (json['certification'] is List)
        ? (json['certification'] as List).cast<String>()
        : <String>[json['certification']];
        
    skills = (json['skills'] is List)
        ? (json['skills'] as List).cast<String>()
        : <String>[json['skills']];
    
    universities = (json['universities'] is List)
        ? (json['universities'] as List).cast<String>()
        : <String>[json['universities']];
    
    schools = (json['schools'] is List)
        ? (json['schools'] as List).cast<String>()
        : <String>[json['schools']];
    
    hobbies = (json['hobbies'] is List)
        ? (json['hobbies'] as List).cast<String>()
        : <String>[json['hobbies']];


    location = json['location'];
    lastActive = json['last_active'];
    isOnline = json['is_online'];
    id = json['id'];
    selfIntro = json['selfIntro'];
    email = json['email'];
    username = json['username'];
    pushToken = json['push_token'];


    // educationLevel = List.castFrom<dynamic, String>(json['educationLevel']);
    
    // educationLevel = (json['educationLevel'] as List<dynamic>).cast<String>();

    // experience = (json['experience'] as List<dynamic>).cast<String>();

    // certification = (json['certification'] as List<dynamic>).cast<String>();

    // skills = (json['skills'] as List<dynamic>).cast<String>();

    // universities = (json['universities'] as List<dynamic>).cast<String>();

    // schools = (json['schools'] as List<dynamic>).cast<String>();

    // hobbies = (json['hobbies'] as List<dynamic>).cast<String>();
  }


    //toJson Method:
    //This method is used to convert a ChatUser instance back into a JSON map.
    //It creates an empty map (_data) and populates it with the values from the ChatUser object's properties.
    //The resulting map can be easily serialized into a JSON string using a library like dart:convert.

    
   Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    
    _data['image'] = image;
    _data['occupation'] = occupation;
    _data['created_at'] = createdAt;
    _data['educationLevel'] = educationLevel;
    _data['experience'] = experience;
    _data['certification'] = certification;
    _data['skills'] = skills;
    _data['universities'] = universities;
    _data['schools'] = schools;
    _data['hobbies'] = hobbies;
    _data['location'] = location;
    _data['last_active'] = lastActive;
    _data['is_online'] = isOnline;
    _data['id'] = id;
    _data['selfIntro'] = selfIntro;
    _data['email'] = email;
    _data['push_token'] = pushToken;
    _data['username'] = username;

    return _data;
  }
}

// Example usage:
// Assuming you have JSON data in 'jsonMap'


// Parse JSON data into a ChatUser object : creates a ChatUser instance from a JSON map (jsonMap).
final ChatUser chatUser = ChatUser.fromJson(jsonMap);

// Convert a ChatUser object to JSON : converts an instance of ChatUser back into a JSON map.
final Map<String, dynamic> jsonMap = chatUser.toJson();

// https://jsontodart.in/