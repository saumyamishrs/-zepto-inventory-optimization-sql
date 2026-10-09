# Zepto Inventory Optimization SQL Portfolio Project




A data-driven SQL optimization project analyzing real-time dark store inventory, auditing financial metrics, and automating stock replenishment strategies for a **10-minute quick-commerce business model (Zepto)**.

---

## 📌 Project Overview
This project focuses on inventory health monitoring, revenue leakage prevention, and supply chain calibration inside localized micro-warehouses (Dark Stores). It delivers executive-level operational dashboards, handles structural calibration for raw retail data, and implements proactive restock triggers to maintain tight delivery SLAs.

### Core Database Architecture
The data engine maps all operational Stock Keeping Units (SKUs) inside a centralized ledger:

| Attribute | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| **`sku_id`** | `SERIAL` | `PRIMARY KEY` | Auto-incrementing unique identifier for each warehouse item. |
| **`category`** | `VARCHAR(120)` | None | Product classification tier (e.g., Snacks, Fresh Produce). |
| **`name`** | `VARCHAR(150)` | `NOT NULL` | The commercial product name banner. |
| **`mrp`** | `NUMERIC(8,2)` | None | Maximum Retail Price before promotional discounts. |
| **`discountpercent`** | `NUMERIC(5,2)` | None | Percentage promotional rebate active on the item. |
| **`availableQuantity`**| `INTEGER` | None | Live unit count currently resting inside warehouse racks. |
| **`discountSellingPrice`**| `NUMERIC(8,2)`| None | Realized purchase price for customers after product discounts. |
| **`weightInGms`** | `INTEGER` | None | Product package mass unit for delivery logistics calculations. |
| **`outOfStock`** | `BOOLEAN` | None | Real-time flag telling the app whether to accept or block orders. |
| **`quantity`** | `INTEGER` | None | Standard customer packaging volume multiplier index. |

---

## 📊 Inventory Optimization Challenges Solved

### 1. Data Cleaning & Financial Scaling
* **Defective Catalog Filtration:** Sweeps and removes dead system metadata rows where baseline parameters like product `mrp` were logged as `0`.
* **Currency Metric Normalization:** Scales internal system numeric entries to represent accurate real-world standard INR values (`mrp / 100.0`).

### 2. Operational Revenue Audits
* **Premium Basket Protection (Q2):** Specifically flags high-ticket premium items (MRP > ₹200) currently resting at 'Out of Stock' status to eliminate high-value cart abandonments.
* **Valuation Rollups (Q3 & Q8):** Aggregates cross-category financial revenue expectations and delivery payload weights to optimize fleet dispatch constraints.

### 3. Supply Chain Predictive Triggers
* **Proactive Restock Matrix (Q9):** Uses logic matrix tagging to flag items as `'Immediate Refill Needed'` vs `'Critical Low Stock'` before localized inventories hit absolute zero.
* **Window Functions Performance Evaluation (Q11):** Deploys analytical `DENSE_RANK() OVER(PARTITION BY...)` groupings to dynamically capture and surface the highest standalone product discounts inside every active product department.

---

## 🛠️ Workspace Deployment Steps
1. Initialize a PostgreSQL, MySQL, or local relational database workbench.
2. Run the DDL statements in your script file sequentially to establish the `zepto` table matrix.
3. Import your source dataset files or insert commands into the active table structure.
4. Execute the auditing blocks to clean raw records and generate structural operational intelligence dashboards.

---

## 🤝 Credits & Acknowledgments
* This workspace was initiated as a database analysis study based on warehouse logic tutorials provided by my instructor.
* Advanced custom enhancements—including specific premium target filters (MRP > ₹200 adjustments), inventory depletion urgency statuses, pricing logic anomaly checks, value bundle candidate sorting, and multi-partition window rank filters—were engineered completely independently to match corporate quick-commerce analytics frameworks.
