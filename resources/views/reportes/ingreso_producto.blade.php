<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>OrdenDeCompra</title>
    <style type="text/css">
        * {
            font-family: sans-serif;
        }

        @page {
            margin-top: 1cm;
            margin-bottom: 1cm;
            margin-left: 1.5cm;
            margin-right: 1cm;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            page-break-before: avoid;
        }

        table thead tr th,
        tbody tr td {
            padding: 3px;
            word-wrap: break-word;
        }

        table thead tr th {
            font-size: 9pt;
        }

        table tbody tr td {
            font-size: 7.5pt;
        }


        .encabezado {
            width: 100%;
        }

        .logo img {
            position: absolute;
            height: 90px;
            top: -20px;
            left: 0px;
        }

        h2.titulo {
            width: 650px;
            margin: auto;
            margin-top: 0PX;
            text-align: center;
            font-size: 14pt;
        }

        .texto {
            width: 450px;
            text-align: center;
            margin: auto;
            font-weight: bold;
            font-size: 1.1em;
        }

        .fecha {
            width: 250px;
            text-align: center;
            margin: auto;
            font-weight: normal;
            font-size: 0.85em;
        }

        .total {
            text-align: right;
            padding-right: 15px;
            font-weight: bold;
        }

        table {
            width: 100%;
        }

        table thead {
            background: rgb(236, 236, 236)
        }

        tr {
            page-break-inside: avoid !important;
        }

        .centreado {
            padding-left: 0px;
            text-align: center;
        }

        .datos {
            margin-left: 15px;
            border-top: solid 1px;
            border-collapse: collapse;
            width: 250px;
        }

        .txt {
            font-weight: bold;
            text-align: right;
            padding-right: 5px;
        }

        .txt_center {
            font-weight: bold;
            text-align: center;
        }

        .b_top {
            border-top: solid 1px black;
        }

        .gray {
            background: rgb(202, 202, 202);
        }

        .bg-principal {
            background: #153f59;
            color: white;
        }

        .img_celda img {
            width: 45px;
        }

        .derecha {
            text-align: right;
        }

        .info {
            width: 100%;
            margin-top: 20px;
        }

        .bold {
            font-weight: bold;
        }

        .firma {
            width: 37%;
            margin: auto;
            margin-top: 100px;
        }

        .firma td {
            text-align: center;
            border-top: dashed 1px black;
        }
    </style>
</head>

<body>
    @inject('configuracion', 'App\Models\Configuracion')
    <div class="encabezado">
        <div class="logo">
            <img src="{{ $configuracion->first()->logo_b64 }}">
        </div>
        <h2 class="titulo">
            {{ $configuracion->first()->razon_social }}
        </h2>
        <h4 class="texto">ORDEN DE COMPRA</h4>
        <h4 class="fecha">Expedido: {{ date('d-m-Y') }}</h4>
    </div>
    <table class="info">
        <tbody>
            <tr>
                <td><span class="bold">Código Orden:</span> {{ $ingreso_producto->codigo }}</td>
                <td><span class="bold">Fecha:</span> {{ $ingreso_producto->fecha_registro_t }}</td>
            </tr>
            <tr>
                <td><span class="bold">Proveedor:</span> {{ $ingreso_producto->proveedor->nombre }}</td>
                <td><span class="bold">Almacén - Sucursal:</span> {{ $ingreso_producto->almacen->nombre }} -
                    {{ $ingreso_producto->sucursal->nombre }}</td>
            </tr>
            <tr>
                <td><span class="bold">Estado:</span> {{ $ingreso_producto->estado_ingreso }}</td>
                <td><span class="bold">Descripción:</span> {{ $ingreso_producto->descripcion }}</td>
            </tr>
        </tbody>
    </table>
    <h4 class="fecha" style="margin-top: 20px;">PRODUCTOS SOLICITADOS</h4>
    <table border="1">
        <thead class="bg-principal">
            <tr>
                <th width="3%">N°</th>
                <th>CÓDIGO</th>
                <th>PRODUCTO</th>
                <th class="derecha">C/U BS.</th>
                <th class="centreado">CANT.</th>
                <th class="derecha">TOTAL BS.</th>
            </tr>
        </thead>
        <tbody>
            @php
                $cont = 1;
                $cant_total = 0;
            @endphp
            @foreach ($ingreso_producto->ingreso_detalles as $item)
                <tr>
                    <td>{{ $cont++ }}</td>
                    <td>{{ $item->producto->codigo }}</td>
                    <td>{{ $item->producto->nombre }}</td>
                    <td class="derecha">{{ $item->costo }}</td>
                    <td class="centreado">{{ $item->cantidad }}</td>
                    <td class="derecha">{{ $item->subtotal }}</td>
                </tr>
                @php
                    $cant_total += (float) $item->cantidad;
                @endphp
            @endforeach
            <tr>
                <td class="bold derecha" colspan="4">TOTAL</td>
                <td class="bold centreado">{{ $cant_total }}</td>
                <td class="bold derecha">{{ $ingreso_producto->total }}</td>
            </tr>
            <tr>
                <td class="bold derecha" colspan="4">CANCELADO</td>
                <td></td>
                <td class="bold derecha">{{ $ingreso_producto->cancelado }}</td>
            </tr>
            <tr>
                <td class="bold derecha" colspan="4">SALDO</td>
                <td></td>
                <td class="bold derecha">{{ $ingreso_producto->saldo }}</td>
            </tr>
        </tbody>
    </table>

    <table class="firma">
        <tbody>
            <tr>
                <td><span class="bold">Responsable:</span> {{ $ingreso_producto->user->full_name }}</td>
            </tr>
        </tbody>
    </table>
</body>

</html>
