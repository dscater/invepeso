<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">

    <style>
        @page {
            margin: 0;
        }

        html,
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 9px;
        }

        body {
            margin: 0;
            padding: 0;
        }

        .ticket {
            width: 72mm;
            margin: 0 auto;
            padding: 0;
        }

        /* =========================
           ENCABEZADO
        ========================= */

        .encabezado {
            width: 72mm;
            text-align: center;
        }

        .logo {
            text-align: center;
            margin-bottom: 3px;
        }

        .logo img {
            max-width: 45mm;
            max-height: 18mm;
        }

        .razon-social {
            font-size: 13px;
            font-weight: bold;
            line-height: 15px;
            text-align: center;
        }

        .titulo {
            margin-top: 3px;
            font-size: 11px;
            font-weight: bold;
            text-align: center;
        }

        .linea {
            width: 72mm;
            border-top: 1px dashed #000;
            margin-top: 6px;
            margin-bottom: 6px;
        }

        /* =========================
           DATOS
        ========================= */

        .datos {
            width: 72mm;
            font-size: 9px;
        }

        .dato {
            width: 72mm;
            margin-bottom: 3px;
            line-height: 11px;
        }

        .dato strong {
            font-weight: bold;
        }

        /* =========================
           PRODUCTOS
        ========================= */

        .productos {
            width: 72mm;
            border-collapse: collapse;
            border-spacing: 0;
        }

        .productos th {
            padding: 3px 0;
            border-top: 1px solid #000;
            border-bottom: 1px solid #000;
            font-size: 8px;
        }

        .productos td {
            padding: 3px 0;
            font-size: 8px;
            vertical-align: top;
        }

        .producto {
            width: 32mm;
            text-align: left;
        }

        .cantidad {
            width: 8mm;
            text-align: center;
        }

        .precio {
            width: 16mm;
            text-align: right;
        }

        .total {
            width: 16mm;
            text-align: right;
        }

        .nombre-producto {
            font-weight: bold;
            line-height: 10px;
            word-wrap: break-word;
        }

        .codigo-producto {
            font-size: 7px;
            line-height: 9px;
        }

        /* =========================
           TOTALES
        ========================= */

        .totales {
            width: 72mm;
            border-collapse: collapse;
        }

        .totales td {
            padding: 3px 0;
            font-size: 9px;
        }

        .label-total {
            width: 52mm;
            text-align: right;
            font-weight: bold;
            padding-right: 2mm !important;
        }

        .valor-total {
            width: 20mm;
            text-align: right;
            font-weight: bold;
        }

        .total-final td {
            border-top: 1px solid #000;
            border-bottom: 1px solid #000;
            padding-top: 5px;
            padding-bottom: 5px;
            font-size: 11px;
        }

        /* =========================
           PIE
        ========================= */

        .pie {
            width: 72mm;
            margin-top: 8px;
            text-align: center;
            font-size: 8px;
            line-height: 11px;
        }

        .gracias {
            font-weight: bold;
            font-size: 9px;
            margin-bottom: 4px;
        }

        tr {
            page-break-inside: avoid;
        }
    </style>
</head>

<body>

    @inject('configuracion', 'App\Models\Configuracion')

    @php
        $config = $configuracion->first();
        $cant_total = 0;
    @endphp

    <div class="ticket">

        {{-- ENCABEZADO --}}

        <div class="encabezado">

            @if ($config && $config->logo_b64)
                <div class="logo">
                    <img src="{{ $config->logo_b64 }}">
                </div>
            @endif

            <div class="razon-social">
                {{ $config->razon_social ?? '' }}
            </div>

            <div class="titulo">
                COMPROBANTE DE VENTA
            </div>

        </div>


        <div class="linea"></div>


        {{-- DATOS DE LA VENTA --}}

        <div class="datos">

            <div class="dato">
                <strong>N° Venta:</strong>
                {{ $venta->codigo_venta }}
            </div>

            <div class="dato">
                <strong>Fecha:</strong>
                {{ $venta->fecha_hora_t }}
            </div>

            <div class="dato">
                <strong>Cliente:</strong>
                {{ $venta->cliente->nombre ?? 'S/N' }}
            </div>

            <div class="dato">
                <strong>
                    {{ $venta->tipo_documento->nombre ?? 'NIT/CI' }}:
                </strong>
                {{ $venta->nit_ci ?? 'S/N' }}
            </div>

            <div class="dato">
                <strong>Tipo de venta:</strong>
                {{ $venta->tipo_venta }}
            </div>

            <div class="dato">
                <strong>Tipo de pago:</strong>
                {{ $venta->tipo_pago }}
            </div>

            <div class="dato">
                <strong>Usuario:</strong>
                {{ $venta->user->full_name ?? '' }}
            </div>

        </div>


        <div class="linea"></div>


        {{-- PRODUCTOS --}}

        <table class="productos">

            <thead>
                <tr>

                    <th class="producto">
                        PRODUCTO
                    </th>

                    <th class="cantidad">
                        CANT
                    </th>

                    <th class="precio">
                        C/U
                    </th>

                    <th class="total">
                        TOTAL
                    </th>

                </tr>
            </thead>

            <tbody>

                @foreach ($venta->venta_detalles as $item)
                    @php
                        $cant_total += (float) $item->cantidad;
                    @endphp

                    <tr>

                        <td class="producto">

                            <div class="nombre-producto">
                                {{ $item->producto->nombre }}
                            </div>

                            <div class="codigo-producto">
                                Cód: {{ $item->producto->codigo }}
                            </div>

                        </td>

                        <td class="cantidad">
                            {{ $item->cantidad }}
                        </td>

                        <td class="precio">
                            {{ number_format((float) $item->precio, 2) }}
                        </td>

                        <td class="total">
                            {{ number_format((float) $item->total_uni, 2) }}
                        </td>

                    </tr>
                @endforeach

            </tbody>

        </table>


        <div class="linea"></div>


        {{-- TOTALES --}}

        <table class="totales">

            <tr>

                <td class="label-total">
                    CANTIDAD:
                </td>

                <td class="valor-total">
                    {{ $cant_total }}
                </td>

            </tr>

            <tr>

                <td class="label-total">
                    SUBTOTAL:
                </td>

                <td class="valor-total">
                    Bs. {{ number_format((float) $venta->subtotal, 2) }}
                </td>

            </tr>

            <tr>

                <td class="label-total">
                    DESCUENTO:
                </td>

                <td class="valor-total">
                    Bs. {{ number_format((float) $venta->descuento, 2) }}
                </td>

            </tr>

            <tr class="total-final">

                <td class="label-total">
                    TOTAL:
                </td>

                <td class="valor-total">
                    Bs. {{ number_format((float) $venta->total, 2) }}
                </td>

            </tr>

            @if ($venta->tipo_venta == 'CRÉDITO')
                <tr>

                    <td class="label-total">
                        CANCELADO:
                    </td>

                    <td class="valor-total">
                        Bs. {{ number_format((float) $venta->cancelado, 2) }}
                    </td>

                </tr>

                <tr>

                    <td class="label-total">
                        SALDO:
                    </td>

                    <td class="valor-total">
                        Bs. {{ number_format((float) $venta->saldo, 2) }}
                    </td>

                </tr>
            @endif

        </table>


        <div class="linea"></div>


        {{-- PIE --}}

        <div class="pie">

            <div class="gracias">
                ¡Gracias por su compra!
            </div>

            <div>
                {{ $config->razon_social ?? '' }}
            </div>

            <div style="margin-top: 4px;">
                Atendido por:
                {{ $venta->user->full_name ?? '' }}
            </div>

        </div>

    </div>

</body>

</html>
