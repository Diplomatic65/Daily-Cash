class ReceptionModel {
  final String? id;
  final String? receptionName;
  final double? merchant;
  final double? premier;
  final double? edahab;
  final double? eBesa;
  final double? others;
  final double? credit;
  final double? deposit;
  final double? refund;
  final double? discount;
  final String? createdDate;
  final String? createdTime;
  final String? updateDate;
  final String? updateTime;

  ReceptionModel({
    this.id,
    this.receptionName,
    this.merchant,
    this.premier,
    this.edahab,
    this.eBesa,
    this.others,
    this.credit,
    this.deposit,
    this.refund,
    this.discount,
    this.createdDate,
    this.createdTime,
    this.updateDate,
    this.updateTime,
  });
  factory ReceptionModel.fromJson(Map<String, dynamic> json) {
    return ReceptionModel(
      id: json['_id'],
      receptionName: json['receptionName'],
      merchant: (json['merchant'] ?? 0).toDouble(),
      premier: (json['premier'] ?? 0).toDouble(),
      edahab: (json['edahab'] ?? 0).toDouble(),
      eBesa: (json['e-besa'] ?? 0).toDouble(),
      others: (json['others'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      deposit: (json['deposit'] ?? 0).toDouble(),
      refund: (json['refund'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      createdDate: json['createdDate'],
      createdTime: json['createdTime'],
      updateDate: json['updateDate'],
      updateTime: json['updateTime'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'receptionName': receptionName,
      'merchant': merchant ?? 0,
      'premier': premier ?? 0,
      'edahab': edahab ?? 0,
      'e-besa': eBesa ?? 0,
      'others': others ?? 0,
      'credit': credit ?? 0,
      'deposit': deposit ?? 0,
      'refund': refund ?? 0,
      'discount': discount ?? 0,
      'createdDate': createdDate,
      'createdTime': createdTime,
      'updateDate': updateDate,
      'updateTime': updateTime,
    };
  }
}
