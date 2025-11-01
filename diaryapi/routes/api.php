<?php


use App\Http\Controllers\Api\DiaryEntryController;

Route::get('entries', [DiaryEntryController::class, 'index']);
Route::post('entries', [DiaryEntryController::class, 'store']);
Route::delete('entries/{id}', [DiaryEntryController::class, 'destroy']);
