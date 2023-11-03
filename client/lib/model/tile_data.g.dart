// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileData _$TileDataFromJson(Map<String, dynamic> json) => TileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      title: json['title'] as String?,
      color: json['color'] as int?,
      price: json['price'] as int?,
      payment: json['payment'] as int?,
      owner: json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>),
      improvements: json['improvements'] as int?,
      upperText: json['upperText'] as String?,
      lowerText: json['lowerText'] as String?,
      imagePath: json['imagePath'] as String?,
      imagePath2: json['imagePath2'] as String?,
      visitingText: json['visitingText'] as String?,
      payCommandText: json['payCommandText'] as String?,
    );

Map<String, dynamic> _$TileDataToJson(TileData instance) => <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

ImprovableTileData _$ImprovableTileDataFromJson(Map<String, dynamic> json) =>
    ImprovableTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      owner: json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>),
      improvements: json['improvements'] as int?,
      color: json['color'] as int?,
      price: json['price'] as int?,
      title: json['title'] as String?,
    )
      ..payment = json['payment'] as int?
      ..upperText = json['upperText'] as String?
      ..lowerText = json['lowerText'] as String?
      ..imagePath = json['imagePath'] as String?
      ..imagePath2 = json['imagePath2'] as String?
      ..visitingText = json['visitingText'] as String?
      ..payCommandText = json['payCommandText'] as String?;

Map<String, dynamic> _$ImprovableTileDataToJson(ImprovableTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

CornerTileData _$CornerTileDataFromJson(Map<String, dynamic> json) =>
    CornerTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      upperText: json['upperText'] as String?,
      imagePath: json['imagePath'] as String?,
      lowerText: json['lowerText'] as String?,
      visitingText: json['visitingText'] as String?,
      imagePath2: json['imagePath2'] as String?,
    )
      ..color = json['color'] as int?
      ..price = json['price'] as int?
      ..payment = json['payment'] as int?
      ..improvements = json['improvements'] as int?
      ..owner = json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>)
      ..title = json['title'] as String?
      ..payCommandText = json['payCommandText'] as String?;

Map<String, dynamic> _$CornerTileDataToJson(CornerTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

CommunityTileData _$CommunityTileDataFromJson(Map<String, dynamic> json) =>
    CommunityTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      title: json['title'] as String?,
      imagePath: json['imagePath'] as String?,
    )
      ..color = json['color'] as int?
      ..price = json['price'] as int?
      ..payment = json['payment'] as int?
      ..improvements = json['improvements'] as int?
      ..owner = json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>)
      ..upperText = json['upperText'] as String?
      ..lowerText = json['lowerText'] as String?
      ..imagePath2 = json['imagePath2'] as String?
      ..visitingText = json['visitingText'] as String?
      ..payCommandText = json['payCommandText'] as String?;

Map<String, dynamic> _$CommunityTileDataToJson(CommunityTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

ChanceTileData _$ChanceTileDataFromJson(Map<String, dynamic> json) =>
    ChanceTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      title: json['title'] as String?,
      imagePath: json['imagePath'] as String?,
    )
      ..color = json['color'] as int?
      ..price = json['price'] as int?
      ..payment = json['payment'] as int?
      ..improvements = json['improvements'] as int?
      ..owner = json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>)
      ..upperText = json['upperText'] as String?
      ..lowerText = json['lowerText'] as String?
      ..imagePath2 = json['imagePath2'] as String?
      ..visitingText = json['visitingText'] as String?
      ..payCommandText = json['payCommandText'] as String?;

Map<String, dynamic> _$ChanceTileDataToJson(ChanceTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

TaxTileData _$TaxTileDataFromJson(Map<String, dynamic> json) => TaxTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      title: json['title'] as String?,
      imagePath: json['imagePath'] as String?,
      payCommandText: json['payCommandText'] as String?,
    )
      ..color = json['color'] as int?
      ..price = json['price'] as int?
      ..payment = json['payment'] as int?
      ..improvements = json['improvements'] as int?
      ..owner = json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>)
      ..upperText = json['upperText'] as String?
      ..lowerText = json['lowerText'] as String?
      ..imagePath2 = json['imagePath2'] as String?
      ..visitingText = json['visitingText'] as String?;

Map<String, dynamic> _$TaxTileDataToJson(TaxTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

RailroadTileData _$RailroadTileDataFromJson(Map<String, dynamic> json) =>
    RailroadTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      title: json['title'] as String?,
      imagePath: json['imagePath'] as String?,
      price: json['price'] as int?,
    )
      ..color = json['color'] as int?
      ..payment = json['payment'] as int?
      ..improvements = json['improvements'] as int?
      ..owner = json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>)
      ..upperText = json['upperText'] as String?
      ..lowerText = json['lowerText'] as String?
      ..imagePath2 = json['imagePath2'] as String?
      ..visitingText = json['visitingText'] as String?
      ..payCommandText = json['payCommandText'] as String?;

Map<String, dynamic> _$RailroadTileDataToJson(RailroadTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };

UtilityTileData _$UtilityTileDataFromJson(Map<String, dynamic> json) =>
    UtilityTileData(
      id: json['id'] as int,
      quarterTurns: json['quarterTurns'] as int?,
      title: json['title'] as String?,
      imagePath: json['imagePath'] as String?,
      price: json['price'] as int?,
    )
      ..color = json['color'] as int?
      ..payment = json['payment'] as int?
      ..improvements = json['improvements'] as int?
      ..owner = json['owner'] == null
          ? null
          : PlayerData.fromJson(json['owner'] as Map<String, dynamic>)
      ..upperText = json['upperText'] as String?
      ..lowerText = json['lowerText'] as String?
      ..imagePath2 = json['imagePath2'] as String?
      ..visitingText = json['visitingText'] as String?
      ..payCommandText = json['payCommandText'] as String?;

Map<String, dynamic> _$UtilityTileDataToJson(UtilityTileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterTurns': instance.quarterTurns,
      'color': instance.color,
      'price': instance.price,
      'payment': instance.payment,
      'improvements': instance.improvements,
      'owner': instance.owner?.toJson(),
      'title': instance.title,
      'upperText': instance.upperText,
      'lowerText': instance.lowerText,
      'imagePath': instance.imagePath,
      'imagePath2': instance.imagePath2,
      'visitingText': instance.visitingText,
      'payCommandText': instance.payCommandText,
    };
