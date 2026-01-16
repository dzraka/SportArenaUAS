<?php

namespace App\Services;

use App\Models\Field;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use InvalidArgumentException;

class FieldService
{
    public function getAllFields()
    {
        return Field::orderBy('name', 'asc')->get();
    }

    public function getFieldsByType($type)
    {
        return Field::where('type', $type)->orderBy('name', 'asc')->get();
    }

    public function getFieldById($id)
    {
        return Field::findOrFail($id);
    }

    public function createField(array $data)
    {
        $exist = Field::where('name', $data['name'])->exists();

        if ($exist) {
            throw new InvalidArgumentException('Field with the same name alredy exist');
        }

        if (isset($data['image']) && $data['image']) {
            $path = $data['image']->store('fields', 'public');
            $data['image_path'] = $path;
        } else {
            $data['image_path'] = null;
        }

        return DB::transaction(function () use ($data) {
            return Field::create($data);
        });
    }

    public function updateField($id, array $data)
    {
        $field = Field::findOrFail($id);

        $exist = Field::where('name', $data['name'])
            ->where('id', '!=', $id)
            ->exists();

        if ($exist) {
            throw new InvalidArgumentException('Field name alredy taken by another field');
        }

        if (isset($data['image'])) {
            if ($field->image_path) {
                Storage::disk('public')->delete($field->image_path);
            }
            $path = $data['image']->store('fields', 'public');
            $data['image_path'] = $path;
        }

        return DB::transaction(function () use ($field, $data) {
            $field->update($data);
            return $field;
        });
    }

    public function deleteField($id)
    {
        $field = Field::findOrFail($id);
        if ($field->bookings()->exists()) {
            throw new InvalidArgumentException('Cannot delete field with existing bookings');
        }

        return DB::transaction(function () use ($field) {
            if ($field->image_path) {
                Storage::disk('public')->delete($field->image_path);
            }
            return $field->delete();
        });
    }
}
