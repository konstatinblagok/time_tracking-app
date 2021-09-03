<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\ShippingDetail;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Http\Request;
use App\Http\Controllers\ApiController;

class DeliveryController extends ApiController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;


    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function getDeliveryList()
    {
        $arrShippingDetail = ShippingDetail::all();
        return response()->json($arrShippingDetail);
    }

    public function getDelivery($id)
    {
        $arrShippingDetail = ShippingDetail::where('id', $id)->with(['sender', 'receiver'])->first();
        return response()->json($arrShippingDetail);
    }

}
