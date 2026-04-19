<style>
   .avg-time {
      font-family: Oxanium;
      font-size: 50px;
      font-weight: bold;
      text-align: center;
   }

   .table tbody td,
   .table thead th {
      font-family: Oxanium;
   }

   .dashboard-card-body {
      max-height: calc(100vh - 260px);
      overflow-y: auto;
   }

   span {
      width: 60px;
   }

   .chart-wrapper {
      position: relative;
      height: 250px;
      display: flex;
      align-items: center;
      justify-content: center;
   }

   .chart-center-label {
      position: absolute;
      text-align: center;
      pointer-events: none;
   }

   .chart-center-label .total-num {
      font-family: Oxanium;
      font-size: 20px;
      font-weight: bold;
      line-height: 1;
   }

   .chart-center-label .total-text {
      font-family: Oxanium;
      font-size: 11px;
      color: #6c757d;
   }
</style>

<div class="content-header">
   <div class="row mb-2">
      <div class="col-sm-6">
         <h1 class="m-0">Dashboard</h1>
      </div>
      <div class="col-sm-6 small">
         <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="#">Home</a></li>
            <li class="breadcrumb-item active">Dashboard</li>
         </ol>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12">
         <div class="avg-time" id="time">--:--:--</div>
      </div>
   </div>
</div>

<!-- Waktu -->
<script>
   const WEEK = ["Ahad", "Senin", "Selasa", "Rabu", "Kamis", "Jum'at", "Sabtu"];

   function updateTime() {
      document.getElementById("time").innerText =
         zeroPadding(new Date().getHours(), 2) + ":" +
         zeroPadding(new Date().getMinutes(), 2) + ":" +
         zeroPadding(new Date().getSeconds(), 2);
   }
   updateTime();
   setInterval(updateTime, 1000);

   function zeroPadding(num, digit) {
      return String(num).padStart(digit, '0');
   }
</script>