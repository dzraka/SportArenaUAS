<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreBookingRequest;
use App\Http\Resources\BookingResource;
use App\Services\BookingService;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    protected $bookingService;

    public function __construct(BookingService $bookingService)
    {
        $this->bookingService = $bookingService;
    }

    /**
     * Get all bookings
     * 
     * (Admin) Melihat seluruh riwayat booking masuk.
     */
    public function index()
    {
        $bookings = $this->bookingService->getAllBokings();

        return response()->json([
            'status' => 'success',
            'message' => 'Bookings retrieved successfully',
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
                $request->validate()
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
        $bookings = $this->bookingService->getUserBookings($request->user());

        return response()->json([
            'status' => 'success',
            'message' => 'User bookings retrieved successfully',
            'data' => BookingResource::collection($bookings)
        ]);
    }
}
