<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\RegisterRequest;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Resources\UserResource;
use App\Services\AuthService;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    protected $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    /**
     * Get all users
     * 
     * Mendapatkan daftar semua user.
     */
    public function index() 
    {
        $users = $this->authService->getAllUsers();

        return response()->json([
            'status' => 'success',
            'message' => 'Users retrieved successfully',
            'data' => UserResource::collection($users)
        ]);
    }

    /**
     * Register new user
     * 
     * Mendaftarkan pengguna baru (Customer) ke dalam sistem.
     */
    public function register(RegisterRequest $request)
    {
        try {
            $result = $this->authService->register($request->validated());

            return response()->json([
                'status' => 'success',
                'message' => 'User registered successfully',
                'data' => $result
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Login user
     * 
     * Masuk ke aplikasi untuk mendapatkan Token Akses.
     */
    public function login(LoginRequest $request)
    {
        try {
            $result = $this->authService->login($request->validated());

            return response()->json([
                'status' => 'success',
                'message' => 'Login successfull',
                'data' => $result
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
                'errors' => $e->errors()
            ], 401);
        }
    }

    /**
     * Logout user
     * 
     * Keluar dari aplikasi dan menghapus token.
     */
    public function logout(Request $request)
    {
        $this->authService->logout($request->user());

        return response()->json([
            'status' => 'success',
            'message' => 'Logout successful'
        ]);
    }

    /**
     * Get user profile
     * 
     * Mendapatkan data diri user yang sedang login.
     */
    public function userProfile(Request $request)
    {
        return response()->json([
            'status' => 'success',
            'message' => 'User profile retrived',
            'data' => $request->user()
        ]);
    }

    /**
     * Update user profile
     * 
     * Mengupdate data diri dan foto profil
     */
    public function updateProfile(Request $request)
    {
        $request->validated([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email' . $request->user()->id,
            'phone_number' => 'required|string|min:10|max:13',
            'image' => 'nullable|image|mimes:jpg, jpeg, png|max:2048'
        ]);

        try {
            $user = $this->authService->updateProfile(
                $request->user(),
                $request->only([
                    'name',
                    'email',
                    'phone_number'
                ]),
                $request->file('image')
            );

            return response()->json([
                'status' => 'success',
                'message' => 'Profile update successfully',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
