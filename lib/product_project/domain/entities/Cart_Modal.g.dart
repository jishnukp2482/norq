// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart_Modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartModalAdapter extends TypeAdapter<CartModal> {
  @override
  final int typeId = 1;

  @override
  CartModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModal(
      fields[0] as ProductResponseModal,
      fields[1] as int,
      fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CartModal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.productResponseModal)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.subtotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
