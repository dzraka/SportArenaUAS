import 'package:final_project/data/server/model/booking.dart';
import 'package:final_project/data/server/repository/booking_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class AdminBookingIndexPage extends StatefulWidget {
  const AdminBookingIndexPage({super.key});

  @override
  State<AdminBookingIndexPage> createState() => _AdminBookingIndexPageState();
}

class _AdminBookingIndexPageState extends State<AdminBookingIndexPage> {
  late BookingRepository _bookingRepository;
  List<Booking> _bookingList = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _bookingRepository = BookingRepository(httpService);
    _loadBookingData();
  }

  Future<void> _loadBookingData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _bookingRepository.getAllBookings();

      if (mounted) {
        setState(() {
          _bookingList = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Terjadi Kesalahan:\n$_errorMessage',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _loadBookingData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_bookingList.isEmpty) {
      return const Center(child: Text('Belum ada data booking.'));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Booking',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _loadBookingData,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh Data',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    if (_bookingList.isEmpty) {
      return const Center(child: Text('Belum ada data booking.'));
    }

    return ListView.builder(
      itemCount: _bookingList.length,
      itemBuilder: (context, index) {
        final booking = _bookingList[index];
        return BookingCard(booking: booking);
      },
    );
  }
}
