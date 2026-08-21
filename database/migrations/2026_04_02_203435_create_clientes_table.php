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
        Schema::create('clientes', function (Blueprint $table) {
            $table->id();
            $table->string("nombre", 255);
            $table->unsignedBigInteger("tipo_documento_id");
            $table->string("nro_documento");
            $table->string("complemento")->nullable();
            $table->string("fono", 155)->nullable();
            $table->string("correo")->nullable();
            $table->date("fecha_registro")->nullable();
            $table->integer("status")->default(1);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('clientes');
    }
};
