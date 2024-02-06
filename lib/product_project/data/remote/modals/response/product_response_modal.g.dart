// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductResponseModalAdapter extends TypeAdapter<ProductResponseModal> {
  @override
  final int typeId = 2;

  @override
  ProductResponseModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductResponseModal(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      description: fields[3] as String,
      category: fields[4] as Category,
      image: fields[5] as String,
      rating: fields[6] as Rating,
    );
  }

  @override
  void write(BinaryWriter writer, ProductResponseModal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductResponseModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RatingAdapter extends TypeAdapter<Rating> {
  @override
  final int typeId = 4;

  @override
  Rating read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rating(
      rate: fields[1] as double,
      count: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Rating obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.rate)
      ..writeByte(2)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 3;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return Category.ELECTRONICS;
      case 2:
        return Category.JEWELERY;
      case 3:
        return Category.MEN_S_CLOTHING;
      case 4:
        return Category.WOMEN_S_CLOTHING;
      default:
        return Category.ELECTRONICS;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.ELECTRONICS:
        writer.writeByte(1);
        break;
      case Category.JEWELERY:
        writer.writeByte(2);
        break;
      case Category.MEN_S_CLOTHING:
        writer.writeByte(3);
        break;
      case Category.WOMEN_S_CLOTHING:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
