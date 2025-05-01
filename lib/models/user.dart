import 'dart:convert';

class User {
  final String id;
  final String nama;
  final String alamat;
  final int nohp;
  final String layanan;
  final int berat;
  final String pakaian;
  final String anjem;
  User({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.nohp = 0,
    this.layanan = '',
    this.berat = 0,
    this.pakaian = '',
    this.anjem = '',
  });

  User copyWith({
    String? id,
    String? nama,
    String? alamat,
    int? nohp,
    String? layanan,
    int? berat,
    String? pakaian,
    String? anjem,
  }) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      nohp: nohp ?? this.nohp,
      layanan: layanan ?? this.layanan,
      berat: berat ?? this.berat,
      pakaian: pakaian ?? this.pakaian,
      anjem: anjem ?? this.anjem,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'nama': nama});
    result.addAll({'alamat': alamat});
    result.addAll({'nohp': nohp});
    result.addAll({'layanan': layanan});
    result.addAll({'berat': berat});
    result.addAll({'pakaian': pakaian});
    result.addAll({'anjem': anjem});
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      alamat: map['alamat'] ?? '',
      nohp: map['nohp']?.toInt() ?? 0,
      layanan: map['layanan'] ?? '',
      berat: map['berat']?.toInt() ?? 0,
      pakaian: map['pakaian'] ?? '',
      anjem: map['anjem'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, nama: $nama, alamat: $alamat, nohp: $nohp, layanan: $layanan, berat: $berat, pakaian: $pakaian, anjem: $anjem)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.nama == nama &&
      other.alamat == alamat &&
      other.nohp == nohp &&
      other.layanan == layanan &&
      other.berat == berat &&
      other.pakaian == pakaian &&
      other.anjem == anjem;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nama.hashCode ^
      alamat.hashCode ^
      nohp.hashCode ^
      layanan.hashCode ^
      berat.hashCode ^
      pakaian.hashCode ^
      anjem.hashCode;
  }
}
