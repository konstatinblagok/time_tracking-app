<?php

namespace App\Http\Controllers\Admin;

use App\Profile;
use App\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use phpseclib\Crypt\Hash;

class AdminAuthController extends Controller
{
    public function login()
    {

        $credentials = request(['email', 'password']);

        if (! auth('web')->attempt($credentials)) {
            return $this->responseUnauthorized();
        }

        // Get the user data.f
        $user = auth('web')->user();
        $token = $user->createToken('Laravel Password Grant Client')->accessToken;
        return response()->json([
            'status' => 200,
            'message' => 'Authorized.',
            'access_token' => $token,
            'token_type' => 'bearer',
            'user' => [
                'id' => $user->id,
                'name' => $user->username,
            ]
        ], 200);
    }


    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getprofiles()
    {
        $arrProfile = User::all();
        return response()->json($arrProfile);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getprofile($id)
    {
        $user = User::where('id', $id)->with('checkouts')->first();

        return response()->json($user);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function postprofile($id, Request $request)
    {
        $user = User::where('id', $id)->first();
        $user->username = $request->username;
        $user->is_notification = $request->is_notification;
        $user->phone_number = $request->phone_number;
        $user->tracking_codes = $request->tracking_codes;
        $user->email = $request->email;
        $user->save();
        return response()->json($user);
    }
}
