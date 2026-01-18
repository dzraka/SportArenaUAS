<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Field;
use App\Models\User;
use InvalidArgumentException;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class BookingService
{
    public function getAllBokings()
    {
        return Booking::with(['user', 'field'])
            ->orderBy('booking_date', 'desc')
            ->orderBy('start_time', 'desc')
            ->get();
    }

    public function getUserBookings(User $user)
    {
        return Booking::with(['field'])
            ->where('user_id', $user->id)
            ->orderBy('booking_date', 'desc')
            ->get();
    }

    public function getBookingById($id)
    {
        return Booking::with(['user', 'field'])->findOrFail($id);
    }

    public function createBooking(User $user, array $data)
    {
        $dateStr = Carbon::parse($data['booking_date'])->format('Y-m-d');

        $isBooked = Booking::where('field_id', $data['field_id'])
            ->where('booking_date', $dateStr) 
            ->where('status', '!=', 'cancelled')
            ->where(function ($query) use ($data) {
                $query->where('start_time', '<', $data['end_time'])
                      ->where('end_time', '>', $data['start_time']);
            })
            ->exists();

        if ($isBooked) {
            throw new InvalidArgumentException('The field is already booked for the selected time slot.');
        }

        $field = Field::findOrFail($data['field_id']);

        $start = Carbon::parse($dateStr . ' ' . $data['start_time']);
        $end   = Carbon::parse($dateStr . ' ' . $data['end_time']);

        if ($end->lessThanOrEqualTo($start)) {
             throw new InvalidArgumentException('End time must be after start time.');
        }

        if ($start->diffInMinutes($end) < 60) {
            throw new InvalidArgumentException('The minimum booking duration is 1 hour.');
        }

        $durationInHours = $start->floatDiffInHours($end);
        $totalPrice = $durationInHours * $field->price_per_hour;

        return DB::transaction(function () use ($user, $field, $data, $totalPrice, $dateStr) {
            return Booking::create([
                'user_id' => $user->id,
                'field_id' => $field->id,
                'booking_date' => $dateStr, 
                'start_time' => $data['start_time'],
                'end_time' => $data['end_time'],
                'total_price' => $totalPrice,
                'status' => 'pending',
            ]);
        });
    }

    public function updateBookingStatus($id, $status)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->status === 'completed' && $status === 'pending') {
            throw new InvalidArgumentException('A completed booking cannot be reverted to pending');
        }

        return DB::transaction(function () use ($booking, $status) {
            $booking->update(['status' => $status]);
            return $booking;
        });
    }

    public function cancelBookingByUser(User $user, $id)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->user_id !== $user->id) {
            throw new InvalidArgumentException('You do not have permission to cancel this booking.');
        }

        if ($booking->status !== 'pending') {
            throw new InvalidArgumentException('The booking cannot be cancelled because it has already been processed or completed.');
        }

        return DB::transaction(function () use ($booking) {
            $booking->update(['status' => 'cancelled']);
            return $booking;
        });
    }
}
