import mysql.connector
import pandas as pd

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_PASSWORD",
    database="customer_sales_intelligence"
)

print("MySQL connection successful!")

query = """
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MAX(o.order_purchase_timestamp) AS last_purchase_date,
    SUM(oi.price) AS total_revenue
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
JOIN Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id;
"""

df = pd.read_sql(query, conn)

print(df.head())
print(df.shape)

# Top 10 customers by revenue
top_customers = df.sort_values(
    by="total_revenue",
    ascending=False
).head(10)

print("\nTop 10 Customers by Revenue:")
print(top_customers)

# Find the latest purchase date in the dataset
latest_date = df["last_purchase_date"].max()

# Define 6 months before the latest date
inactive_cutoff = latest_date - pd.DateOffset(months=6)

# Find inactive customers
inactive_customers = df[
    df["last_purchase_date"] < inactive_cutoff
]

# Sort oldest purchase dates first
inactive_customers = inactive_customers.sort_values(
    by="last_purchase_date"
)

print("\nInactive Customers:")
print(inactive_customers.head(10))

# Find valuable inactive customers
valuable_inactive = inactive_customers[
    inactive_customers["total_revenue"] >= 3000
]

valuable_inactive = valuable_inactive.sort_values(
    by="total_revenue",
    ascending=False
)

print("\nValuable Inactive Customers:")
print(valuable_inactive.head(10))

# Revenue by product category
query = """
SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM Order_Items oi
JOIN Products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;
"""

category_df = pd.read_sql(query, conn)

print("\nRevenue by Category:")
print(category_df.head(10))

# Repeat customer rate
repeat_customers = df[df["total_orders"] > 1]

repeat_customer_count = repeat_customers.shape[0]
total_customer_count = df.shape[0]

repeat_customer_rate = (
    repeat_customer_count / total_customer_count
) * 100

print("\nRepeat Customer Rate:")
print(f"{repeat_customer_rate:.2f}%")

# Create customer analysis dataset

latest_date = df["last_purchase_date"].max()

df["days_since_last_purchase"] = (
    latest_date - df["last_purchase_date"]
).dt.days

df["customer_status"] = df["days_since_last_purchase"].apply(
    lambda x: "Inactive" if x > 180 else "Active"
)

# Save final dataset
df.to_csv("customer_analysis.csv", index=False)

print("\nFinal Customer Analysis Dataset:")
print(df.head())
print(df.shape)

# Check customer status counts
print("\nCustomer Status Count:")
print(df["customer_status"].value_counts())

# Create a short customer label for Power BI
df["customer_label"] = "Customer " + (
    df.groupby("customer_unique_id").ngroup() + 1
).astype(str)

# Save updated dataset
df.to_csv("customer_analysis.csv", index=False)

print("\nCustomer labels created:")
print(df[["customer_unique_id", "customer_label"]].head())
