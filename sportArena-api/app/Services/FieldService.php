<?php

namespace App\Services;

use App\Models\Field;

class FieldService
{
    public function getAllFields()
    {
        return Field::where('is_available', true)->get();
    }

    public function createField(array $data)
    {
        if (isset($data['image'])) {
            $path = $data['image']->store('fields', 'public');
            $data['image_path'] = $path;
        }

        return Field::create($data);
    }
}
