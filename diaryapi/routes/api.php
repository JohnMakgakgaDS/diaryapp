<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DiaryEntryController;





// ✅ Add this line if missing
Route::post('/register', [AuthController::class, 'register']);

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
});




Route::get('entries', [DiaryEntryController::class, 'index']);
Route::post('entries', [DiaryEntryController::class, 'store']);
Route::delete('entries/{id}', [DiaryEntryController::class, 'destroy']);



