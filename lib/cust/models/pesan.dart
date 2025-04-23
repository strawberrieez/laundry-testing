import 'dart:convert';

class Pesan {
  final String layanan;
  final int berat;
  final String pakaian;
  final String anjem;
  Pesan({
    this.layanan = '',
    this.berat = 0,
    this.pakaian = '',
    this.anjem = '',
  });

  Pesan copyWith({
    String? layanan,
    int? berat,
    String? pakaian,
    String? anjem,
  }) {
    return Pesan(
      layanan: layanan ?? this.layanan,
      berat: berat ?? this.berat,
      pakaian: pakaian ?? this.pakaian,
      anjem: anjem ?? this.anjem,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'layanan': layanan});
    result.addAll({'berat': berat});
    result.addAll({'pakaian': pakaian});
    result.addAll({'anjem': anjem});
  
    return result;
  }

  factory Pesan.fromMap(Map<String, dynamic> map) {
    return Pesan(
      layanan: map['layanan'] ?? '',
      berat: map['berat']?.toInt() ?? 0,
      pakaian: map['pakaian'] ?? '',
      anjem: map['anjem'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Pesan.fromJson(String source) => Pesan.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Pesan(layanan: $layanan, berat: $berat, pakaian: $pakaian, anjem: $anjem)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Pesan &&
      other.layanan == layanan &&
      other.berat == berat &&
      other.pakaian == pakaian &&
      other.anjem == anjem;
  }

  @override
  int get hashCode {
    return layanan.hashCode ^
      berat.hashCode ^
      pakaian.hashCode ^
      anjem.hashCode;
  }
}
