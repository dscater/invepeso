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
        Schema::create('venta_detalles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("venta_id");
            $table->unsignedBigInteger("producto_id");
            $table->double("cantidad", 8, 2);
            $table->decimal("precio", 24, 2); // precio para el subtotal sin descuento
            $table->decimal("precio_descuento", 24, 2); // este precio se usara para el total
            $table->decimal("descuento", 24, 2); // monto descontado al precio (precio - precio_descuento)
            $table->double("porcentaje_descuento", 8, 2); // (descuento * 100) / precio
            $table->decimal("subtotal", 24, 2); // sin descuento
            $table->decimal("total", 24, 2); // con descuento
            $table->timestamps();

            $table->foreign("venta_id")->on("ventas")->references("id");
            $table->foreign("producto_id")->on("productos")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('venta_detalles');
    }
};
