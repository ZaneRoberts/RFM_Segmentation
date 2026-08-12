DROP VIEW IF EXISTS scored_rfm;
DROP VIEW IF EXISTS base_rfm;
DROP VIEW IF EXISTS cleaned_transactions;

-- Create a clean staging view or table
CREATE VIEW cleaned_transactions AS
SELECT 
    CAST(CustomerID AS INT) AS customer_id,
    InvoiceNo AS invoice_no,
    CAST(InvoiceDate AS TIMESTAMP) AS invoice_date,
    (Quantity * UnitPrice) AS total_sales
FROM online_retail
WHERE CustomerID IS NOT NULL 
  AND Quantity > 0 
  AND UnitPrice > 0;

-- Base RFM Aggregation
CREATE VIEW base_rfm AS
SELECT 
    customer_id,
    MAX(invoice_date) AS last_purchase_date,
    -- Assuming max date in dataset is '2011-12-09', snapshot is '2011-12-10'
    JULIANDAY('2011-12-10') - JULIANDAY(MAX(invoice_date)) AS recency_days,
    COUNT(DISTINCT invoice_no) AS frequency,
    SUM(total_sales) AS monetary
FROM cleaned_transactions
GROUP BY customer_id;

-- Scoring RFM
CREATE VIEW scored_rfm AS
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
FROM base_rfm;

-- Final Segmentation Logic
SELECT 
    customer_id,
    r_score,
    f_score,
    m_score,
    (r_score * 100 + f_score * 10 + m_score) AS rfm_cell,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Hibernating / Lost'
        ELSE 'Potential Loyalist'
    END AS customer_segment
FROM scored_rfm;