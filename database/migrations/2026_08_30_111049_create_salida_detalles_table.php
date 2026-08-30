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
        Schema::create('salida_detalles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("salida_producto_id");
            $table->unsignedBigInteger("tipo_salida_id");
            $table->unsignedBigInteger("producto_id");
            $table->double("cantidad", 8, 2);
            $table->string("observacion", 900)->nullable();
            $table->timestamps();

            $table->foreign("salida_producto_id")->on("salida_productos")->references("id");
            $table->foreign("tipo_salida_id")->on("tipo_salidas")->references("id");
            $table->foreign("producto_id")->on("productos")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('salida_detalles');
    }
};
