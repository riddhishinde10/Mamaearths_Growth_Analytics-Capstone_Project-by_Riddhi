# ----- Task 11 - Two visualizations -----
# ----- 1. Chart A: Return Rate by Payment Method -----
import matplotlib.pyplot as plt
plt.figure(figsize=(9, 6))

# Colorful bars for each payment method
colors = ["#FF4D6D", "#4285F4", "#34A853", "#A855F7"]

bars = plt.bar(
    payment_returns["payment_method"],
    payment_returns["return_rate_pct"],
    color=colors[:len(payment_returns)],
    edgecolor="white",
    linewidth=1.5,
    width=0.65
)

# Display return-rate percentages above the bars
for i, value in enumerate(payment_returns["return_rate_pct"]):
    plt.text(
        i, value + 1,
        f"{value:.1f}%",
        ha="center",
        fontsize=12,
        fontweight="bold"
    )

plt.title("Return Rate by Payment Method", fontsize=16, fontweight="bold")
plt.xlabel("Payment Method", fontsize=12)
plt.ylabel("Return Rate (%)", fontsize=12)

plt.grid(axis="y", linestyle="--", alpha=0.3)
plt.gca().set_axisbelow(True)

# Add the key finding below the chart
plt.figtext(
    0.96, 0.90,
    "KEY FINDING: COD Returns at 44.4% — 3X Card",
    ha="right",
    va="top" ,
    fontsize=12,
    fontweight="bold",
    color="#D62839",
    bbox=dict(
        boxstyle="round,pad=0.6",
        facecolor="#FFF0F2",
        edgecolor="#FF4D6D"
    )
)

plt.tight_layout()
plt.savefig(
    "return_rate_by_payment.png",
    dpi=150,
    bbox_inches="tight"
)
plt.show()

print("Finding: COD returns at 44.4% — approximately 3X the card return rate.")

# ----- 2. Chart B: Monthly Revenue Excluding Outliers -----
plt.figure(figsize=(9, 5))

plt.plot(
    monthly_revenue_corrected.index,
    monthly_revenue_corrected.values,
    marker="o",
    linewidth=2.5,
    markersize=8,
    color="#4285F4"
)

plt.title(
    "Monthly Revenue Excluding Quantity Outliers\nActual Peak: March 2026",
    fontsize=14,
    fontweight="bold"
)
plt.xlabel("Month", fontsize=12)
plt.ylabel("Monthly Revenue (₹)", fontsize=12)
plt.xticks(rotation=45)
plt.grid(True, linestyle="--", alpha=0.3)

# Highlight March as the actual peak month
plt.scatter(
    "2026-03",
    monthly_revenue_corrected.loc["2026-03"],
    color="#FF4D6D",
    s=120,
    zorder=5,
    label="Peak: March 2026 (₹20,318.90)"
)

plt.legend()
plt.tight_layout()

plt.savefig(
    "monthly_revenue_trend.png",
    dpi=150,
    bbox_inches="tight"
)

plt.show()
