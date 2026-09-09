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
        Schema::create('venta_cobros', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("sucursal_id");
            $table->unsignedBigInteger("almacen_id");
            $table->unsignedBigInteger("venta_id");
            $table->unsignedBigInteger("cliente_id");
            $table->string("tipo_pago");
            $table->decimal("monto", 24, 2);
            $table->decimal("saldo", 24, 2);
            $table->date("fecha");
            $table->time("hora");
            $table->unsignedBigInteger("user_id");
            $table->timestamps();

            $table->foreign("sucursal_id")->on("sucursals")->references("id");
            $table->foreign("almacen_id")->on("almacens")->references("id");
            $table->foreign("venta_id")->on("ventas")->references("id");
            $table->foreign("cliente_id")->on("clientes")->references("id");
            $table->foreign("user_id")->on("users")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('venta_cobros');
    }
};
