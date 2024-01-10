import 'package:hive_flutter/hive_flutter.dart';
part 'share_info.g.dart';

@HiveType(typeId: 1)
class ShareInfo {
  ShareInfo({required this.userUID, required this.shareLevel});

  @HiveField(0)
  String userUID;

  @HiveField(1)
  String shareLevel;

  Map<String, dynamic> toJson() {
    return {
      'userUID': userUID,
      'shareLevel': shareLevel,
    };
  }
}
