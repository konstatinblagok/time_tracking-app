<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
//


//Route::get('/', function () {
//   return "Hello";
//});
//Route::get('/admin', function () {
//    return view('admin.admin');
//});
//Route::get('/delivery', function () {
//    return view('admin.admin');
//});
//
//Route::get('/profiles', function () {
//    return view('admin.admin');
//});
//Route::get('/token', function () {
//    return csrf_token();
//});

Route::get('{any}', function () {
    return view('admin.admin');
})->where('any','.*');

//Route::group([ 'namespace' => '\App\Http\Controllers' ], function() {
//    Route::post('/shipping', 'UserController@postInsertShippingData');
//});
//Route::get('/shipping', function () {
//
//});
