<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
//    public function run()
//    {
//        // $this->call(UserSeeder::class);
//    }

    public function run()
    {
        $user = new \App\User();
        $user->username = "Admin";
        $user->email = "admin@gmail.com";
        $user->password = bcrypt('admin');
        $user->is_admin = true;
        $user->save();
    }
}
