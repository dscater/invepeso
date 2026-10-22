<?php

namespace Database\Seeders;

use App\Models\Cliente;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ClientesPruebaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $total = 5000;
        $lote = 500;

        for ($i = 0; $i < $total; $i += $lote) {
            Cliente::factory()
                ->count(min($lote, $total - $i))
                ->create();
        }
    }
}
