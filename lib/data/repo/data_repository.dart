class UserRepository {
  final String? noNfc;
  final String? nokartu;
  final String? nama;
  final String? poin;
  final DateTime? tglInaktif;
  final DateTime? tglDaftar;
  final String? typeMc;
  final String? saldo;
  final String? pemakaianSaldo;
  final String? nopin;
  final String? nomorHape;
  final String? userUpd;
  final DateTime? tglUpd;
  final DateTime? dateTimestamp1;
  final String? saldoBonus;
  final String? pemakaianBonus;
  final String? stOrigin;

  UserRepository({
    required this.noNfc,
    required this.nokartu,
    this.nama,
    required this.poin,
    required this.tglInaktif,
    required this.tglDaftar,
    required this.typeMc,
    required this.saldo,
    required this.pemakaianSaldo,
    this.nopin,
    this.nomorHape,
    required this.userUpd,
    required this.tglUpd,
    required this.dateTimestamp1,
    required this.saldoBonus,
    required this.pemakaianBonus,
    required this.stOrigin,
  });

  factory UserRepository.fromJson(Map<String, dynamic> json) {
    return UserRepository(
      noNfc: json['no_nfc'],
      nokartu: json['nokartu'],
      nama: json['nama'],
      poin: json['poin'], // Ubah menjadi String
      tglInaktif: DateTime.parse(json['tglinaktif']),
      tglDaftar: DateTime.parse(json['tgldaftar']),
      typeMc: json['type_mc'].toString(), // Ubah menjadi String
      saldo: json['saldo'].toString(), // Ubah menjadi String
      pemakaianSaldo: json['pemakaian_saldo'].toString(), // Ubah menjadi String
      nopin: json['nopin'],
      nomorHape: json['nomor_hape'],
      userUpd: json['userupd'],
      tglUpd: DateTime.parse(json['tglupd']),
      dateTimestamp1: DateTime.parse(json['date_timestamp1']),
      saldoBonus: json['saldo_bonus'].toString(), // Ubah menjadi String
      pemakaianBonus: json['pemakaian_bonus'].toString(), // Ubah menjadi String
      stOrigin: json['storigin'],
    );
  }
}
