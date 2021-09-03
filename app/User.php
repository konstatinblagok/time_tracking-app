<?php

namespace App;

use App\Notifications\OTPNotification;
use Illuminate\Contracts\Auth\MustVerifyEmail;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Mail;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $appends = array('card');

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public  function OTP(){
        return Cache::get($this->OTPKey());
    }

    public function OTPKey(){
        return "OTP_for_{$this->id}";
    }

    public function cacheTheOTP(){
        $OTP = rand(1000, 9999);
        Cache::put([$this->OTPKey() => $OTP], now()->addSecond(60));
    }

    public function sendOTP($via){
        $otp = $this->cacheTheOTP();
        try {
            $this->notify(new OTPNotification);
        }catch (\Exception $e){
            dd($e);
        }
//        if($via == "via_sms"){
//
//        }else{
//            Mail::to("adityachouhan81@gmail.com")->send(new OTPMail($this->cacheTheOTP()));
//        }
    }

    public function routeNotificationForKarix()
    {
        return $this->phone;
    }



    public function getCardAttribute()
    {
        $cardDetails = Payment::where('user_id', $this->id)->first();
        return $cardDetails;
    }

    public function checkouts(){
        return $this->hasMany(Checkout::class, 'user_id', 'id');
    }
}
