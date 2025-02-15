class TransactionRepository {
  final String? usrCr;
  final int count;
  final String? dateUpd;
  final String? noNfc;
  final String? tipe;

  TransactionRepository({
    required this.usrCr,
    required this.count,
    required this.dateUpd,
    required this.noNfc,
    required this.tipe,
  });

  factory TransactionRepository.fromJson(Map<String, dynamic> json) {
    return TransactionRepository(
      usrCr: json['usr_cr'] ?? '',
      count: json['count'] ?? 0,
      dateUpd: json['date_upd'] ?? '',
      noNfc: json['no_nfc'] ?? '',
      tipe: json['tipe'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usr_cr': usrCr,
      'count': count,
      'date_upd': dateUpd,
      'no_nfc': noNfc,
      'tipe': tipe,
    };
  }
}
