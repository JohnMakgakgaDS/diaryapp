<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DiaryEntry;
use Illuminate\Http\Request;

class DiaryEntryController extends Controller
{
    public function index(Request $request)
    {
        // get all entries for the current user
        $entries = $request->user()->diaryEntries()->get();
        return response()->json($entries);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title'   => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $entry = $request->user()->diaryEntries()->create([
            'title'   => $request->title,
            'content' => $request->content,
        ]);

        return response()->json($entry, 201);
    }

    public function destroy(Request $request, $id)
    {
        $entry = $request->user()->diaryEntries()->findOrFail($id);
        $entry->delete();

        return response()->json(null, 204);
    }
}
