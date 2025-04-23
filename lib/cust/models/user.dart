import 'dart:convert';

class User {
  final String id;
  final String nama;
  final String alamat;
  final int nohp;
  User({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.nohp = 0,
  });

  User copyWith({
    String? id,
    String? nama,
    String? alamat,
    int? nohp,
  }) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      nohp: nohp ?? this.nohp,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'nama': nama});
    result.addAll({'alamat': alamat});
    result.addAll({'nohp': nohp});
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      alamat: map['alamat'] ?? '',
      nohp: map['nohp']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, nama: $nama, alamat: $alamat, nohp: $nohp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.nama == nama &&
      other.alamat == alamat &&
      other.nohp == nohp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nama.hashCode ^
      alamat.hashCode ^
      nohp.hashCode;
  }
}
