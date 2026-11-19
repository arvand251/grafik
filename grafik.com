
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

# 1. DATA KEUANGAN
data = {
    "Bulan": [
        "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
        "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ],
    "Pemasukan": [
        5000000, 6000000, 5500000, 7000000,
        6500000, 7500000, 8000000, 7200000,
        8500000, 9000000, 8800000, 10000000
    ],
    "Pengeluaran": [
        3000000, 3500000, 3200000, 4000000,
        3800000, 4200000, 4500000, 4100000,
        5000000, 4800000, 5200000, 5500000
    ]
}

df = pd.DataFrame(data)

# 2. ANALISIS KEUANGAN
total_pemasukan = df["Pemasukan"].sum()
total_pengeluaran = df["Pengeluaran"].sum()
saldo = total_pemasukan - total_pengeluaran

print("TOTAL PEMASUKAN: Rp", f"{total_pemasukan:,}")
print("TOTAL PENGELUARAN: Rp", f"{total_pengeluaran:,}")
print("SALDO AKHIR: Rp", f"{saldo:,}")

# 3. MEMBUAT GRAFIK
sns.set_theme(style="whitegrid")

x = np.arange(len(df["Bulan"]))
width = 0.38

fig, ax = plt.subplots(figsize=(14, 7))

# Hijau untuk pemasukan
bar1 = ax.bar(
    x - width/2,
    df["Pemasukan"],
    width,
    label="Pemasukan",
    color="#16A34A"
)

# Merah untuk pengeluaran
bar2 = ax.bar(
    x + width/2,
    df["Pengeluaran"],
    width,
    label="Pengeluaran",
    color="#DC2626"
)

# 4. JUDUL DAN LABEL
ax.set_title(
    "GRAFIK PEMASUKAN DAN PENGELUARAN",
    fontsize=18,
    fontweight="bold",
    pad=25
)

ax.set_xlabel("Bulan", fontsize=12)
ax.set_ylabel("Nominal (Rupiah)", fontsize=12)

ax.set_xticks(x)
ax.set_xticklabels(df["Bulan"])

# Format Rupiah
ax.yaxis.set_major_formatter(
    plt.FuncFormatter(
        lambda value, _: f"Rp {value/1000000:.0f} Jt"
    )
)

# 5. LABEL ANGKA DI ATAS BATANG
for bars in [bar1, bar2]:
    for bar in bars:
        height = bar.get_height()
        ax.annotate(
            f"{height/1000000:.1f} Jt",
            xy=(bar.get_x() + bar.get_width()/2, height),
            xytext=(0, 4),
            textcoords="offset points",
            ha="center",
            fontsize=8,
            fontweight="bold"
        )

# 6. DESAIN
ax.legend(
    loc="upper left",
    frameon=False,
    fontsize=11
)

ax.grid(axis="y", linestyle="--", alpha=0.25)
ax.set_axisbelow(True)

sns.despine()
plt.tight_layout()

# 7. SIMPAN GRAFIK
plt.savefig(
    "grafik_keuangan.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()

# 8. TABEL RINGKASAN
display(df)

print("SALDO AKHIR: Rp", f"{saldo:,}")
