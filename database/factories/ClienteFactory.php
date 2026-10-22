<?php

namespace Database\Factories;

use App\Models\Cliente;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Cliente>
 */
class ClienteFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'nombre' => fake('es_ES')->name(),
            'tipo_documento_id' => 1,
            'nro_documento' => fake()->unique()->numerify('########'),
            'complemento' => null,
            'fono' => fake()->numerify('7#######'),
            'correo' => fake()->unique()->safeEmail(),
            'fecha_registro' => fake()->dateTimeBetween(
                '-3 years',
                'now'
            )->format('Y-m-d'),
        ];
    }
}
