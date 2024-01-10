// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShareInfoAdapter extends TypeAdapter<ShareInfo> {
  @override
  final int typeId = 1;

  @override
  ShareInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShareInfo(
      userUID: fields[0] as String,
      shareLevel: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShareInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userUID)
      ..writeByte(1)
      ..write(obj.shareLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShareInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
