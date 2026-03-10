// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActiveSessionAdapter extends TypeAdapter<ActiveSession> {
  @override
  final int typeId = 1;

  @override
  ActiveSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActiveSession(
      ambienceId: fields[0] as String,
      elapsedSeconds: fields[1] as int,
      isPlaying: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ActiveSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ambienceId)
      ..writeByte(1)
      ..write(obj.elapsedSeconds)
      ..writeByte(2)
      ..write(obj.isPlaying);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
