class Family {
  final String name;
  final String hiCode;
  final String phnNo;
  final int membersNo;
  final String annualFee;
  final String type;
  final int lastRenewalYear;
  final String lastRenewalSession;
  final String address;

  Family(
      this.hiCode,
      this.name,
      this.phnNo,
      this.membersNo,
      this.annualFee,
      this.type,
      this.lastRenewalYear,
      this.lastRenewalSession,
      this.address);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['hiCode'] = hiCode;
    map['name'] = name;
    map['phnNo'] = phnNo;
    map['membersNo'] = membersNo;
    map['annualFee'] = annualFee;
    map['type'] = type;
    map['lastRenewalYear'] = lastRenewalYear;
    map['lastRenewalSession'] = lastRenewalSession;
    map['address'] = address;

    return map;
  }

  Map<String, dynamic> updateFamilyWhileRenew() {
    var map = <String, dynamic>{};
    map['lastRenewalYear'] = lastRenewalYear;
    map['lastRenewalSession'] = lastRenewalSession;

    return map;
  }
}
