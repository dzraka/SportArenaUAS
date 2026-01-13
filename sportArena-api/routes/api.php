<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\FieldController;
use App\Http\Controllers\Api\BookingController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'userProfile']);
    Route::post('/profile', [AuthController::class, 'updateProfile']);

    Route::get('/fields', [FieldController::class, 'index']);
    Route::get('/fields/{id}', [FieldController::class, 'show']);
    Route::get('/fields/type/futsal', [FieldController::class, 'getFutsalFields']);
    Route::get('/fields/type/badminton', [FieldController::class, 'getBadmintonFields']);
    Route::get('/fields/type/basket', [FieldController::class, 'getBasketFields']);

    Route::post('/bookings', [BookingController::class, 'store']);
    Route::get('/user-bookings', [BookingController::class, 'userBookings']);
    Route::get('/bookings/{id}', [BookingController::class, 'show']);
    Route::post('/bookings/{id}/cancel', [BookingController::class, 'cancel']);

    Route::prefix('admin')->group(function () {
        Route::post('/fields', [FieldController::class, 'store']);
        Route::post('/fields/{id}', [FieldController::class, 'update']);
        Route::delete('/fields/{id}', [FieldController::class, 'destroy']);

        Route::get('/bookings', [BookingController::class, 'index']);
        Route::post('/bookings/{id}/status', [BookingController::class, 'update']);
    });
});
