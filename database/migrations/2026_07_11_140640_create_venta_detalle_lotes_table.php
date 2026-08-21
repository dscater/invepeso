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
        Schema::create('venta_detalle_lotes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("venta_id");
            $table->unsignedBigInteger("venta_detalle_id");
            $table->unsignedBigInteger("ingreso_detalle_id");
            $table->unsignedBigInteger("producto_id");
            $table->double("cantidad", 8, 2);
            $table->decimal("precio_lote", 24, 2); //PRECIO CON EL QUE SE ADQUIRIO
            $table->decimal("precio_venta", 24, 2); //PRECIO CON EL QUE SE VENDIO
            $table->decimal("precio_venta_final", 24, 2); //PRECIO CON EL QUE SE VENDIO (si la venta tiene un descuento del total de venta)
            /**
             * SUBTOTAL  VENTA: 200
             * DESCUENTO      :  10
             * TOTAL     VENTA: 190
             * porcentaje      : 5%
             * 
             * precio_venta_final = precio_venta - (precio_venta * porcentaje)
             */
            $table->decimal("ganancia", 24, 2); // resultado precio_venta_final - precio_lote
            $table->timestamps();

            $table->foreign("venta_id")->on("ventas")->references("id");
            $table->foreign("venta_detalle_id")->on("venta_detalles")->references("id");
            $table->foreign("ingreso_detalle_id")->on("ingreso_detalles")->references("id");
            $table->foreign("producto_id")->on("productos")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('venta_detalle_lotes');
    }
};
