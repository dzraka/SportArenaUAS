<?php

namespace App\Http\Resources;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user' => [
                'id' => $this->user_id,
                'name' => $this->user->name ?? 'unknown user',
                'phone' => $this->user->phone_number ?? '-',
            ],

            'field' => [
                'id' => $this->field_id,
                'name' => $this->field->name ?? 'unknown field',
                'type' => $this->field->type ?? '-',
                'image_url' => $this->field && $this->field->image_path
                    ? asset('storage/' . $this->field->image_path)
                    : null,
            ],

            'booking_date' => $this->booking_date,
            'start_time' => Carbon::parse($this->start_time)->format('H:i'),
            'end_time' => Carbon::parse($this->end_time)->format('H:i'),
            'total_price' => (int) $this->total_price,
            'status' => $this->status,

            'created_at' => $this->created_at->format('Y-m-d H:i'),
            'created_ago' => $this->created_at->diffForHumans(),
        ];
    }
}
