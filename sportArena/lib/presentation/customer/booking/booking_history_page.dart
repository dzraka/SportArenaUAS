import 'package:final_project/data/server/model/booking.dart';
import 'package:final_project/data/server/model/user.dart';
import 'package:final_project/data/server/repository/booking_repository.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  final User user;
  const BookingHistoryPage({super.key, required this.user});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late BookingRepository _bookingRepository;
  List<Booking> _bookingList = [];

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final httpService = HttpService();
    _bookingRepository = BookingRepository(httpService);
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _bookingRepository.getUserBookings();

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
                    'Riwayat Booking',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    onPressed: _loadHistoryData,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
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
      return const Center(child: Text('Belum ada riwayat booking.'));
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
