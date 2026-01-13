<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Request\StoreFieldRequest;
use App\Http\Resources\FieldResource;
use App\Services\FieldService;

class FieldController extends Controller
{
    protected $fieldService;

    public function __construct(FieldService $fieldService)
    {
        $this->fieldService = $fieldService;
    }

    public function index()
    {
        $fields = $this->fieldService->getAllFields();

        return response()->json([
            'status' => 'success',
            'message' => 'Fields retrieved successfully',
            'data' => FieldResource::collection($fields)
        ]);
    }

    public function store(StoreFieldRequest $request)
    {
        try {
            $field = $this->fieldService->createField($request->validate());

            return response()->json([
                'status' => 'success',
                'message' => 'Field created successfully',
                'data' => new FieldResource($field)
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'data' => null
            ], 400);
        }
    }

    public function update(StoreFieldRequest $request, $id)
    {
        try {
            $updated = $this->fieldService->updateField($id, $request->validated());

            return response()->json([
                'status' => 'success',
                'message' => 'Field update successfully',
                'data' => new FieldResource($updated)
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'data' => null
            ], 400);
        }
    }

    public function destry($id)
    {
        try {
            $this->fieldService->deleteField($id);

            return response()->json([
                'status' => 'success',
                'message' => 'Field deleted successfully',
                'data' => null
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'data' => null
            ], 400);
        }
    }

    public function show($id)
    {
        try {
            $field = $this->fieldService->getFieldById($id);

            return response()->json([
                'status' => 'success',
                'message' => 'Field retrieved successfully',
                'data' => new FieldResource($field)
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Field not found',
                'data' => null
            ], 404);
        }
    }

    public function getFutsalFields()
    {
        $fields = $this->fieldService->getFieldsByType('futsal');

        return response()->json([
            'status' => 'success',
            'message' => 'Futsal fields retrieved successfully',
            'data' => FieldResource::collection($fields)
        ]);
    }

    public function getBadmintonFields()
    {
        $fields = $this->fieldService->getFieldsByType('badminton');

        return response()->json([
            'status' => 'success',
            'message' => 'Badminton fields retrieved successfully',
            'data' => FieldResource::collection($fields)
        ]);
    }

    public function getBasketFields()
    {
        $fields = $this->fieldService->getFieldsByType('basket');

        return response()->json([
            'status' => 'success',
            'message' => 'Basket fields retrieved successfully',
            'data' => FieldResource::collection($fields)
        ]);
    }
}
