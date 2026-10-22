<?php

namespace Database\Seeders;

use App\Models\Producto;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProductosPruebaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $total = 10000;
        $lote = 500;

        for ($i = 0; $i < $total; $i += $lote) {
            Producto::factory()
                ->count(min($lote, $total - $i))
                ->create();
        }
    }
}
