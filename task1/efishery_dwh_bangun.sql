CREATE TABLE "fact_order_accumulating" (
  "order_date_id" int,
  "invoice_date_id" int,
  "payment_date_id" int,
  "customer_id" int,
  "order_number" varchar,
  "invoice_number" varchar,
  "payment_number" varchar,
  "total_order_quantity" int,
  "total_order_usd_amount" decimal,
  "order_to_invoice_lag_days" int,
  "invoice_to_payment_lag_days" int
);

CREATE TABLE "dim_date" (
  "id" int,
  "date" date,
  "month" int,
  "quater_of_year" int,
  "year" int,
  "is_weekend" boolean
);

CREATE TABLE "dim_customer" (
  "id" int,
  "name" varchar
);

ALTER TABLE "dim_date" ADD FOREIGN KEY ("id") REFERENCES "fact_order_accumulating" ("order_date_id");

ALTER TABLE "dim_date" ADD FOREIGN KEY ("id") REFERENCES "fact_order_accumulating" ("invoice_date_id");

ALTER TABLE "dim_date" ADD FOREIGN KEY ("id") REFERENCES "fact_order_accumulating" ("payment_date_id");

ALTER TABLE "dim_customer" ADD FOREIGN KEY ("id") REFERENCES "fact_order_accumulating" ("customer_id");

INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-03-02', '2020-03-05', '2020-03-08', 'PYM-777', 477, 3, 31.5, 'ORD-223', 'INV-525', 3923, 'Ani');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-03-02', '2020-03-05', '2020-03-08', 'PYM-777', 478, 10, 176, 'ORD-223', 'INV-525', 3923, 'Ani');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-03-02', '2020-03-05', '2020-03-08', 'PYM-777', 479, 5, 6, 'ORD-223', 'INV-525', 3923, 'Ani');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-08-16', '2020-08-22', '2020-09-17', 'PYM-817', 479, 9, 10.8, 'ORD-142', 'INV-642', 3924, 'Budi');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-09-10', '2020-09-17', '2020-10-05', 'PYM-792', 479, 9, 10.8, 'ORD-206', 'INV-557', 3923, 'Ani');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-10-09', '2020-10-13', '2020-10-23', 'PYM-802', 477, 7, 73.5, 'ORD-201', 'INV-581', 3924, 'Budi');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-12-04', '2020-12-13', '2021-01-11', 'PYM-761', 479, 3, 3.6, 'ORD-134', 'INV-587', 3924, 'Budi');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2021-01-23', '2021-02-01', '2021-02-02', 'PYM-803', 478, 7, 123.2, 'ORD-205', 'INV-647', 3923, 'Ani');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-07-13', '2020-07-19', null, null, 477, 9, 94.5, 'ORD-181', 'INV-549', 3925, 'Caca');
INSERT INTO "fact_order_accumulating"(date, invoice_date_id, payment_date_id, payment_number, product_id, quantity, usd_amount, order_number, invoice_number, customer_id, customer_name) VALUES ('2020-02-25', '2020-03-09', null, null, 479, 10, 12, 'ORD-170', 'INV-554', 3924, 'Budi');