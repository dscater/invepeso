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
        Schema::create('traspasos', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger("sucursal_origen_id");
            $table->unsignedBigInteger("almacen_origen_id");
            $table->unsignedBigInteger("sucursal_destino_id");
            $table->unsignedBigInteger("almacen_destino_id");
            $table->double("cantidad", 8, 2);
            $table->string("descripcion", 900);
            $table->date("fecha_registro");
            $table->unsignedBigInteger("user_id");
            $table->timestamps();

            $table->foreign("sucursal_origen_id")->on("sucursals")->references("id");
            $table->foreign("almacen_origen_id")->on("almacens")->references("id");
            $table->foreign("sucursal_destino_id")->on("sucursals")->references("id");
            $table->foreign("almacen_destino_id")->on("almacens")->references("id");
            $table->foreign("user_id")->on("users")->references("id");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('traspasos');
    }
};
