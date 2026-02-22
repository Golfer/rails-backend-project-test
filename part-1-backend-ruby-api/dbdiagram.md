````
// ERD data diagram

Table companies {
  id uuid [pk, default: `uuid_generate_v4()`]
  name varchar [not null]
  created_at timestamp [default: `now()`]
}

Table onboarding_processes {
  id uuid [pk, default: `uuid_generate_v4()`]
  company_id uuid [unique, ref: > companies.id]
  current_step_id int [ref: > onboarding_steps.id]  
}

Table onboarding_steps {
  id int [pk, increment]
  title varchar [not null]
  slug varchar [unique, not null]
  sort_order int
  category varchar
  is_active boolean [default: false]
  is_mandatory boolean [default: true]
  dependency_step_id int [ref: > onboarding_steps.id] // Self-reference for locking
}

Table onboarding_step_submissions {
  id uuid [pk, default: `uuid_generate_v4()`]
  company_id uuid [ref: > companies.id]
  step_id int [ref: > onboarding_steps.id]
  status varchar // 'started', 'completed', 'skipped'
  values jsonb // Stores inputs like {"days": 63}
  completed_at timestamp
  updated_at timestamp [default: `now()`]
  
  Indexes {
    (company_id, step_id) [unique]
  }
}

Table products {
  sku_id varchar [pk]
  company_id uuid [ref: > companies.id]
  vendor_id uuid [ref: > vendors.id]
  name varchar
  lead_time_days int
  days_of_stock int
  forecasting_days int [note: "Updated by RefreshCalculationsWorker"]
}

Table sales_history {
  id uuid [pk, default: `uuid_generate_v4()`]
  product_sku varchar [ref: > products.sku_id]
  sale_date date
  quantity int
}

Table sync_status {
  id uuid [pk, default: `uuid_generate_v4()`]
  company_id uuid [ref: > companies.id]
  entity_type varchar // 'Warehouse', 'Product', 'SalesHistory'
  total_count int
  synced_count int
  is_finished boolean [default: false]
}

Table users {
  id uuid [pk, default: `uuid_generate_v4()`]
  company_id uuid [ref: > companies.id]
  email varchar [unique, not null]
  role varchar // e.g., 'admin', 'planner'
  password_digest varchar
}

Table warehouses {
  id uuid [pk, default: `uuid_generate_v4()`]
  company_id uuid [ref: > companies.id]
  name varchar
  address text
}

Table vendors {
  id uuid [pk, default: `uuid_generate_v4()`]
  company_id uuid [ref: > companies.id]
  name varchar
  contact_info jsonb
}
````