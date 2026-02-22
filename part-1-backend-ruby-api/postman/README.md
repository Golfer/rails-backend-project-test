# Postman collection

Import `Backend-API.postman_collection.json` into Postman.

## Variables

- **baseUrl** – API root (e.g. `http://localhost:3000`)
- **token** – JWT from **Auth > Login** or **Auth > Register**; used as Bearer token for protected endpoints
- **company_id**, **user_id**, **vendor_id**, **product_sku**, etc. – Fill from create/list responses to use in subsequent requests

## Flow

1. Set **baseUrl** (e.g. `http://localhost:3000`).
2. **Auth > Register (new company)** – no auth needed. Send `company_name` and user fields; the API creates the company and the user. Copy `token` and `user.company_id` from the response into **token** and **company_id**.
3. Or **Auth > Register (existing company)** with an existing **company_id** to add another user to that company.
4. Or **Auth > Login** after you have a user.
5. Use other requests; many rely on **company_id**, **vendor_id**, **product_sku**, etc. Set those from create/get responses as needed.

## Swagger

API docs are served at:

- **UI:** `http://localhost:3000/api-docs`
- **Spec:** `http://localhost:3000/api-docs/v1/swagger.yaml`

Start the Rails server, then open `/api-docs` in the browser to try the API from Swagger UI.
