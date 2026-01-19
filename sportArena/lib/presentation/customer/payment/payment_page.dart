import 'dart:async';
import 'package:final_project/data/server/repository/booking_repository.dart';
import 'package:final_project/data/server/usecase/request/add_booking_request.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/currency_text.dart';
import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final int fieldId;
  final String fieldName;
  final DateTime selectedDate;
  final String startTime;
  final String endTime;
  final int totalPrice;

  const PaymentPage({
    super.key,
    required this.fieldId,
    required this.fieldName,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final httpService = HttpService();
      final bookingRepository = BookingRepository(httpService);

      final request = AddBookingRequest(
        fieldId: widget.fieldId,
        bookingDate: widget.selectedDate,
        startTime: widget.startTime,
        endTime: widget.endTime,
        totalPrice: widget.totalPrice,
        status: "confirmed",
      );

      await bookingRepository.createBooking(request);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
            title: const Text("Pembayaran Berhasil!"),
            content: const Text(
              "Booking Anda telah tersimpan dan status sudah LUNAS.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Selesai"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan booking: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konfirmasi Pembayaran")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Rincian Pesanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Divider(),

                    _rowDetail("Lapangan", widget.fieldName),

                    const Divider(),

                    _rowDetail(
                      "Tanggal",
                      DateFormat('dd MMM yyyy').format(widget.selectedDate),
                    ),

                    const Divider(),

                    _rowDetail(
                      "Jam",
                      "${widget.startTime} - ${widget.endTime}",
                    ),

                    const Divider(),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Tagihan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        CurrencyText(
                          value: widget.totalPrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            PrimaryButton(
              text: "Bayar Sekarang",
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
