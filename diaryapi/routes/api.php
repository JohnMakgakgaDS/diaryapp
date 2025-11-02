<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\DiaryEntryController;








Route::middleware('auth:sanctum')->group(function() {
    Route::get('/diaries', [DiaryController::class, 'index']);
    Route::post('/diaries', [DiaryController::class, 'store']);
    Route::get('/diaries/{id}', [DiaryController::class, 'show']);
    Route::put('/diaries/{id}', [DiaryController::class, 'update']);
    Route::delete('/diaries/{id}', [DiaryController::class, 'destroy']);
});



