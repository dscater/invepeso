<?php

namespace App\Providers;

use Illuminate\Database\Events\QueryExecuted;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Vite;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Vite::prefetch(concurrency: 3);
        // DB::listen(function (QueryExecuted $query) {
        //     if (
        //         str_contains(strtolower($query->sql), 'users')
        //         && $query->time >= 10
        //     ) {
        //         Log::warning('Consulta lenta a users', [
        //             'sql' => $query->sql,
        //             'duracion_ms' => $query->time,
        //             'bindings' => $query->bindings,
        //         ]);
        //     }
        // });
        // DB::listen(function (QueryExecuted $query) {
        //     if (str_contains(strtolower($query->sql), '`users`')) {
        //         Log::info('MEDICION USERS', [
        //             'sql_ms' => $query->time,
        //             'conexion' => $query->connectionName,
        //             'sql' => $query->sql,
        //         ]);
        //     }
        // });
        // DB::listen(function (QueryExecuted $query) {
        //     if (str_contains(strtolower($query->sql), 'from `users`')) {
        //         Log::info('MEDICION USERS', [
        //             'sql_ms' => $query->time,
        //             'sql' => $query->sql,
        //         ]);
        //     }
        // });
    }
}
