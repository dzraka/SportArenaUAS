<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreBookingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'field_id' => 'required|exists:fields,id',
            'booking_date' => 'required|date|after_or_equal:today',
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'required|date_format:H:i|after:start_time',
            'status' => 'nullable|string',        
        ];
    }

    public function messages(): array
    {
        return [
            'field_id.required' => 'Field is required.',
            'field_id.exists' => 'Selected field does not exist.',
            'booking_date.required' => 'Booking date is required.',
            'booking_date.date' => 'Booking date must be a valid date.',
            'booking_date.after_or_equal' => 'Booking date cannot be in the past.',
            'start_time.required' => 'Start time is required.',
            'start_time.date_format' => 'Start time must be in the format HH:MM.',
            'end_time.required' => 'End time is required.',
            'end_time.date_format' => 'End time must be in the format HH:MM.',
            'end_time.after' => 'End time must be after start time.',
        ];
    }
}
