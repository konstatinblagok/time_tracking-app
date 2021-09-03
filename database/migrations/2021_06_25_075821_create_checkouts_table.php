<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCheckoutsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('checkouts', function (Blueprint $table) {
            $table->id();
            $table->integer('user_id')->nullable();
            $table->string('_cvc')->unique()->nullable();
            $table->string('expiryMonth')->nullable();
            $table->string('_type')->nullable();
            $table->string('_last4Digits')->nullable();
            $table->string('expiryYear')->nullable();
            $table->string('reference')->nullable();
            $table->string('status')->nullable();
            $table->string('method')->nullable();
            $table->string('verify')->nullable();
            $table->double('amount')->nullable();
            $table->double('tracking_codes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('checkouts');
    }
}
