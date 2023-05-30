class Family {
  final String name;
  final int hiCode;
  final String phnNo;
  final int membersNo;
  final String renewalSession;
  final String annualFee;
  final String type;
  final int lastRenewalYear;
  final String lastRenewalSession;

  Family(
      this.hiCode,
      this.name,
      this.phnNo,
      this.membersNo,
      this.renewalSession,
      this.annualFee,
      this.type,
      this.lastRenewalYear,
      this.lastRenewalSession);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['hiCode'] = hiCode;
    map['name'] = name;
    map['phnNo'] = phnNo;
    map['membersNo'] = membersNo;
    map['renewalSession'] = renewalSession;
    map['annualFee'] = annualFee;
    map['type'] = type;
    map['lastRenewalYear'] = lastRenewalYear;
    map['lastRenewalSession'] = lastRenewalSession;

    return map;
  }
}
