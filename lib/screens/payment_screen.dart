import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uts_genap/modal/item.dart';

class PaymentScreen extends StatefulWidget {
  final int total;
  final VoidCallback onPaymentSuccess;
  final List<Item> items; // Add an items parameter

  PaymentScreen({
    required this.total,
    required this.onPaymentSuccess,
    required this.items, // Initialize the items list
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _paymentController = TextEditingController();
  int _change = 0;
  String _paymentmsg = '';

  void _calculateChange() {
    int payment = int.tryParse(_paymentController.text) ?? 0;
    setState(() {
      _change = payment - widget.total;
    });
    _text();
  }

  void _text() {
    if (_change > 0) {
      _paymentmsg = 'Pembayaran sukses \nKembalian: Rp. $_change';
      widget.onPaymentSuccess();
    } else {
      _paymentmsg = 'Pembayaran gagal \nUang Kurang Rp. ${_change.abs()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Transaksi:', style: TextStyle(fontSize: 20)),
            Text('Rp. ${widget.total}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('Detail Pembelian:', style: TextStyle(fontSize: 20)),
            // Display each purchased item
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items.map((item) {
                return Text('${item.name}: Rp. ${item.price}');
              }).toList(),
            ),
            TextField(
              controller: _paymentController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*|0$')),
              ],
              decoration: InputDecoration(labelText: 'Masukkan Nominal Pembayaran'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _calculateChange, child: Text('Bayar')),
            const SizedBox(height: 20),
            Text(_paymentmsg, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
