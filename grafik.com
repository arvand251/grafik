<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard Keuangan Bulanan</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',Arial,sans-serif}
body{background:#f8fafc;color:#111827;padding:20px}
.container{max-width:1200px;margin:0 auto}
header{display:flex;justify-content:space-between;align-items:center;background:white;padding:20px 24px;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06);margin-bottom:20px;flex-wrap:wrap;gap:12px}
header h1{font-size:24px}
header h1 span{color:#16A34A}
header p{color:#6b7280;font-size:13px}
.btn{border:none;cursor:pointer;padding:10px 16px;border-radius:10px;font-weight:600}
.btn-green{background:#16A34A;color:white}
.btn-red{background:#DC2626;color:white}
.btn-gray{background:#e5e7eb}
.btn-sm{padding:6px 10px;font-size:12px;border-radius:8px}
.cards{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:20px}
.card{background:white;padding:20px;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06);border-top:4px solid #ddd}
.card.green{border-top-color:#16A34A}.card.red{border-top-color:#DC2626}.card.blue{border-top-color:#2563eb}.card.orange{border-top-color:#f59e0b}
.card small{color:#6b7280}.card h2{font-size:26px;margin:8px 0 4px}.card p{font-size:12px;color:#6b7280}
.grid{display:grid;grid-template-columns:2fr 1fr;gap:16px;margin-bottom:20px}
.grid2{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:20px}
.box{background:white;padding:20px;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,.06)}
.box h3{margin-bottom:14px;font-size:17px}
.chart-wrap{position:relative;height:300px}
.chart-wrap.small{height:260px}
form{display:grid;grid-template-columns:1fr 1fr;gap:12px}
form input,form select{width:100%;padding:11px;border:1px solid #d1d5db;border-radius:10px;outline:none;font-size:14px}
form input:focus,form select:focus{border-color:#16A34A}
.full{grid-column:1/3}
.toolbar{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:14px}
.toolbar input,.toolbar select{flex:1;min-width:160px;padding:10px;border:1px solid #d1d5db;border-radius:10px}
table{width:100%;border-collapse:collapse;font-size:14px}
th{text-align:left;padding:10px;background:#f3f4f6;border-bottom:1px solid #e5e7eb}
td{padding:11px 10px;border-bottom:1px solid #f3f4f6;vertical-align:middle}
.badge{padding:4px 10px;border-radius:20px;font-size:12px;font-weight:700}
.badge-in{background:#dcfce7;color:#166534}.badge-out{background:#fee2e2;color:#991b1b}
.empty{text-align:center;padding:30px;color:#9ca3af}
@media(max-width:900px){.cards{grid-template-columns:repeat(2,1fr)}.grid,.grid2{grid-template-columns:1fr}form{grid-template-columns:1fr}.full{grid-column:1}}
</style>
</head>
<body>
<div class="container">
<header>
<div><h1>💰 Dashboard <span>Keuangan</span> Bulanan</h1><p>Kelola penghasilan & pengeluaran dalam satu tempat • IDR Rupiah</p></div>
<div><button class="btn btn-gray" onclick="resetData()">Reset Data Contoh</button> <button class="btn btn-red" onclick="hapusSemua()">Hapus Semua</button></div>
</header>

<div class="cards">
<div class="card green"><small>Total Penghasilan</small><h2 id="totalIn">Rp 0</h2><p id="countIn">0 transaksi masuk</p></div>
<div class="card red"><small>Total Pengeluaran</small><h2 id="totalOut">Rp 0</h2><p id="countOut">0 transaksi keluar</p></div>
<div class="card blue"><small>Total Saldo</small><h2 id="totalSaldo">Rp 0</h2><p id="saldoInfo">Penghasilan - Pengeluaran</p></div>
<div class="card orange"><small>Total Transaksi</small><h2 id="totalTrans">0</h2><p id="bulanAktif">12 bulan data</p></div>
</div>

<div class="grid">
<div class="box"><h3>📊 Grafik Batang Penghasilan vs Pengeluaran (Jan - Des)</h3><div class="chart-wrap"><canvas id="barChart"></canvas></div></div>
<div class="box">
<h3>➕ Tambah / Edit Transaksi</h3>
<form id="formTrans">
<input type="hidden" id="editId">
<input id="nama" placeholder="Nama transaksi, contoh: Gaji Bulanan" required class="full">
<select id="jenis"><option value="Penghasilan">Penghasilan</option><option value="Pengeluaran">Pengeluaran</option></select>
<input id="nominal" type="number" placeholder="Nominal Rupiah, contoh: 5000000" required min="1">
<input id="tanggal" type="date" required>
<select id="kategori">
<option>Gaji</option><option>Bisnis</option><option>Freelance</option><option>Bonus</option><option>Makanan</option><option>Transportasi</option><option>Belanja</option><option>Tagihan</option><option>Hiburan</option><option>Kesehatan</option><option>Tabungan</option><option>Lainnya</option>
</select>
<button type="submit" class="btn btn-green full" id="btnSimpan">+ Simpan Transaksi</button>
<button type="button" class="btn btn-gray full" onclick="batalEdit()" id="btnBatal" style="display:none">Batal Edit</button>
</form>
<p style="font-size:12px;color:#6b7280;margin-top:10px">Data otomatis tersimpan di browser (LocalStorage). Aman di-refresh.</p>
</div>
</div>

<div class="grid2">
<div class="box"><h3>📈 Perkembangan Saldo & Keuangan</h3><div class="chart-wrap small"><canvas id="lineChart"></canvas></div></div>
<div class="box"><h3>🥧 Perbandingan Penghasilan vs Pengeluaran</h3><div class="chart-wrap small"><canvas id="pieChart"></canvas></div></div>
</div>

<div class="box">
<h3>📋 Daftar Transaksi</h3>
<div class="toolbar">
<input id="cari" placeholder="🔍 Cari transaksi..." oninput="render()">
<select id="filterBulan" onchange="render()"><option value="">Semua Bulan</option><option value="01">Januari</option><option value="02">Februari</option><option value="03">Maret</option><option value="04">April</option><option value="05">Mei</option><option value="06">Juni</option><option value="07">Juli</option><option value="08">Agustus</option><option value="09">September</option><option value="10">Oktober</option><option value="11">November</option><option value="12">Desember</option></select>
<select id="filterJenis" onchange="render()"><option value="">Semua Jenis</option><option value="Penghasilan">Penghasilan</option><option value="Pengeluaran">Pengeluaran</option></select>
</div>
<div style="overflow-x:auto">
<table><thead><tr><th>Tanggal</th><th>Nama</th><th>Kategori</th><th>Jenis</th><th>Nominal</th><th>Aksi</th></tr></thead><tbody id="tbody"></tbody></table>
</div>
<div id="emptyMsg" class="empty" style="display:none">Belum ada transaksi. Tambahkan di atas.</div>
</div>
<p style="text-align:center;color:#9ca3af;font-size:12px;margin:20px 0">Dashboard Keuangan Bulanan • Dibuat untuk GitHub Pages • Data tersimpan lokal di perangkat Anda</p>
</div>

<script>
const bulanLabel=["Januari","Februari","Maret","April","Mei","Juni","Juli","Agustus","September","Oktober","November","Desember"];
const bulanShort=["Jan","Feb","Mar","Apr","Mei","Jun","Jul","Agu","Sep","Okt","Nov","Des"];
function dataContoh(){
  const d=[]; let id=1;
  const sample=[
    ["2026-01-05","Gaji Januari","Penghasilan",7500000,"Gaji"],["2026-01-08","Freelance Desain","Penghasilan",1200000,"Freelance"],["2026-01-10","Belanja Bulanan","Pengeluaran",850000,"Belanja"],["2026-01-15","Bayar Kos","Pengeluaran",1200000,"Tagihan"],["2026-01-20","Makan & Jajan","Pengeluaran",650000,"Makanan"],
    ["2026-02-05","Gaji Februari","Penghasilan",7500000,"Gaji"],["2026-02-12","Bonus Proyek","Penghasilan",900000,"Bonus"],["2026-02-10","Belanja Bulanan","Pengeluaran",900000,"Belanja"],["2026-02-15","Bayar Kos","Pengeluaran",1200000,"Tagihan"],["2026-02-18","Transportasi","Pengeluaran",350000,"Transportasi"],
    ["2026-03-05","Gaji Maret","Penghasilan",7800000,"Gaji"],["2026-03-10","Jualan Online","Penghasilan",1500000,"Bisnis"],["2026-03-11","Belanja Bulanan","Pengeluaran",950000,"Belanja"],["2026-03-15","Bayar Kos","Pengeluaran",1200000,"Tagihan"],["2026-03-22","Hiburan","Pengeluaran",400000,"Hiburan"],
    ["2026-04-05","Gaji April","Penghasilan",7800000,"Gaji"],["2026-04-09","Freelance","Penghasilan",800000,"Freelance"],["2026-04-12","Belanja","Pengeluaran",800000,"Belanja"],["2026-04-15","Bayar Kos","Pengeluaran",1200000,"Tagihan"],["2026-04-20","Kesehatan","Pengeluaran",500000,"Kesehatan"],
    ["2026-05-05","Gaji Mei","Penghasilan",8000000,"Gaji"],["2026-05-14","Bonus THR","Penghasilan",3000000,"Bonus"],["2026-05-12","Belanja","Pengeluaran",1100000,"Belanja"],["2026-05-15","Bayar Kos","Pengeluaran",1200000,"Tagihan"],["2026-05-25","Mudik","Pengeluaran",1500000,"Transportasi"],
    ["2026-06-05","Gaji Juni","Penghasilan",8000000,"Gaji"],["2026-06-10","Jualan Online","Penghasilan",1800000,"Bisnis"],["2026-06-11","Belanja","Pengeluaran",900000,"Belanja"],["2026-06-15","Bayar Kos","Pengeluaran",1200000,"Tagihan"],["2026-06-20","Makan","Pengeluaran",700000,"Makanan"],
    ["2026-07-05","Gaji Juli","Penghasilan",8200000,"Gaji"],["2026-07-12","Freelance","Penghasilan",1100000,"Freelance"],["2026-07-11","Belanja","Pengeluaran",950000,"Belanja"],["2026-07-15","Bayar Kos","Pengeluaran",1250000,"Tagihan"],["2026-07-18","Hiburan","Pengeluaran",450000,"Hiburan"],
    ["2026-08-05","Gaji Agustus","Penghasilan",8500000,"Gaji"],["2026-08-08","Bonus","Penghasilan",1000000,"Bonus"],["2026-08-11","Belanja","Pengeluaran",1000000,"Belanja"],["2026-08-15","Bayar Kos","Pengeluaran",1250000,"Tagihan"],["2026-08-20","Transport","Pengeluaran",400000,"Transportasi"],
    ["2026-09-05","Gaji September","Penghasilan",8500000,"Gaji"],["2026-09-10","Jualan Online","Penghasilan",2000000,"Bisnis"],["2026-09-11","Belanja","Pengeluaran",980000,"Belanja"],["2026-09-15","Bayar Kos","Pengeluaran",1250000,"Tagihan"],["2026-09-19","Kesehatan","Pengeluaran",600000,"Kesehatan"],
    ["2026-10-05","Gaji Oktober","Penghasilan",8800000,"Gaji"],["2026-10-09","Freelance","Penghasilan",1300000,"Freelance"],["2026-10-11","Belanja","Pengeluaran",1050000,"Belanja"],["2026-10-15","Bayar Kos","Pengeluaran",1300000,"Tagihan"],["2026-10-22","Makan","Pengeluaran",750000,"Makanan"],
    ["2026-11-05","Gaji November","Penghasilan",8800000,"Gaji"],["2026-11-12","Bonus","Penghasilan",1500000,"Bonus"],["2026-11-11","Belanja","Pengeluaran",1100000,"Belanja"],["2026-11-15","Bayar Kos","Pengeluaran",1300000,"Tagihan"],["2026-11-20","Hiburan","Pengeluaran",500000,"Hiburan"],
    ["2026-12-05","Gaji Desember","Penghasilan",9200000,"Gaji"],["2026-12-10","Bonus Akhir Tahun","Penghasilan",4000000,"Bonus"],["2026-12-11","Belanja","Pengeluaran",1500000,"Belanja"],["2026-12-15","Bayar Kos","Pengeluaran",1300000,"Tagihan"],["2026-12-24","Liburan","Pengeluaran",2000000,"Hiburan"]
  ];
  sample.forEach(s=>{d.push({id:id++,tanggal:s[0],nama:s[1],jenis:s[2],nominal:s[3],kategori:s[4]})});
  return d;
}
let transaksi=JSON.parse(localStorage.getItem("keuangan_data")||"null");
if(!transaksi){transaksi=dataContoh(); localStorage.setItem("keuangan_data",JSON.stringify(transaksi));}
function formatRp(n){return "Rp "+n.toLocaleString("id-ID");}
function save(){localStorage.setItem("keuangan_data",JSON.stringify(transaksi));}
function hitungBulanan(){
  let inc=Array(12).fill(0), out=Array(12).fill(0);
  transaksi.forEach(t=>{let m=parseInt(t.tanggal.split("-")[1])-1; if(t.jenis==="Penghasilan") inc[m]+=t.nominal; else out[m]+=t.nominal;});
  return {inc,out};
}
let barChart,lineChart,pieChart;
function initCharts(){
  const {inc,out}=hitungBulanan();
  let saldoKumulatif=0; let saldoArr=inc.map((v,i)=>{saldoKumulatif+=v-out[i]; return saldoKumulatif;});
  const ctxBar=document.getElementById("barChart");
  barChart=new Chart(ctxBar,{type:"bar",data:{labels:bulanShort,datasets:[{label:"Penghasilan",data:inc,backgroundColor:"#16A34A",borderRadius:6},{label:"Pengeluaran",data:out,backgroundColor:"#DC2626",borderRadius:6}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{position:"top"},tooltip:{callbacks:{label:c=>c.dataset.label+": "+formatRp(c.raw)}}},scales:{y:{beginAtZero:true,ticks:{callback:v=>"Rp "+(v/1000000)+"jt"}}}}});
  // plugin label nominal di atas batang
  Chart.register({id:"datalabels",afterDatasetsDraw(chart){const {ctx}=chart; chart.data.datasets.forEach((ds,i)=>{const meta=chart.getDatasetMeta(i); meta.data.forEach((bar,idx)=>{const v=ds.data[idx]; if(v>0){ctx.fillStyle="#111827";ctx.font="bold 10px Arial";ctx.textAlign="center";ctx.fillText((v/1000000).toFixed(1)+"jt",bar.x,bar.y-6);}});}}});
  lineChart=new Chart(document.getElementById("lineChart"),{type:"line",data:{labels:bulanShort,datasets:[{label:"Penghasilan",data:inc,borderColor:"#16A34A",backgroundColor:"rgba(22,163,74,.12)",fill:true,tension:.4},{label:"Pengeluaran",data:out,borderColor:"#DC2626",backgroundColor:"rgba(220,38,38,.08)",fill:true,tension:.4},{label:"Saldo Kumulatif",data:saldoArr,borderColor:"#2563eb",borderDash:[6,4],fill:false,tension:.4}]},options:{responsive:true,maintainAspectRatio:false,plugins:{tooltip:{callbacks:{label:c=>c.dataset.label+": "+formatRp(c.raw)}}},scales:{y:{beginAtZero:true,ticks:{callback:v=>"Rp "+(v/1000000)+"jt"}}}}});
  pieChart=new Chart(document.getElementById("pieChart"),{type:"doughnut",data:{labels:["Penghasilan","Pengeluaran"],datasets:[{data:[inc.reduce((a,b)=>a+b,0),out.reduce((a,b)=>a+b,0)],backgroundColor:["#16A34A","#DC2626"],borderWidth:2,borderColor:"#fff"}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{position:"bottom"},tooltip:{callbacks:{label:c=>c.label+": "+formatRp(c.raw)}}}}});
}
function updateCharts(){
  const {inc,out}=hitungBulanan();
  let s=0; let saldoArr=inc.map((v,i)=>{s+=v-out[i]; return s;});
  barChart.data.datasets[0].data=inc; barChart.data.datasets[1].data=out; barChart.update();
  lineChart.data.datasets[0].data=inc; lineChart.data.datasets[1].data=out; lineChart.data.datasets[2].data=saldoArr; lineChart.update();
  pieChart.data.datasets[0].data=[inc.reduce((a,b)=>a+b,0),out.reduce((a,b)=>a+b,0)]; pieChart.update();
}
function render(){
  const cari=document.getElementById("cari").value.toLowerCase();
  const fb=document.getElementById("filterBulan").value;
  const fj=document.getElementById("filterJenis").value;
  let filtered=transaksi.filter(t=> (t.nama.toLowerCase().includes(cari)||t.kategori.toLowerCase().includes(cari)) && (!fb||t.tanggal.split("-")[1]===fb) && (!fj||t.jenis===fj) );
  filtered.sort((a,b)=>b.tanggal.localeCompare(a.tanggal));
  let totalIn=transaksi.filter(t=>t.jenis==="Penghasilan").reduce((a,b)=>a+b.nominal,0);
  let totalOut=transaksi.filter(t=>t.jenis==="Pengeluaran").reduce((a,b)=>a+b.nominal,0);
  document.getElementById("totalIn").textContent=formatRp(totalIn);
  document.getElementById("totalOut").textContent=formatRp(totalOut);
  document.getElementById("totalSaldo").textContent=formatRp(totalIn-totalOut);
  document.getElementById("totalTrans").textContent=transaksi.length;
  document.getElementById("countIn").textContent=transaksi.filter(t=>t.jenis==="Penghasilan").length+" transaksi masuk";
  document.getElementById("countOut").textContent=transaksi.filter(t=>t.jenis==="Pengeluaran").length+" transaksi keluar";
  const tbody=document.getElementById("tbody"); tbody.innerHTML="";
  document.getElementById("emptyMsg").style.display=filtered.length?"none":"block";
  filtered.forEach(t=>{
    const tr=document.createElement("tr");
    tr.innerHTML=`<td>${t.tanggal}</td><td><b>${t.nama}</b></td><td>${t.kategori}</td><td><span class="badge ${t.jenis==="Penghasilan"?"badge-in":"badge-out"}">${t.jenis}</span></td><td style="font-weight:700;color:${t.jenis==="Penghasilan"?"#16A34A":"#DC2626"}">${t.jenis==="Penghasilan"?"+":"-"} ${formatRp(t.nominal)}</td><td><button class="btn btn-green btn-sm" onclick="editTrans(${t.id})">Edit</button> <button class="btn btn-red btn-sm" onclick="hapusTrans(${t.id})">Hapus</button></td>`;
    tbody.appendChild(tr);
  });
  updateCharts();
}
document.getElementById("formTrans").addEventListener("submit",e=>{
  e.preventDefault();
  const idVal=document.getElementById("editId").value;
  const data={tanggal:document.getElementById("tanggal").value,nama:document.getElementById("nama").value,jenis:document.getElementById("jenis").value,nominal:parseInt(document.getElementById("nominal").value),kategori:document.getElementById("kategori").value};
  if(!data.tanggal||!data.nama||!data.nominal) return alert("Lengkapi semua field!");
  if(idVal){let idx=transaksi.findIndex(t=>t.id==idVal); transaksi[idx]={...transaksi[idx],...data};} else {data.id=Date.now(); transaksi.push(data);}
  save(); render(); e.target.reset(); document.getElementById("editId").value=""; document.getElementById("btnSimpan").textContent="+ Simpan Transaksi"; document.getElementById("btnBatal").style.display="none";
  document.getElementById("tanggal").value=new Date().toISOString().slice(0,10);
});
function editTrans(id){let t=transaksi.find(x=>x.id===id); document.getElementById("editId").value=t.id; document.getElementById("nama").value=t.nama; document.getElementById("jenis").value=t.jenis; document.getElementById("nominal").value=t.nominal; document.getElementById("tanggal").value=t.tanggal; document.getElementById("kategori").value=t.kategori; document.getElementById("btnSimpan").textContent="💾 Update Transaksi"; document.getElementById("btnBatal").style.display="block"; window.scrollTo({top:0,behavior:"smooth"});}
function batalEdit(){document.getElementById("formTrans").reset(); document.getElementById("editId").value=""; document.getElementById("btnSimpan").textContent="+ Simpan Transaksi"; document.getElementById("btnBatal").style.display="none";}
function hapusTrans(id){if(confirm("Hapus transaksi ini?")){transaksi=transaksi.filter(t=>t.id!==id); save(); render();}}
function hapusSemua(){if(confirm("Hapus SEMUA transaksi?")){transaksi=[]; save(); render();}}
function resetData(){if(confirm("Kembalikan ke data contoh 12 bulan?")){transaksi=dataContoh(); save(); render();}}
document.getElementById("tanggal").value=new Date().toISOString().slice(0,10);
initCharts(); render();
</script>
</body>
</html>
