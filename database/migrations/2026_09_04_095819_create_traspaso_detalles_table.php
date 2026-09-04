<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('traspaso_detalles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("traspaso_id");
            $table->unsignedBigInteger("producto_id");
            $table->double("cantidad", 8, 2);
            $table->string("observacion", 900)->nullable();
            $table->timestamps();

            $table->foreign("traspaso_id")->on("traspasos")->references("id");
            $table->foreign("producto_id")->on("productos")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('traspaso_detalles');
    }
};
