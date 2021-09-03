<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Profile;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;

use App\Http\Controllers\ApiController;

class ProfileController extends ApiController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;


    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function getProfileList()
    {
        $arrProfile = Profile::all();
        return response()->json(['objProfile' => $arrProfile, ]);
    }

    public function postProfilecreate(Request $request)
    {
//       dd($request->all());
        $objProfile = new Profile();
        $objProfile->username = $request->name;
        $objProfile->email = $request->email;
        $objProfile->password = $request->password;
        $objProfile->phone_number = $request->phone_number;
        $objProfile->card_number = $request->card_number;
        $objProfile->location = $request->location;
//        $objProfile->avatar       = $request->file('image')->store('profile');

        if ($request->get('image')) {
            $image = $request->get('image');
            $name  = time() . '.' . explode('/', explode(':', substr($image, 0, strpos($image, ';')))[1])[1];
            // To create directory to store file
            if (!Storage::exists('profile')) {
                Storage::makeDirectory('profile', 0777);
            }
            Image::make($request->get('image'))->save(public_path(('profile/profile/') . $name));
            $objProfile->avatar = 'profile/' . $name;
            $objProfile->avatar_name = $name;
        }
//        $objProfile->avatar = $request->image;
//        $objProfile->avatar_name = $request->image;
        $objProfile->save();
        return response()->json(['status' => 200, 'message' => 'success']);

    }
}
