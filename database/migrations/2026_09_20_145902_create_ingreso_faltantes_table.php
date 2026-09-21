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
        Schema::create('ingreso_faltantes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("ingreso_producto_id");
            $table->unsignedBigInteger("ingreso_detalle_id");
            $table->double("cantidad", 8, 2);
            $table->unsignedBigInteger("user_id");
            $table->date("fecha");
            $table->time("hora");
            $table->timestamps();

            $table->foreign("ingreso_producto_id")->on("ingreso_productos")->references("id");
            $table->foreign("ingreso_detalle_id")->on("ingreso_detalles")->references("id");
            $table->foreign("user_id")->on("users")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ingreso_faltantes');
    }
};
