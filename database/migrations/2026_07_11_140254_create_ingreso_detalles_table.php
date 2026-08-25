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
        Schema::create('ingreso_detalles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("ingreso_producto_id");
            $table->unsignedBigInteger("tipo_ingreso_id");
            $table->unsignedBigInteger("producto_id");
            $table->double("cantidad", 8, 2);
            $table->double("verificado", 8, 2)->nullable();
            $table->integer("faltantes")->nullable();
            $table->double("repuesto", 8, 2)->default(0);
            $table->string("observacion", 900)->nullable();
            $table->double("cantidad_fisica", 8, 2)->nullable(); // Cantidad que ingresa al stock
            $table->decimal("costo", 24, 2);
            $table->decimal("subtotal", 24, 2);
            $table->timestamps();

            $table->foreign("ingreso_producto_id")->on("ingreso_productos")->references("id");
            $table->foreign("tipo_ingreso_id")->on("tipo_ingresos")->references("id");
            $table->foreign("producto_id")->on("productos")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ingreso_detalles');
    }
};
