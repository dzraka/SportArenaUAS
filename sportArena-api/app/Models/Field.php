<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Field extends Model
{
    protected $table = 'fields';
    use HasFactory;
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
