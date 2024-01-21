class ISRCustomRow {
  final String invoiceId;
  final String customerName;
  final String date;
  final String grossAmount;
  final String totalDisAmount;
  final String netAmount;
  final String payedAmount;
  final String paymentMethode;
  final String deuAmount;

  ISRCustomRow(this.invoiceId, this.customerName, this.date, this.grossAmount, this.totalDisAmount, this.netAmount, this.payedAmount, this.paymentMethode, this.deuAmount);
}
