class Family{
  String name='';
  int hiCode=0;
  String? phnNo;
  int? membersNo;
  String? annualFee;
  String? lastRenewal;
  String? type;
  String? renewalDue;

  Family({required this.hiCode,required this.name});





  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['hiCode']= hiCode;
    map['name'] = name;
    map['phnNo'] = phnNo;
    map['membersNo'] = membersNo;
    map['annualFee'] = annualFee;
    map['lastRenewal']=lastRenewal;
    map['type']=type;
    map['renewalDue']=renewalDue;

    return map;
  }

  Family.fromMapObject(Map<String, dynamic> map) {
    hiCode=map['hiCode'];
    name = map["name"];
    phnNo = map["phnNo"];
    membersNo = map["membersNo"];
    lastRenewal = map["lastRenewal"];
    annualFee = map["annualFee"];
    type= map['type'];
    renewalDue=map['renewalDue'];
  }
}