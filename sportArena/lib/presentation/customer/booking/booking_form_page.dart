import 'package:final_project/data/server/model/field.dart';
import 'package:final_project/data/server/repository/booking_repository.dart';
import 'package:final_project/data/server/usecase/request/add_booking_request.dart';
import 'package:final_project/data/service/http_service.dart';
import 'package:final_project/presentation/widgets/currency_text.dart';
import 'package:final_project/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingFormPage extends StatefulWidget {
  final Field field;

  const BookingFormPage({super.key, required this.field});

  @override
  State<BookingFormPage> createState() => _FormBookingState();
}

class _FormBookingState extends State<BookingFormPage> {
  late BookingRepository _bookingRepository;

  DateTime? _selectedDate;
  final List<String> _selectedSlots = [];
  List<String> _bookedSlots = [];

  bool _isLoading = false;
  bool _isCheckingSlots = false;

  final List<String> _timeSlots = List.generate(17, (index) {
    int start = 6 + index;
    int end = start + 1;
    return "${start.toString().padLeft(2, '0')}.00-${end.toString().padLeft(2, '0')}.00";
  });

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlots.clear();
        _bookedSlots;
      });
      await _fetchBookedSlots(picked);
    }
  }

  Future<void> _fetchBookedSlots(DateTime date) async {
    setState(() => _isCheckingSlots = true);

    try {
      final httpService = HttpService();
      final repo = BookingRepository(httpService);

      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      final bookings = await repo.getBookingsByDate(widget.field.id, dateStr);

      List<String> loadedSlots = [];

      for (var booking in bookings.data) {
        int startHour = int.parse(booking.startTime.split(':')[0]);
        int endHour = int.parse(booking.endTime.split(':')[0]);

        for (int i = startHour; i < endHour; i++) {
          String startStr = i.toString().padLeft(2, '0');
          String endStr = (i + 1).toString().padLeft(2, '0');
          String slotFormat = "$startStr.00-$endStr.00";
          loadedSlots.add(slotFormat);
        }
      }

      if (mounted) {
        setState(() {
          _bookedSlots = loadedSlots;
          _isCheckingSlots = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _bookedSlots = [];
          _isCheckingSlots = false;
        });
      }
    }
  }

  void _onSlotTap(String slot) {
    if (_bookedSlots.contains(slot)) return;

    setState(() {
      if (_selectedSlots.contains(slot)) {
        _selectedSlots.remove(slot);
      } else {
        _selectedSlots.add(slot);
      }
      _selectedSlots.sort();
    });
  }

  int _totalPrice() {
    return (_selectedSlots.length * widget.field.price).round();
  }

  Future<void> _submit() async {
    if (_selectedDate == null || _selectedSlots.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mohon pilih tanggal dan jam!')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final httpService = HttpService();
      _bookingRepository = BookingRepository(httpService);

      String firstSlot = _selectedSlots.first;
      String lastSlot = _selectedSlots.last;
      String startTimeStr = firstSlot.split('-')[0].replaceAll('.', ':');
      String endTimeStr = lastSlot.split('-')[1].replaceAll('.', ':');

      final request = AddBookingRequest(
        fieldId: widget.field.id,
        bookingDate: _selectedDate!,
        startTime: startTimeStr,
        endTime: endTimeStr,
        totalPrice: _totalPrice(),
      );

      await _bookingRepository.createBooking(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking berhasil dibuat'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _totalPrice();
    return Scaffold(
      appBar: AppBar(title: const Text("Form Booking")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldInfoCard(),

            const SizedBox(height: 24),

            const Text(
              "Pilih Tanggal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            _buildInputContainer(
              icon: Icons.calendar_today,
              label: _selectedDate == null
                  ? "Pilih tanggal"
                  : DateFormat('EEEE, d MMMM yyyy').format(_selectedDate!),
              onTap: _pickDate,
            ),

            const SizedBox(height: 24),

            const Text(
              "Pilih Jam Main",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            _buildTimeSlotGrid(),

            const SizedBox(height: 12),

            Row(
              children: [
                _legendItem(Colors.white, "Tersedia", true),
                const SizedBox(width: 12),
                _legendItem(Colors.blue, "Dipilih", false),
                const SizedBox(width: 12),
                _legendItem(Colors.grey.shade300, "Booked", false),
              ],
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedSlots.length} Jam dipilih:",
                    style: const TextStyle(fontSize: 16),
                  ),

                  CurrencyText(
                    value: totalPrice,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: totalPrice > 0 ? Colors.blue[800] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: PrimaryButton(
          text: 'Booking sekarang',
          isLoading: _isLoading,
          onPressed: (_isLoading || _selectedSlots.isEmpty) ? null : _submit,
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final slot = _timeSlots[index];
        final isBooked = _bookedSlots.contains(slot);
        final isSelected = _selectedSlots.contains(slot);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isBooked ? null : () => _onSlotTap(slot),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isBooked
                    ? Colors.grey[300]
                    : isSelected
                    ? Colors.blue
                    : Colors.white,
                border: Border.all(
                  color: isBooked
                      ? Colors.grey.shade300
                      : (isSelected ? Colors.blue : Colors.grey.shade400),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                slot,
                style: TextStyle(
                  color: isBooked
                      ? Colors.grey
                      : isSelected
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: widget.field.imageUrl != null
                ? Image.network(
                    widget.field.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  )
                : const Icon(Icons.image, size: 50, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.field.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CurrencyText(
                  value: widget.field.price,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  suffix: '/Jam',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputContainer({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, bool border) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: border ? Border.all(color: Colors.grey) : null,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
