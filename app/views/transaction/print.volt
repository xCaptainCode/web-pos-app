<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Receipt - {{ order.order_no }}</title>
    <style>
        @page { size: 80mm auto; margin: 0; }
        body { font-family: 'Courier New', Courier, monospace; width: 72mm; margin: 0 auto; padding: 10px; font-size: 12px; line-height: 1.4; color: #000; }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .header { margin-bottom: 15px; border-bottom: 1px dashed #000; padding-bottom: 10px; }
        .info { margin-bottom: 10px; font-size: 11px; }
        .items { width: 100%; border-collapse: collapse; margin-bottom: 10px; }
        .items td { padding: 2px 0; vertical-align: top; }
        .totals { border-top: 1px dashed #000; padding-top: 5px; }
        .footer { margin-top: 20px; border-top: 1px dashed #000; padding-top: 10px; font-size: 10px; }
        .status-stamp { 
            position: absolute; top: 150px; left: 50%; transform: translateX(-50%) rotate(-15deg);
            border: 4px solid #ccc; color: #ccc; padding: 10px 20px; font-weight: bold; font-size: 24px;
            opacity: 0.3; z-index: -1; text-transform: uppercase; letter-spacing: 2px;
        }
        .bold { font-weight: bold; }
        @media print {
            body { width: 100%; margin: 0; padding: 5mm; }
            .no-print { display: none; }
        }
    </style>
</head>
<body onload="window.print();">
    <div class="header text-center">
        <h2 style="margin: 0; font-size: 18px;">CAPTAIN POS</h2>
        <p style="margin: 5px 0;">Jl. Perjuangan No. 88, Jakarta<br>Telp: (021) 555-0123</p>
    </div>

    {% if order.status != 'paid' %}
    <div class="status-stamp">{{ order.status }}</div>
    {% endif %}

    <div class="info">
        <div style="display: flex; justify-content: space-between;">
            <span>No: <span class="bold">{{ order.order_no }}</span></span>
            <span>{{ Helpers.formatDateTime(order.created_at, 'd/m/y H:i') }}</span>
        </div>
        <div>Kasir: {{ order.cashier_name }}</div>
        <div>Cust: {{ order.customer_name }}</div>
    </div>

    <table class="items">
        {% for item in items %}
        <tr>
            <td colspan="2">{{ item.product_name }}</td>
        </tr>
        <tr>
            <td width="60%">{{ item.quantity }} x {{ Helpers.number(item.unit_price) }}</td>
            <td class="text-right">Rp {{ Helpers.number(item.subtotal) }}</td>
        </tr>
        {% endfor %}
    </table>

    <div class="totals">
        <div style="display: flex; justify-content: space-between;">
            <span>Subtotal</span>
            <span>Rp {{ Helpers.number(order.subtotal) }}</span>
        </div>
        {% if order.discount > 0 %}
        <div style="display: flex; justify-content: space-between;">
            <span>Diskon</span>
            <span>-Rp {{ Helpers.number(order.discount) }}</span>
        </div>
        {% endif %}
        {% if order.tax > 0 %}
        <div style="display: flex; justify-content: space-between;">
            <span>Pajak</span>
            <span>Rp {{ Helpers.number(order.tax) }}</span>
        </div>
        {% endif %}
        <div style="display: flex; justify-content: space-between; font-weight: bold; font-size: 14px; margin-top: 5px; border-top: 1px solid #000; padding-top: 5px;">
            <span>TOTAL</span>
            <span>Rp {{ Helpers.number(order.total) }}</span>
        </div>
    </div>

    <div class="footer text-center">
        <p class="bold">TERIMA KASIH</p>
        <p>Barang yang sudah dibeli tidak dapat ditukar atau dikembalikan.</p>
        <p style="font-size: 8px; margin-top: 15px; color: #666;">Software by Captain POS v1.0</p>
    </div>

    <div class="no-print text-center" style="margin-top: 20px;">
        <button onclick="window.close();" style="padding: 10px 20px; cursor: pointer;">Tutup Halaman</button>
    </div>
</body>
</html>
