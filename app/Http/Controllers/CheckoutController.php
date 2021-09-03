<?php

namespace App\Http\Controllers;

use App\Checkout;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use PHPUnit\Exception;

class CheckoutController extends Controller
{
    /**
     * Display a listing of the resource.saveCheckout
     *
     * @return \Illuminate\Http\Response
     */
    public function saveCheckout(Request  $request)
    {
        try{
        $user = Auth::user();
        $trackingCodes = $user->tracking_codes??0;
        if($user){
        DB::beginTransaction();
        $objCheckout                =   new Checkout();
        $objCheckout->user_id       =   $user->id;
        $objCheckout->_cvc          =   $request->_cvc;
        $objCheckout->card_number       =   $request->card_number;
        $objCheckout->expiryMonth   =   $request->expiryMonth;
        $objCheckout->expiryYear    =   $request->expiryYear;
        $objCheckout->_type         =   $request->_type;
        $objCheckout->_last4Digits  =   $request->_last4Digits;
        $objCheckout->reference     =   $request->reference;
        $objCheckout->status        =   $request->status;
        $objCheckout->method        =   $request->payment_method;
        $objCheckout->verify        =   $request->verify;
        $objCheckout->amount        =   $request->amount;
        $objCheckout->tracking_codes=   $request->tracking_codes;
        $objCheckout->save();
        $user->tracking_codes = $trackingCodes + $request->tracking_codes;
        $user->payasyougo = null;
        $user->save();
        DB::commit();
            $response = ['card_checkout'=> $objCheckout, 'user' => $user, 'message' => 'You are account has been credited successfully!'];
            return response($response, 200);
        }
            $response = ['message' => 'Something Went Wrong'];
            return response($response, 200);
        }catch(Exception $e){
            $response = ['message' => $e->getMessage()];
            return response($response, 200);
        }
    }

    public function getCheckoutList(){
        $checkoutList =  Checkout::all();
        return response()->json($checkoutList);
    }


    public function setPayAsYouGo(Request $request){
        $user = Auth::user();
        $user->payasyougo = $request->amount;
        $user->save();
        $response = ['message' => ''];
        return response($response, 200);
    }



}
