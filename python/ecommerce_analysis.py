import os
import pandas as pd
import matplotlib.pyplot as plt

DATA_DIR = "dataset"
OUT_DIR  = "output"
os.makedirs(OUT_DIR, exist_ok=True)

customers = pd.read_excel(f"{DATA_DIR}/customers.xlsx")
products  = pd.read_excel(f"{DATA_DIR}/products.xlsx")
orders    = pd.read_excel(f"{DATA_DIR}/orders.xlsx")

orders["order_date"]=pd.to_datetime(orders["order_date"],errors="coerce")

merged=orders.merge(products,on="product_id").merge(customers,on="customer_id")
merged["Sales"]=merged["price"]*merged["quantity"]
merged["Profit"]=(merged["price"]-merged["cost_price"])*merged["quantity"]

print("=== DATA INFO ===")
print(merged.info())
print("\nMissing Values\n",merged.isnull().sum())
print("\nDuplicates:",merged.duplicated().sum())

summary={
"Total Sales":merged["Sales"].sum(),
"Total Profit":merged["Profit"].sum(),
"Total Orders":merged["order_id"].nunique(),
"Total Customers":merged["customer_id"].nunique(),
"Total Products":merged["product_id"].nunique(),
"Average Order Value":merged["Sales"].sum()/merged["order_id"].nunique()
}
print("\n=== KPI ===")
for k,v in summary.items():
    print(f"{k}: {v}")

def save_plot(series,kind,title,file,**kwargs):
    plt.figure(figsize=(10,5))
    series.plot(kind=kind,**kwargs)
    plt.title(title)
    plt.tight_layout()
    plt.savefig(os.path.join(OUT_DIR,file))
    plt.close()

monthly=merged.groupby(merged["order_date"].dt.to_period("M"))["Sales"].sum()
top_products=merged.groupby("product_name")["Sales"].sum().sort_values(ascending=False).head(10)
top_customers=merged.groupby("customer_name")["Sales"].sum().sort_values(ascending=False).head(10)
category=merged.groupby("category")["Sales"].sum().sort_values(ascending=False)
state=merged.groupby("state")["Sales"].sum().sort_values(ascending=False)
gender=merged.groupby("gender")["Sales"].sum()
payment=merged.groupby("payment_mode")["Sales"].sum()
profit_products=merged.groupby("product_name")["Profit"].sum().sort_values(ascending=False).head(10)

save_plot(monthly,"line","Monthly Sales","monthly_sales.png",marker="o")
save_plot(top_products,"bar","Top Products","top_products.png")
save_plot(top_customers,"bar","Top Customers","top_customers.png")
save_plot(category,"bar","Category Sales","category_sales.png")
save_plot(state,"bar","State Sales","state_sales.png")
plt.figure(figsize=(6,6))
payment.plot(kind="pie",autopct="%1.1f%%")
plt.ylabel("")
plt.title("Payment Mode")
plt.tight_layout()
plt.savefig(os.path.join(OUT_DIR,"payment_mode.png"))
plt.close()
save_plot(profit_products,"bar","Top Profitable Products","top_profit_products.png")

merged.to_csv(os.path.join(OUT_DIR,"cleaned_data.csv"),index=False)
pd.DataFrame(summary.items(),columns=["Metric","Value"]).to_csv(os.path.join(OUT_DIR,"summary.csv"),index=False)

queries={
"Monthly Sales":monthly,
"Top Products":top_products,
"Top Customers":top_customers,
"Category Sales":category,
"State Sales":state,
"Gender Sales":gender,
"Payment":payment,
"Top Profit Products":profit_products
}
for name,df in queries.items():
    print(f"\n{name}\n",df)

print("\\nAnalysis complete.")
