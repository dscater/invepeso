<?php

namespace Database\Factories;

use App\Models\Categoria;
use App\Models\Marca;
use App\Models\Producto;
use App\Models\UnidadMedida;
use Illuminate\Database\Eloquent\Factories\Factory;
use RuntimeException;
use Illuminate\Support\Str;

/**
 * @extends Factory<Producto>
 */
class ProductoFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        static $categorias = null;
        static $marcas = null;
        static $unidades = null;

        $categorias ??= Categoria::query()->pluck('id')->all();
        $marcas ??= Marca::query()->pluck('id')->all();
        $unidades ??= UnidadMedida::query()->pluck('id')->all();

        if (!$categorias || !$marcas || !$unidades) {
            throw new RuntimeException(
                'Debes crear categorías, marcas y unidades de medida antes de generar productos.'
            );
        }

        $precio = fake()->randomFloat(2, 10, 5000);
        return [
            'codigo' => fake()->unique()->numerify('PRD-########'),
            'nombre' => 'PRODUCTO '
                . fake('es_ES')->word()
                . ' '
                . strtoupper(Str::random(8)),
            'categoria_id' => fake()->randomElement($categorias),
            'marca_id' => fake()->randomElement($marcas),
            'unidad_medida_id' => fake()->randomElement($unidades),
            'caracteristicas' => fake()->sentence(6),
            'calidad' => fake()->randomElement([
                'EXTRA',
                'COMERCIAL',
            ]),
            'cobertura' => fake()->randomElement([
                '1.77',
                '2.00',
                '2.50',
                '3.00',
                '3.50',
                '4.00',
            ]),

            'formato' => fake()->randomElement([
                '30X30',
                '40X40',
                '42X42',
                '45X45',
                '50X50',
                '60X60',
            ]),
            'precio' => $precio,
            'precio2' => round($precio * 1.05, 2),
            'precio3' => round($precio * 1.10, 2),
            'precio4' => round($precio * 1.15, 2),
            'precio_compra' => round($precio * 0.70, 2),
            'stock_min' => fake()->numberBetween(5, 50),
            'imagen' => null,
            'activo' => 1,
            'fecha_registro' => fake()->dateTimeBetween(
                '-3 years',
                'now'
            )->format('Y-m-d'),
        ];
    }
}
