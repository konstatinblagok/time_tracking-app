<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class PaymentController extends Controller
{

public  function makePayment(Request $request){
    $url = "https://api.paystack.co/transaction/initialize";
    $fields = [
        'email' => "customer@email.com",
        'amount' => "20000"
    ];
    $fields_string = http_build_query($fields);
    //open connection
    $ch = curl_init();

    //set the url, number of POST vars, POST data
    curl_setopt($ch,CURLOPT_URL, $url);
    curl_setopt($ch,CURLOPT_POST, true);
    curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        "Authorization: Bearer sk_test_5e6915c7b80d91b01b2631503a55a99e8b941640",
        "Cache-Control: no-cache",
    ));

    //So that curl_exec returns the contents of the cURL; rather than echoing it
    curl_setopt($ch,CURLOPT_RETURNTRANSFER, true);

    //execute post
    $result = curl_exec($ch);

    return $result;
//    $resultReference = json_decode($result, true);



}

public function verify(Request  $request, $reference){
        $curlverify = curl_init();

        curl_setopt_array($curlverify, array(
            CURLOPT_URL => "https://api.paystack.co/transaction/verify/".$reference,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => array(
                "Authorization: Bearer sk_test_5e6915c7b80d91b01b2631503a55a99e8b941640",
                "Cache-Control: no-cache",
            ),
        ));

        $response = curl_exec($curlverify);
        dd($response);
        $err = curl_error($curlverify);
        curl_close($curlverify);

        if ($err) {
            echo "cURL Error #:" . $err;
        } else {
            echo $response;
        }
        echo $result;
    }
}

