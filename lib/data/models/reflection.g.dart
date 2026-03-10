// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReflectionAdapter extends TypeAdapter<Reflection> {
  @override
  final int typeId = 0;

  @override
  Reflection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reflection(
      id: fields[0] as String,
      dateTime: fields[1] as DateTime,
      ambienceId: fields[2] as String,
      ambienceTitle: fields[3] as String,
      mood: fields[4] as String,
      journalText: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reflection obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.ambienceId)
      ..writeByte(3)
      ..write(obj.ambienceTitle)
      ..writeByte(4)
      ..write(obj.mood)
      ..writeByte(5)
      ..write(obj.journalText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReflectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
