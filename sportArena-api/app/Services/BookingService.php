<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Field;
use Exception;

class BookingService
{
    public function createBooking($user, array $data)
    {
        $field = Field::findOrFail($data['field_id']);

        $isBooked = Booking::where('field_id', $field->id)
            ->where('booking_date', $data['booking_date'])
            ->where(function ($query) use ($data) {
                $query->whereBetween('start_time', [$data['start_time'], $data['end_time']])
                    ->orWhereBetween('end_time', [$data['start_time'], $data['end_time']]);
            })
            ->where('status', '!=', 'cancelled')
            ->exists();

        if ($isBooked) {
            throw new Exception("Jadwal sudah terisi, silakan pilih jam lain.");
        }

        $start = \Carbon\Carbon::parse($data['start_time']);
        $end = \Carbon\Carbon::parse($data['end_time']);
        $duration = $end->diffInHours($start);
        $totalPrice = $duration * $field->price_per_hour;

        return Booking::create([
            'user_id' => $user->id,
            'field_id' => $field->id,
            'booking_date' => $data['booking_date'],
            'start_time' => $data['start_time'],
            'end_time' => $data['end_time'],
            'total_price' => $totalPrice,
            'status' => 'pending',
        ]);
    }
}
