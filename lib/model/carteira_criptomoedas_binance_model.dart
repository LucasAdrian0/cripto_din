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
        ? new CommissionRates.fromJson(json['commissionRates'])
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
        balances!.add(new Balances.fromJson(v));
      });
    }
    permissions = json['permissions'].cast<String>();
    uid = json['uid'];

    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['makerCommission'] = this.makerCommission;
    data['takerCommission'] = this.takerCommission;
    data['buyerCommission'] = this.buyerCommission;
    data['sellerCommission'] = this.sellerCommission;
    if (this.commissionRates != null) {
      data['commissionRates'] = this.commissionRates!.toJson();
    }
    data['canTrade'] = this.canTrade;
    data['canWithdraw'] = this.canWithdraw;
    data['canDeposit'] = this.canDeposit;
    data['brokered'] = this.brokered;
    data['requireSelfTradePrevention'] = this.requireSelfTradePrevention;
    data['preventSor'] = this.preventSor;
    data['updateTime'] = this.updateTime;
    data['accountType'] = this.accountType;
    if (this.balances != null) {
      data['balances'] = this.balances!.map((v) => v.toJson()).toList();
    }
    data['permissions'] = this.permissions;
    data['uid'] = this.uid;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maker'] = this.maker;
    data['taker'] = this.taker;
    data['buyer'] = this.buyer;
    data['seller'] = this.seller;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['asset'] = this.asset;
    data['free'] = this.free;
    data['locked'] = this.locked;
    return data;
  }
}
