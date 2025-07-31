class TransactionWaiterModel {
  final String? id;
  final String? waiter;
  final double? merchant;
  final double? premier;
  final double? edahab;
  final double? eBesa;
  final double? others;
  final double? credit;
  final double? promotion;
  final double? open;
  final String? createdDate;
  final String? createdTime;
  final String? updateDate;
  final String? updateTime;

  TransactionWaiterModel({
    this.id,
    this.waiter,
    this.merchant,
    this.premier,
    this.edahab,
    this.eBesa,
    this.others,
    this.credit,
    this.promotion,
    this.open,
    this.createdDate,
    this.createdTime,
    this.updateDate,
    this.updateTime,
  });

  factory TransactionWaiterModel.fromJson(Map<String, dynamic> json) {
    return TransactionWaiterModel(
      id: json['_id'],
      waiter: json['waiter'],
      merchant: (json['merchant'] ?? 0).toDouble(),
      premier: (json['premier'] ?? 0).toDouble(),
      edahab: (json['edahab'] ?? 0).toDouble(),
      eBesa: (json['e-besa'] ?? 0).toDouble(),
      others: (json['others'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      promotion: (json['promotion'] ?? 0).toDouble(),
      open: (json['open'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waiter': waiter,
      'merchant': merchant ?? 0,
      'premier': premier ?? 0,
      'edahab': edahab ?? 0,
      'e-besa': eBesa ?? 0,
      'others': others ?? 0,
      'credit': credit ?? 0,
      'promotion': promotion ?? 0,
      'open': open ?? 0,
    };
  }
}
