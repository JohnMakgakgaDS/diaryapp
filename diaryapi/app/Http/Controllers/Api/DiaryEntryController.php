<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DiaryEntry;
use Illuminate\Http\Request;

class DiaryEntryController extends Controller
{
    // Get all entries for a specific date
    public function index(Request $request)
    {
        $date = $request->query('date');
        if (!$date) {
            return response()->json(['error' => 'Date is required'], 400);
        }

        $entries = DiaryEntry::where('date', $date)->get();
        return response()->json($entries);
    }

    // Store a new diary entry
    public function store(Request $request)
    {
        $request->validate([
            'date' => 'required|date',
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'type' => 'required|string|in:todo,event',
        ]);

        $entry = DiaryEntry::create($request->all());
        return response()->json($entry, 201);
    }

    // Delete an entry
    public function destroy($id)
    {
        $entry = DiaryEntry::find($id);
        if (!$entry) {
            return response()->json(['message' => 'Not found'], 404);
        }
        $entry->delete();
        return response()->json(['message' => 'Deleted successfully'], 200);
    }
}
