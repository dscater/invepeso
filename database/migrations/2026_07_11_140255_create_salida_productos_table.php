3<?php

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
            Schema::create('salida_productos', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger("sucursal_id");
                $table->unsignedBigInteger("almacen_id");
                $table->unsignedBigInteger("tipo_salida_id")->nullable();
                $table->double("cantidad", 8, 2);
                $table->string("descripcion", 800);
                $table->date("fecha_registro");
                $table->unsignedBigInteger("user_id");
                $table->timestamps();

                $table->foreign("sucursal_id")->on("sucursals")->references("id");
                $table->foreign("almacen_id")->on("almacens")->references("id");
                $table->foreign("tipo_salida_id")->on("tipo_salidas")->references("id");
                $table->foreign("user_id")->on("users")->references("id");
            });
        }

        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('salida_productos');
        }
    };
