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
        <h4 class="texto">PROFORMA</h4>
        <h4 class="fecha">Expedido: {{ date('d-m-Y') }}</h4>
    </div>
    <table class="info">
        <tbody>
            <tr>
                <td><span class="bold">Código Proforma:</span> {{ $proforma->codigo_proforma }}</td>
                <td><span class="bold">Fecha:</span> {{ $proforma->fecha_hora_t }}</td>
            </tr>
            <tr>
                <td><span class="bold">Cliente:</span> {{ $proforma->cliente->nombre }}</td>
                <td><span class="bold">NIT/CI:</span> {{ $proforma->nit_ci }} </td>
            </tr>
            <tr>
                <td><span class="bold">Usuario:</span> {{ $proforma->user->full_name }}</td>
                <td><span class="bold"></td>
            </tr>
        </tbody>
    </table>
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
            @foreach ($proforma->proforma_detalles as $item)
                <tr>
                    <td>{{ $cont++ }}</td>
                    <td>{{ $item->producto->codigo }}</td>
                    <td>{{ $item->producto->nombre }}</td>
                    <td class="derecha">{{ $item->precio }}</td>
                    <td class="centreado">{{ $item->cantidad }}</td>
                    <td class="derecha">{{ $item->total_uni }}</td>
                </tr>
                @php
                    $cant_total += (float) $item->cantidad;
                @endphp
            @endforeach
            <tr>
                <td class="bold derecha" colspan="5">TOTAL BS.</td>
                <td class="bold derecha">{{ $proforma->subtotal }}</td>
            </tr>
            <tr>
                <td class="bold derecha" colspan="5">DESCUENTO BS.</td>
                <td class="bold derecha">{{ $proforma->descuento }}</td>
            </tr>
            <tr>
                <td class="bold derecha" colspan="5">TOTAL FINAL BS.</td>
                <td class="bold derecha">{{ $proforma->total }}</td>
            </tr>
        </tbody>
    </table>

    {{-- <table class="firma">
        <tbody>
            <tr>
                <td><span class="bold">Responsable:</span> {{ $proforma->user->full_name }}</td>
            </tr>
        </tbody>
    </table> --}}
</body>

</html>
