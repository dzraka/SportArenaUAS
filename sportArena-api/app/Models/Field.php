<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Field extends Model
{
    protected $fillable = [
        'name',
        'type',
        'price_per_hour',
        'description',
        'image_path',
        'is_available'
    ];

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}
