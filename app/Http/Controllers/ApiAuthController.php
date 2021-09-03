<?php



namespace App\Http\Controllers;



use App\User;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Auth;

use Illuminate\Support\Facades\DB;

use Illuminate\Support\Facades\Hash;

use Illuminate\Support\Facades\Storage;

use Illuminate\Validation\Rule;

use PHPUnit\Exception;

use Twilio\Rest\Client;

use Illuminate\Support\Facades\Validator;





class ApiAuthController extends Controller

{



    public function register(Request $request)

    {

        $user = User::where('phone_number', request('phone_number'))->first();

        if($user){

            $response = ['message' => "This number is already registered. Please log in"];

            return response($response, 422);

        }



        try {

            $data =  Validator::make($request->all(), [

                'username' => ['required', 'string', 'max:255'],

                'phone_number' => ['required', 'numeric', 'unique:users'],

                'location' => ['required', 'string'],

                'email' => ['email', 'string'],

            ]);





            if ($data->fails()) {

                $response = ['message' => $data->errors()->first()];

                return response($response, 422);

            }



            $user = User::where('phone_number', request('phone_number'))->whereNull('otp_verified')->first();

            if(!$user) {

                $user = new User();

                $user->username = request('username');

                $user->phone_number = request('phone_number');

                $user->password = Hash::make(request('password'));

                $user->location = request('location');

                $user->email = request('email');

                $user->is_notification = request('is_notification');

//               $user->avatar   =   request('avatar');

                $user->notification_token = $request->fcmToken;

                $user->avatar_name = request('avatar_name');
                //$user->otp = request('otp');

                $user->save();



                $avatar = request('avatar_name');

                if ($avatar) {

                    $folderPath = "images/";

                    $img = request('avatar');

                    $image_base64 = base64_decode($img);

                    Storage::put('profile/'.$avatar, $image_base64);

                }

            }

            $queries = DB::getQueryLog();



            if($user){

//                /* Get credentials from .env */

//                $token = getenv("TWILIO_AUTH_TOKEN");

//                $twilio_sid = getenv("TWILIO_SID");

//                $twilio_verify_sid = getenv("TWILIO_VERIFY_SID");

//                $twilio = new Client($twilio_sid, $token);

//                $twilio->verify->v2->services($twilio_verify_sid)

//                    ->verifications

//                    ->create($request->phone_number, "sms");

//                $token = $user->createToken('Laravel Password Grant Client')->accessToken;

                $response = ['user' => $user, 'message' => 'You have been successfully registered!'];

                return response($response, 200);

            }



            $response = ['message' => 'Something went Wrong'];

            return response($response, 422);

        }catch (Exception $e){

            $response = ['message' => 'Something went Wrong'];

            return response($response, 422);

        }

    }





    public function login(Request  $request){

        $user = User::where('phone_number', $request->phone_number)->first();

        if ($user) {

//            $token = getenv("TWILIO_AUTH_TOKEN");

//            $twilio_sid = getenv("TWILIO_SID");

//            $twilio_verify_sid = getenv("TWILIO_VERIFY_SID");

//            $twilio = new Client($twilio_sid, $token);

//            $twilio->verify->v2->services($twilio_verify_sid)

//                ->verifications

//                ->create($request->phone_number, "sms");

//            $token = $user->createToken('Laravel Password Grant Client')->accessToken;

            $response = [ 'user'=> $user, 'message' => 'User Logged In' ];

            return response($response, 200);

        }else{

            $response = ['user'=> $user, 'message' => 'User does not exists!' ];

            return response($response, 422);

        }



        $response = ['message' => 'Something Went wrong'];

        return response($response, 422);

    }





    public function updateProfile(Request $request)

    {

        try {

            $data = $request->validate([

                'username' => 'required|string|max:255',

                'phone_number' => 'required|numeric',

                'location' => 'required|string',

                'email' => 'email|string',

            ]);



//            if ($data->fails()) {

//                $response = ['message' => $data->errors()->all()];

//                return response($response, 422);

//            }



            DB::connection()->enableQueryLog();

                $user = Auth::user();

                $user->username = request('username');

                $user->phone_number = request('phone_number');

                $user->password = Hash::make(request('password'));

                $user->location = request('location');

                $user->email = request('email');

                $user->is_notification = request('is_notification');

//               $user->avatar   =   request('avatar');

                $user->avatar_name = request('avatar_name');

                $user->save();



                $avatar = request('avatar_name');

                if ($avatar) {

                    $folderPath = "images/";

                    $img = request('avatar');

                    $image_base64 = base64_decode($img);

                    Storage::put('profile/'.$avatar, $image_base64);

                }



            $queries = DB::getQueryLog();



            if($user){

                /* Get credentials from .env */

                $response = ['user' => $user, 'message' => 'You have been successfully registered!'];

                return response($response, 200);

            }

            $response = ['message' => 'Something went Wrong'];

            return response($response, 422);

        }catch (Exception $e){

            $response = ['message' => 'Something went Wrong'];

            return response($response, 422);

        }

    }



    public function getShippingUsers(Request  $request){

        $user = User::where('phone_number', $request->phone_number)->first();

        if ($user) {

            $response = ['user'=> $user, ];

            return response($response, 200);

        }



        $response = ['message' => 'Something Went wrong!'];

        return response($response, 422);

    }



    protected function verify(Request $request)
    {
        $data = $request->validate([
            'phone_number' => ['required', 'string'],
        ]);
        $user = User::where('phone_number', $request->phone_number)->first();
        if ($user) {
            //if($user->otp == $request->otp) {
                $token = $user->createToken('Laravel Password Grant Client')->accessToken;
                if(!$user->notification_token) {
                    $user->notification_token = $request->fcmToken;
                    $user->save();
                }
                $response = ['token' => $token, 'user'=> $user];
                return response($response, 200);
           /*  } else {
                $response = ['message' => 'Verification  Invalid'];
                return response($response, 422);
            } */
        } else {
            $response = ["message" => 'User does not exist'];
            return response($response, 422);
        }
    }



        public function logout (Request $request) {

            $user = Auth::user();

            $token = $user->token();

            $token->revoke();

            $response = ['message' => 'You have been successfully logged out!'];

            return response($response, 200);

        }



    public function deleteAccount (Request $request) {

        $user = Auth::user();

        $token = $user->token();

        $token->revoke();

        $user->delete();

        $response = ['message' => 'Your account has been successfully deleted!'];

        return response($response, 200);

    }







}

