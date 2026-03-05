class CarteiraCriptomoedasBinanceModel {
  int? makerCommission;
  int? takerCommission;
  int? buyerCommission;
  int? sellerCommission;
  CommissionRates? commissionRates;
  bool? canTrade;
  bool? canWithdraw;
  bool? canDeposit;
  bool? brokered;
  bool? requireSelfTradePrevention;
  bool? preventSor;
  int? updateTime;
  String? accountType;
  List<Balances>? balances;
  List<String>? permissions;
  int? uid;

  CarteiraCriptomoedasBinanceModel(
      {this.makerCommission,
      this.takerCommission,
      this.buyerCommission,
      this.sellerCommission,
      this.commissionRates,
      this.canTrade,
      this.canWithdraw,
      this.canDeposit,
      this.brokered,
      this.requireSelfTradePrevention,
      this.preventSor,
      this.updateTime,
      this.accountType,
      this.balances,
      this.permissions,
      this.uid});

  CarteiraCriptomoedasBinanceModel.fromJson(Map<String, dynamic> json) {
    makerCommission = json['makerCommission'];
    takerCommission = json['takerCommission'];
    buyerCommission = json['buyerCommission'];
    sellerCommission = json['sellerCommission'];
    commissionRates = json['commissionRates'] != null
        ? CommissionRates.fromJson(json['commissionRates'])
        : null;
    canTrade = json['canTrade'];
    canWithdraw = json['canWithdraw'];
    canDeposit = json['canDeposit'];
    brokered = json['brokered'];
    requireSelfTradePrevention = json['requireSelfTradePrevention'];
    preventSor = json['preventSor'];
    updateTime = json['updateTime'];
    accountType = json['accountType'];
    if (json['balances'] != null) {
      balances = <Balances>[];
      json['balances'].forEach((v) {
        balances!.add(Balances.fromJson(v));
      });
    }
    permissions = json['permissions'].cast<String>();
    uid = json['uid'];

    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['makerCommission'] = makerCommission;
    data['takerCommission'] = takerCommission;
    data['buyerCommission'] = buyerCommission;
    data['sellerCommission'] = sellerCommission;
    if (commissionRates != null) {
      data['commissionRates'] = commissionRates!.toJson();
    }
    data['canTrade'] = canTrade;
    data['canWithdraw'] = canWithdraw;
    data['canDeposit'] = canDeposit;
    data['brokered'] = brokered;
    data['requireSelfTradePrevention'] = requireSelfTradePrevention;
    data['preventSor'] = preventSor;
    data['updateTime'] = updateTime;
    data['accountType'] = accountType;
    if (balances != null) {
      data['balances'] = balances!.map((v) => v.toJson()).toList();
    }
    data['permissions'] = permissions;
    data['uid'] = uid;
    return data;
  }
}

class CommissionRates {
  String? maker;
  String? taker;
  String? buyer;
  String? seller;

  CommissionRates({this.maker, this.taker, this.buyer, this.seller});

  CommissionRates.fromJson(Map<String, dynamic> json) {
    maker = json['maker'];
    taker = json['taker'];
    buyer = json['buyer'];
    seller = json['seller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maker'] = maker;
    data['taker'] = taker;
    data['buyer'] = buyer;
    data['seller'] = seller;
    return data;
  }
}

class Balances {
  String? asset;
  String? free;
  String? locked;

  Balances({this.asset, this.free, this.locked});

  Balances.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    free = json['free'];
    locked = json['locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset'] = asset;
    data['free'] = free;
    data['locked'] = locked;
    return data;
  }
}
