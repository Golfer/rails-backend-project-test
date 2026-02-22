# Monorepo: Backend API + Frontend

This repository contains a **Rails 8 API** backend and a placeholder for a **React** frontend, runnable with Docker Compose.

## Structure

- **`backend/`** – Rails 8 API (PostgreSQL, Sidekiq, Swagger)
- **`frontend/`** – Reserved for React frontend

## Quick start (Docker)

From the repo root:

```bash
docker compose build
docker compose up
```

- **API:** http://localhost:3000  
- **Swagger UI:** http://localhost:3000/api-docs  
- **Health:** http://localhost:3000/up  

Services:

- `backend` – Rails server (port 3000)
- `sidekiq` – Background jobs
- `db` – PostgreSQL 16 (host port 5433 to avoid conflict with local Postgres)
- `redis` – Redis 7 (host port 6380 to avoid conflict with local Redis)

## API overview

All endpoints are under **`/api/v1/`**:

| Resource | Path |
|-------------------------------|------|
| Companies                     | `/api/v1/companies` |
| Onboarding steps              | `/api/v1/onboarding_steps` |
| Onboarding processes          | `/api/v1/onboarding_processes` |
| Onboarding step submissions   | `/api/v1/onboarding_step_submissions` |
| Vendors                       | `/api/v1/vendors`   |
| Warehouses                    | `/api/v1/warehouses` |
| Products                      | `/api/v1/products` |
| Sales history                 | `/api/v1/sales_history` |
| Sync statuses                 | `/api/v1/sync_statuses` |
| Users                         | `/api/v1/users` |

Standard REST: `GET` (index/show), `POST`, `PUT`, `DELETE`. Filtering via query params where applicable (e.g. `?company_id=`, `?vendor_id=`).

## Testing the API in dev

- **Postman** – Import the collection **`postman/Backend-API.postman_collection.json`** to run sample requests against the running API. Set `baseUrl` to `http://localhost:3000` and use **Auth > Register (new company)** then set the returned `token` in the collection variables. See **`postman/README.md`** for details.
- **Swagger UI** – With the backend running, open **http://localhost:3000/api-docs** to try endpoints from the browser (authorize with the JWT from register or login).

## Running tests (Docker)

From the repo root. The Compose service name is **`backend`** (not the project name):

```bash
# Prepare test DB (first time or after schema changes)
docker compose run --rm -e RAILS_ENV=test backend bundle exec rails db:prepare

# Run specs
docker compose run --rm -e RAILS_ENV=test backend bundle exec rspec
```

Or use the Makefile: `make test` (and `make test-db` to prepare the test database).

## Backend (without Docker)

See **`backend/README.md`** for running the Rails app locally with PostgreSQL and Redis.

## Environment

For Docker, defaults are set in `docker-compose.yml`. For local runs, copy `backend/.env.example` to `backend/.env` and adjust.
