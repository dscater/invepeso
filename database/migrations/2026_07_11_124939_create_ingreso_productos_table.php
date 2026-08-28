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
        Schema::create('ingreso_productos', function (Blueprint $table) {
            $table->id();
            $table->string("codigo");
            $table->unsignedBigInteger("sucursal_id");
            $table->unsignedBigInteger("almacen_id");
            $table->unsignedBigInteger("tipo_ingreso_id");
            $table->unsignedBigInteger("proveedor_id");
            $table->string("descripcion");
            $table->decimal("total", 24, 2);
            $table->decimal("cancelado", 24, 2);
            $table->decimal("saldo", 24, 2);
            $table->date("fecha_registro")->nullable();
            $table->unsignedBigInteger("user_id");
            $table->integer("status")->default(1);
            $table->timestamps();

            $table->foreign("sucursal_id")->on("sucursals")->references("id");
            $table->foreign("almacen_id")->on("almacens")->references("id");
            $table->foreign("tipo_ingreso_id")->on("tipo_ingresos")->references("id");
            $table->foreign("proveedor_id")->on("proveedors")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ingreso_productos');
    }
};
