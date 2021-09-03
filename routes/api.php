<?php



use Illuminate\Http\Request;

use Illuminate\Support\Facades\Route;



/*

|--------------------------------------------------------------------------

| API Routes

|--------------------------------------------------------------------------

|

| Here is where you can register API routes for your application. These

| routes are loaded by the RouteServiceProvider within a group which

| is assigned the "api" middleware group. Enjoy building your API!

|

*/



// Auth Endpoints





Route::group(['middleware' => ['cors', 'json.response']], function () {

    // public routes

    Route::post('/login', 'ApiAuthController@login')->name('login.api');

    Route::post('/verify-phone', 'ApiAuthController@verify')->name('verify.api');

    Route::post('/register','ApiAuthController@register')->name('register.api');

//    Route::post('/makepayment','PaymentController@makePayment')->name('payment.api');

    Route::get('/new-access-code','PaymentController@makePayment')->name('payment.api');

    Route::get('/verify/{reference?}','PaymentController@verify')->name('paymentverify.api');



    Route::middleware('auth:api')->get('/user', function (Request $request) {

        return $request->user();

    });



    Route::group(['namespace' => '\App\Http\Controllers\Admin'], function () {

        Route::post('/admin/login', 'AdminAuthController@login')->name('adminlogin.api');

        Route::get('/admin/profiles', 'AdminAuthController@getprofiles')->name('profiles.api');

        Route::get('/admin/profile/{id}', 'AdminAuthController@getprofile')->name('profile.api');

        Route::post('/admin/profile/{id}', 'AdminAuthController@postprofile')->name('profilepost.api');

    });





    Route::get('/postshipping', 'UserController@postnotishipping')->name('postshipping.api');



    Route::group(['middleware' => ['auth:api']], function (){

        Route::post('/logout', 'ApiAuthController@logout')->name('logout.api');

        Route::post('/deleteAccount', 'ApiAuthController@deleteAccount')->name('deleteAccount.api');

        Route::post('/postshipping', 'UserController@postshipping')->name('postshipping.api');

        Route::post('/searchByTracking', 'UserController@searchByTracking')->name('searchByTracking.api');

        Route::get('/shippinglist', 'UserController@getshippinglist')->name('shippinglist.api');

        Route::get('/shippinghistory', 'UserController@getshippinghistory')->name('shippinghistory.api');

        Route::get('/deleteshippinghistory', 'UserController@deleteshippinghistory')->name('deleteshippinghistory.api');

        Route::get('/getPaymentList', 'UserController@getPaymentList')->name('paymentList.api');

        Route::post('/updateShippingStatus', 'UserController@updateShippingStatus')->name('updateShippingStatus.api');

        Route::post('/saveCards', 'UserController@saveCards')->name('savePayments.api');

        Route::post('/deleteCards', 'UserController@deleteCards')->name('deletePayments.api');

        Route::post('/getUsers', 'UserController@getUsers')->name('getusers.api');

        Route::get('/getUser', 'UserController@getUser')->name('getuser.api');

        Route::post('/saveCheckout', 'CheckoutController@saveCheckout')->name('savePayments.api');

        Route::post('/clearhistory', 'UserController@clearhistory')->name('clearhistory.api');

        Route::post('/clearqueue', 'UserController@clearDeliveryQueue')->name('cleardeliveryqueue.api');

        Route::post('/updateProfile', 'ApiAuthController@updateProfile')->name('updateProfile.api');

        Route::post('/setPayAsYouGo', 'CheckoutController@setPayAsYouGo')->name('setpayasyougo.api');

    });



});





Route::group(['namespace' => '\App\Http\Controllers', 'prefix'=>'admin'], function() {

    Route::group(['namespace' => '\App\Http\Controllers\Admin', 'prefix'=>'delivery'], function() {

        Route::get('/', 'DeliveryController@getDeliveryList');

        Route::get('/{id}', 'DeliveryController@getDelivery')->name('delivery.api');

        Route::post('/{id}', 'DeliveryController@postDelivery')->name('delivery.api');

    });



    Route::group(['namespace' => '\App\Http\Controllers\Admin', 'prefix'=>'profile'], function() {

        Route::get('/', 'ProfileController@getProfileList');

        Route::post('/add', 'ProfileController@postProfilecreate');

    });



});



