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
        Schema::create('ventas', function (Blueprint $table) {
            $table->id();
            $table->string("codigo_venta");
            $table->unsignedBigInteger("sucursal_id");
            $table->unsignedBigInteger("caja_id");
            $table->unsignedBigInteger("cliente_id");
            $table->unsignedBigInteger("tipo_documento_id")->nullable();
            $table->string("nit_ci")->nullable();
            $table->string("tipo_pago");
            $table->decimal("subtotal", 24, 2);
            $table->decimal("descuento", 24, 2);
            $table->dobule("porcentaje_descuento", 8, 2);
            $table->decimal("total", 24, 2);
            $table->decimal("cancelado", 24, 2);
            $table->decimal("saldo", 24, 2);
            $table->date("fecha_registro")->nullable();
            $table->integer("status")->default(1);
            $table->timestamps();

            $table->foreign("sucursal_id")->on("sucursals")->references("id");
            $table->foreign("caja_id")->on("cajas")->references("id");
            $table->foreign("cliente_id")->on("clientes")->references("id");
            $table->foreign("tipo_documento_id")->on("clientes")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ventas');
    }
};
