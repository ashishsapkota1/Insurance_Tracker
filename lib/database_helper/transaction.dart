class TransactionDetail{
  // int? id;
  final String family;
  final int year;
  final String session;
  final String amount;
  final String dateOfTransaction;
  final String isAmountReceived;
  final String transactionType;
  final String receiptNo;
  final String remarks;

  TransactionDetail(this.family, this.year, this.session, this.amount, this.dateOfTransaction, this.isAmountReceived,this.transactionType, this.receiptNo, this.remarks);

  // TransactionDetail.withId(this.id, this.family, this.year, this.session, this.amount, this.dateOfTransaction, this.isAmountReceived,this.transactionType, this.receiptNo);


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    // if (id != null) {
    //   map['id'] = id;
    // }
    map['family'] = family;
    map['year'] = year;
    map['session'] = session;
    map['amount'] = amount;
    map['dateOfTransaction']=dateOfTransaction;
    map['isAmountReceived']=isAmountReceived;
    map['transactionType']=transactionType;
    map['receiptNo'] = receiptNo;
    map['remarks'] = remarks;

    return map;
  }

  Map<String, dynamic> updateTransaction() {
    var map = <String, dynamic>{};
    map['year'] = year;
    map['session'] = session;
    map['amount'] = amount;
    map['isAmountReceived'] = isAmountReceived;
    map['transactionType'] = transactionType;
    map['receiptNo'] = receiptNo;
    map['remarks'] = remarks;
    return map;
  }

}
