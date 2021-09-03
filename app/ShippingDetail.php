<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ShippingDetail extends Model
{
    protected $guarded = [];


    public function sender(){
        return $this->hasOne(User::class, 'id', 'sender_id');
    }

    public function receiver(){
        return $this->hasOne(User::class, 'id', 'sender_id' );
    }

}
