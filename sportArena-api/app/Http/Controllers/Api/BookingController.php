<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreBookingRequest;
use App\Http\Resources\BookingResource;
use App\Services\BookingService;
use Illuminate\Http\Request;
use App\Models\Booking;

class BookingController extends Controller
{
    protected $bookingService;

    public function __construct(BookingService $bookingService)
    {
        $this->bookingService = $bookingService;
    }

    private function autoUpdateStatus()
    {
        $now = now();
        $currentDate = $now->format('Y-m-d');
        $currentTime = $now->format('H:i');

        Booking::where('status', 'confirmed')
            ->where(function ($query) use ($currentDate, $currentTime) {
                $query->where('booking_date', '<', $currentDate)
                      ->orWhere(function ($q) use ($currentDate, $currentTime) {
                          $q->where('booking_date', $currentDate)
                            ->where('end_time', '<=', $currentTime);
                      });
            })
            ->update(['status' => 'complete']);
    }

    /**
     * Get all bookings
     * 
     * (Admin) Melihat seluruh riwayat booking masuk.
     */
    public function index()
    {
        $this->autoUpdateStatus();

        $bookings = $this->bookingService->getAllBookings();

        return response()->json([
            'status' => 'success',
            'message' => 'All bookings retrieved (Admin)',
            'data' => BookingResource::collection($bookings)
        ]);
    }

    /**
     * Check Field Availability
     * 
     * Mengambil daftar slot waktu yang sudah dibooking
     */
    public function checkSlots(Request $request)
    {
        $this->autoUpdateStatus();

        $request->validate([
            'field_id' => 'required',
            'booking_date' => 'required|date',
        ]);
        $query = Booking::query();
        $query->where('field_id', $request->field_id);
        $query->whereDate('booking_date', $request->booking_date);
        $query->where('status', '!=', 'cancelled'); 
        $bookings = $query->get();
        return response()->json([
            'status' => 'success',
            'message' => 'Slots retrieved successfully',
            'data' => BookingResource::collection($bookings)
        ]);
    }

    /**
     * Crate a new booking
     * 
     * (Customer) Membuat pesanan lapangan.
     */
    public function store(StoreBookingRequest $request)
    {
        try {
            $booking = $this->bookingService->createBooking(
                $request->user(),
                $request->validated()
            );

            return response()->json([
                'status' => 'success',
                'message' => 'Booking created successfully',
                'data' => new BookingResource($booking)
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'data' => null
            ], 400);
        }
    }

    /**
     * Update booking status
     * 
     * (Admin) Mengubah status pesanan.
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,confirmed,completed,cancelled'
        ]);

        try {
            $updatedBooking = $this->bookingService->updateBookingStatus($id, $request);

            return response()->json([
                'status' => 'success',
                'message' => 'Booking status updated successfully',
                'data' => new BookingResource($updatedBooking)
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'data' => null
            ], 400);
        }
    }

    /**
     * Cancel a booking
     * 
     * (Customer) Membatalkan pesanan yang masih pending.
     */
    public function cancel(Request $request, $id)
    {
        try {
            $booking = $this->bookingService->cancelBookingByUser($request->user(), $id);

            return response()->json([
                'status' => 'success',
                'message' => 'Booking cancelled successfully',
                'data' => new BookingResource($booking)
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'data' => null
            ], 400);
        }
    }

    /**
     * Get booking details
     * 
     * Melihat detail pesanan tertentu.
     */
    public function show($id)
    {
        try {
            $this->autoUpdateStatus();

            $booking = $this->bookingService->getBookingById($id);

            return response()->json([
                'status' => 'success',
                'message' => 'Booking retrieved successfully',
                'data' => new BookingResource($booking)
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Booking not found',
                'data' => null
            ], 404);
        }
    }

    /**
     * Get user bookings
     * 
     * (Customer) Melihat riwayat booking.
     */
    public function userBookings(Request $request)
    {
        $this->autoUpdateStatus();

        $bookings = $this->bookingService->getUserBookings($request->user());

        return response()->json([
            'status' => 'success',
            'message' => 'User bookings retrieved successfully',
            'data' => BookingResource::collection($bookings)
        ]);
    }
}
