<?php

namespace Database\Factories;

use App\Models\Model;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

/**
 * @extends Factory<Model>
 */
class UsuarioFactory extends Factory
{

    protected $model = User::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $faker = fake('es_ES');

        // Crear directorio si no existe
        $directorio = public_path('imgs/users');

        if (!File::exists($directorio)) {
            File::makeDirectory($directorio, 0755, true);
        }

        // Generar nombre único para la imagen
        $foto = Str::uuid() . '.jpg';

        // Descargar imagen aleatoria
        //  IMAGENES LIVIANAS
        // $contenido = file_get_contents(
        //     'https://i.pravatar.cc/300?img=' . rand(1, 70)
        // );

        //  IMAGENES PESADAS
        $contenido = file_get_contents(
            'https://picsum.photos/1200/1200'
        );

        File::put($directorio . '/' . $foto, $contenido);

        // Determinar tipo de usuario aleatoriamente
        $tipo = $faker->randomElement([
            'ADMINISTRACIÓN',
            'EMPLEADO'
        ]);

        // Asignar rol y sucursal según el tipo
        if ($tipo === 'ADMINISTRACIÓN') {
            $role_id = 2;
            $sucursal_id = null;
            $sucursal_todos = 1;
        } else {
            $role_id = 3;
            $sucursal_id = $faker->randomElement([1, 2, 3]);
            $sucursal_todos = 0;
        }

        return [
            'usuario' => $faker->unique()->userName(),
            'nombre' => $faker->firstName(),
            'paterno' => $faker->lastName(),
            'materno' => $faker->lastName(),
            'ci' => (string) $faker->unique()->numerify('########'),
            'ci_exp' => $faker->randomElement([
                'LP',
                'CB',
                'SC',
                'OR',
                'PT',
                'CH',
                'TJ',
                'BE',
                'PD'
            ]),
            'dir' => $faker->address(),
            'correo' => $faker->unique()->safeEmail(),
            'fono' => $faker->numerify('7#######'),
            'password' => bcrypt('admin'),
            'foto' => $foto,

            // Tipo de usuario
            'tipo' => $tipo,

            // Rol
            'role_id' => $role_id,

            'acceso' => 1,

            // Sucursal
            'sucursal_id' => $sucursal_id,
            'sucursal_todos' => $sucursal_todos,

            'fecha_registro' => now()->format('Y-m-d'),
            'status' => 1,
        ];
    }
}
