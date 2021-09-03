<?php



namespace App\Http\Controllers;







use App\Payment;

use App\User;

use Illuminate\Database\Eloquent\Model;

use Illuminate\Support\Facades\Auth;

use Illuminate\Support\Facades\DB;

use Validator;



use App\ShippingDetail;

use Illuminate\Http\Request;



class UserController extends Controller

{



    public function index(){

        return view('admin');

    }



    public function postshipping(Request $request){

        try {

//            $data = $request->validate([

//                'receiver_name' => ['required', 'string', 'max:255'],

//                'phone_number' => ['required', 'numeric', 'unique:users'],

//                'location' => ['required', 'string'],

//                'ETA' => ['required', 'string'],

//                'note' => ['string'],

//                'longitude' => ['string'],

//                'latitude' => ['string'],

//            ]);

//

//            if ($data->fails()) {

//                $response = ['message' => $data->errors()->all()];

//                return response($response, 422);

//            }



            $sender = Auth::user();

            $sender = User::where('id', $sender->id)->first();

            $receiver = User::where('phone_number', $request->receivernumber)->first();

            if($sender && $sender->tracking_codes > 0){

                $sender->tracking_codes = $sender->tracking_codes - 1;

                $sender->save();

            }else{

                $response = ['message' => 'Please purchase tracking codes.'];

                return response($response, 422);

            }



            $objShippingData = new ShippingDetail();

            $objShippingData->sender_id = $sender->id;

            $objShippingData->receiver_id = $receiver->id;

            $objShippingData->receiver_name = $request->receivername;

            $objShippingData->phone_number = $request->receivernumber;

            $objShippingData->location = $request->receiverlocation;

            $objShippingData->note = $request->note;

            $objShippingData->ETA = $request->eta;

            $objShippingData->tracking_id = 'track-'.time();

            $objShippingData->longitude = $request->longitude;

            $objShippingData->latitude = $request->latitude;

            $objShippingData->status = 0;

            $objShippingData->save();



            if($receiver->is_notification)

            {

                $url = 'https://fcm.googleapis.com/fcm/send';

                $fields = array(

                    'registration_ids' => array(

                    $receiver->notification_token

                    ),

                "notification" => [

                    "title" => 'Order Placed',

                    "body" => $objShippingData->tracking_id,

                ],

                "data" => [

                    "title" => 'Order Placed',

                    "body" => $objShippingData->tracking_id,

                    "click_action" => "FLUTTER_NOTIFICATION_CLICK",

                    "sound" => "default",

                    "screen" => "/recevertrackingpage",

                    "trackingId" => $objShippingData->tracking_id

                    ]

                );

                $api_key = env("FIREBASE_SERVER_KEY");

                $headers = array(

                    'Content-Type:application/json',

                    'Authorization:key=' . $api_key

                    );

                $ch = curl_init();

                curl_setopt($ch, CURLOPT_URL, $url);

                curl_setopt($ch, CURLOPT_POST, true);

                curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

                $result = curl_exec($ch);

                if ($result === FALSE) {

                    die('FCM Send Error: ' . curl_error($ch));

                }

            curl_close($ch);

//                        return $result;

}





            if($sender->is_notification)

            {

                $url = 'https://fcm.googleapis.com/fcm/send';

                $fields = array(

                    'registration_ids' => array(

                        $sender->notification_token

                    ),

                    "notification" => [

                        "title" => 'Successfully tracking sent.',

                    ],

                    "data" => [

                        "title" => 'Order Placed',

                        "body" => $objShippingData->tracking_id,

                        "click_action" => "FLUTTER_NOTIFICATION_CLICK",

                        "sound" => "default",

                        "screen" => "/recevertrackingpage",

                        "trackingId" => $objShippingData->tracking_id

                    ]

                );

                $api_key = env("FIREBASE_SERVER_KEY");

                $headers = array(

                    'Content-Type:application/json',

                    'Authorization:key=' . $api_key

                );

                $ch = curl_init();

                curl_setopt($ch, CURLOPT_URL, $url);

                curl_setopt($ch, CURLOPT_POST, true);

                curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

                $result = curl_exec($ch);

                if ($result === FALSE) {

                    die('FCM Send Error: ' . curl_error($ch));

                }

                curl_close($ch);

//                        return $result;

            }



            $response = ['shippingData' => $objShippingData, 'message' => 'You have been successfully created shipping!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }



    }





    public function postnotishipping(Request $request){

        try {



            $sender = Auth::user();

            $sender = User::where('id', 2)->first();

            $receiver = User::where('id', 2)->first();

            if($sender){

                $sender->tracking_codes = $sender->tracking_codes - 1;

                $sender->save();

            }



            $objShippingData = ShippingDetail::where('id', 1)->first();



            if($receiver->is_notification)

            {

                $url = 'https://fcm.googleapis.com/fcm/send';

                $fields = array(

                    'registration_ids' => array(

                        $receiver->notification_token

                    ),

                    "notification" => [

                        "title" => 'Order Placed',

                        "body" => $objShippingData->tracking_id,

                    ],

                    "data" => [

                        "title" => 'Order Placed',

                        "body" => $objShippingData->tracking_id,

                        "click_action" => "FLUTTER_NOTIFICATION_CLICK",

                        "sound" => "default",

                        "screen" => "/recevertrackingpage",

                        "trackingId" => $objShippingData->tracking_id

                    ]

                );

                $api_key = env("FIREBASE_SERVER_KEY");

                $headers = array(

                    'Content-Type:application/json',

                    'Authorization:key=' . $api_key

                );

                $ch = curl_init();

                curl_setopt($ch, CURLOPT_URL, $url);

                curl_setopt($ch, CURLOPT_POST, true);

                curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

                $result = curl_exec($ch);

                if ($result === FALSE) {

                    die('FCM Send Error: ' . curl_error($ch));

                }

                curl_close($ch);

//                        return $result;

            }





            $response = ['shippingData' => $objShippingData, 'message' => 'You have been successfully created shipping!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }



    }







    public function getUsers(Request  $request){

        try {

            $user = Auth::user();

//            $users = User::where('id', '!=', $user->id)->Where('phone_number', 'like', '%' . $request->phone_number . '%')->get();

            $users = User::Where('phone_number', 'like', '%' . $request->phone_number . '%')->get();

            $response = ['users' => $users];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public function deleteUser(){

        try {

            $user = Auth::user();

           $user->delete();

            $response = ['message' => 'Account Deleted Successfully' ];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }





    public function getUser(Request  $request){

        try {

            $user = Auth::user();

            $response = ['users' => $user];

            return response($response, 200);

        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function getshippinglist(){

        try {

        $user = Auth::user();

        $user = User::where('id', $user->id)->first();

            $objShippingData = ShippingDetail::where('sender_id', $user->id)->get();

            $response = ['shippingData' => $objShippingData, 'message' => 'You have been successfully created shipping!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function getshippinghistory(){

        try {

            $user = Auth::user();

            $user = User::where('id', $user->id)->first();

            $objShippingData = ShippingDetail::where('receiver_id', $user->id)->get();

            $response = ['shippingData' => $objShippingData, 'message' => 'You have been successfully created shipping!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function clearhistory(){

        try {

            $user = Auth::user();

            $user = User::where('id', $user->id)->first();

            $objShippingData = ShippingDetail::where('receiver_id', $user->id)->delete();

            $response = ['message' => 'You have been successfully deleted history!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function deleteshippinghistory(){

        try {

            $user = Auth::user();

            $user = User::where('id', $user->id)->first();

            $objShippingData = ShippingDetail::where('receiver_id', $user->id)->delete();

            $response = ['shippingData' => $objShippingData, 'message' => 'You have been successfully created shipping!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function saveCards(Request $request){



        try {

            $user = Auth::user();

            $objPayment = Payment::where('user_id', $user->id)->first();

            if(!$objPayment){

                $objPayment = new Payment();

            }

            $objPayment->user_id = $user->id;

            $objPayment->card_no = $request->card_no;

            $objPayment->expiry_month =  $request->expiry_month;

            $objPayment->expiry_year = $request->expiry_year;

            $objPayment->cvv = $request->cvv;

            $objPayment->save();



            if($request->amount){

             $user->payasyougo = $request->amount;

             $user->save();

            }else{

                $user->payasyougo = null;

                $user->save();

            }

            $response = ['card_details'=>$objPayment, 'message' => 'You account has been credited successfully!'];

            return response($response, 200);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }

    public  function deleteCards(Request $request){

        try {
            $card_no = $request->card_no;
            if($card_no == '') {
                $response = ['status' => 0 ,'message' => "Please enter card number"];
                return response($response, 422);
            }

            $user = Auth::user();
            $objPayment = Payment::where('user_id', $user->id)->where('card_no', $card_no)->first();
            if(!$objPayment){
                $response = ['status' => 0 ,'message' => "Wrong card data entered"];
                return response($response, 422);
            }

            Payment::where('user_id', $user->id)->where('card_no', $card_no)->delete();

            // Update according saveCards code : START 
            $user->payasyougo = null;
            $user->save();
            // Update according saveCards code : END

            $response = ['status' => 1 ,'message' => 'Your card has been deleted successfully!'];
            return response($response, 200);

        } catch (\Exception $objException) {
            $response = ['status' => 0 ,'message' => $objException->getMessage()];
            return response($response, 422);
        }
    }



    public  function searchByTracking(Request  $request){

        try {

        $user = Auth::user();

            $user = User::where('id', $user->id)->first();



            if($user){

                DB::connection()->enableQueryLog();

            $objShippingData = ShippingDetail::where('tracking_id', $request->tracking_id)->where('receiver_id', $user->id)->first();

//            $objShippingData = ShippingDetail::where('tracking_id', 'track-1624161999')->where('receiver_id', 41)->first();

                $queries = DB::getQueryLog();

//                $response = ['shippingData' => $queries];

            $response = ['shippingData' => $objShippingData];

            return response($response, 200);

            }else{

                $response = ['message' => "Wrong data entered"];

                return response($response, 422);

            }



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function updateShippingStatus(Request  $request){

        try {

        $user = Auth::user();

            $shippingDetails = ShippingDetail::where('phone_number', $request->phone_number)->where('tracking_id',$request->tracking_code)->first();

            $shippingDetails->status=1;

            $receiver = User::where('id', $shippingDetails->receiver_id)->first();

            $shippingDetails->save();





            if($shippingDetails->save() && $receiver->is_notification) {

                    $url = 'https://fcm.googleapis.com/fcm/send';

                    $fields = array(

                    'registration_ids' => array(

                        $receiver->notification_token

                    ),

                    "notification" => [

                        "title" => 'Hello , Your Package is here',

                    ],

                    "data" => [

                        "click_action" => "FLUTTER_NOTIFICATION_CLICK",

                        "sound" => "default",

                        "status" => "done",

                    ]

                    );

                    $api_key = env("FIREBASE_SERVER_KEY");

                    $headers = array(

                        'Content-Type:application/json',

                        'Authorization:key=' . $api_key

                    );

                    $ch = curl_init();

                    curl_setopt($ch, CURLOPT_URL, $url);

                    curl_setopt($ch, CURLOPT_POST, true);

                    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

                    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

                    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

                    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

                    $result = curl_exec($ch);

                    if ($result === FALSE) {

                        $response = ['message' => "Something Went Wrong"];

                        return response($response, 422);

                    }

                    curl_close($ch);

                $response = ['message' => 'You have been successfully  updated shipping!'];

                return response($response, 200);



            }



            $response = ['message' => 'Something  went wrong!'];

            return response($response, 422);



        } catch (\Exception $objException) {

            $response = ['message' => $objException->getMessage()];

            return response($response, 422);

        }

    }



    public  function clearDeliveryQueue(Request  $request){

        try {

            $user = Auth::user();

            ShippingDetail::where('sender_id', $user->id)->where('status',1)->delete();

            $response = ['message' => 'You have been successfully cleared shipping!'];

            return response($response, 200);

        } catch (\Exception $objException) {

            $response = ['message' => "Something went wrong! Try again later"];

            return response($response, 422);

        }

    }



}





