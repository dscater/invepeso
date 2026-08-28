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
        Schema::create('movimiento_cajas', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("sucursal_id")->nullable();
            $table->unsignedBigInteger("almacen_id")->nullable();
            $table->string("modulo")->nullable();
            $table->unsignedBigInteger("registro_id")->nullable();
            $table->decimal("monto", 24, 2);
            $table->string("tipo_movimiento"); //INGRESO-EGRESO
            $table->string("tipo_pago"); //EFECTIVO-QR
            $table->string("descripcion", 900);
            $table->date("fecha");
            $table->time("hora");
            $table->unsignedBigInteger("user_id");
            $table->timestamps();

            $table->foreign("sucursal_id")->on("sucursals")->references("id");
            $table->foreign("almacen_id")->on("almacens")->references("id");
            $table->foreign("user_id")->on("users")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('movimiento_cajas');
    }
};
