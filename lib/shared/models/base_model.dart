// lib/shared/models/base_model.dart
abstract class BaseModel {
  const BaseModel();

  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BaseModel) return false;
    return toString() == other.toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

abstract class BaseEntity {
  const BaseEntity();

  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BaseEntity) return false;
    return props.toString() == (other as BaseEntity).props.toString();
  }

  @override
  int get hashCode => props.hashCode;
}
