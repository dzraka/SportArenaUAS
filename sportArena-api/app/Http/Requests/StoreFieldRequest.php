<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreFieldRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->role === 'admin';
    }

    public function rules(): array
    {
        $fieldId = $this->route('field') ? $this->route('field')->id : null;

        return [
            'name' => [
                'required',
                'string',
                'max:255',
                'unique:field,name' . $fieldId
            ],
            'type' => 'required|in:futsal, badminton, basket',
            'price_per_hour' => 'required|integer|min:0',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:png,jpg,jpeg|max:2048'
        ];
    }

    public function messages(): array
    {
        return [
            'name.required' => 'field name is required',
            'name.string' => 'field name must be a string',
            'name.max' => 'field name must not exceed 255 characters',
            'name.unique' => 'field name already exists',
            'type.required' => 'field type is required',
            'type.in' => 'field type must be either futsal, badminton or basket',
            'price_per_hour.required' => 'price per hour is required',
            'price_per_hour.integer' => 'price per hour must be an integer',
            'price_per_hour.min' => 'price per hour must be at least 0',
            'description.string' => 'description must be a string',
            'image.image' => 'image must be a valid image file',
            'image.mimes' => 'image must be a file of type: png, jpg, jpeg',
            'image.max' => 'image size must not exceed 2MB'
        ];
    }
}
