<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use RuntimeException;

class CargarArchivoService
{
    /**
     * Cargar archvos
     *
     * @param UploadedFile $file
     * @param string $ruta
     * @param string|null $nombre
     * @return string
     */
    public function cargarArchivo(
        UploadedFile $file,
        string $ruta,
        ?string $nombre = null
    ): string {

        if (!$file->isValid()) {
            throw new RuntimeException('El archivo recibido no es válido.');
        }

        if (!is_dir($ruta) && !mkdir($ruta, 0755, true) && !is_dir($ruta)) {
            throw new RuntimeException('No se pudo crear el directorio de destino.');
        }

        // Obtener la extensión original del archivo
        $extension = strtolower($file->getClientOriginalExtension());

        $nombreArchivo = ($nombre ?: (string) Str::uuid())
            . ($extension ? ".{$extension}" : '');

        $file->move($ruta, $nombreArchivo);

        return $nombreArchivo;
    }
}
