class InvoiceInfo {
  int id;
  String invoiceNumber;
  String customerName;
  String address;
  String invoiceDate;
  double deuAmount;
  String status;

  InvoiceInfo(
      {required this.id,
      required this.invoiceNumber,
      required this.customerName,
      required this.address,
      required this.invoiceDate,
      required this.deuAmount,
      required this.status});

  factory InvoiceInfo.fromMap(Map<String, dynamic> json) => InvoiceInfo(
        id: json["id"],
        invoiceNumber: json["invoiceNumber"],
        customerName: (json["customerName"]),
        address: json["address"],
        invoiceDate: json["invoiceDate"],
        deuAmount: json["deuAmount"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "invoiceNumber": invoiceNumber,
        "customerName": customerName,
        "address": address,
        "invoiceDate": invoiceDate,
        "deuAmount": deuAmount,
        "status": status,
      };
}
