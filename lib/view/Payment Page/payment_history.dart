import 'package:kpathshala/app_base/common_imports.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Payment History"),
        backgroundColor: Colors.transparent,
      ),
    ));
  }
}
