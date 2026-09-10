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
            $table->decimal("precio", 24, 2); // precio original(ingresado)
            $table->decimal("descuento_uni", 24, 2); // descuento unitario
            $table->double("porcen_du", 8, 2); // porcentaje descuento unitario
            $table->decimal("descuento_total", 24, 2); // descuento obtenido desde el descuento TOTAL de la venta
            $table->double("porcen_dt", 8, 2); // porcentaje descuento total
            $table->decimal("precio_final", 24, 2); // precio final obtenido despues de los descuentos
            $table->decimal("total", 24, 2); // total registrado = cantidad * precio_final | para calcular ingreso bruto
            $table->decimal("total_uni", 24, 2); // total por fila sin tomar en cuenta descuento del total para mostrar = cantidad * (precio - descuento_uni)
            $table->integer("status")->default(1);
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
