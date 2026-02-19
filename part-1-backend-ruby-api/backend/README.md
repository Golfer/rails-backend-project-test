# Backend API (Rails 8)

API-only Rails 8 application with PostgreSQL, Sidekiq, and Swagger.

## Stack

- **Rails 8** (API mode)
- **PostgreSQL** (with UUID and JSONB)
- **Redis** + **Sidekiq** (background jobs)
- **rswag** (Swagger/OpenAPI docs at `/api-docs`)

## Run with Docker (from repo root)

```bash
docker compose up backend sidekiq db redis
```

API: http://localhost:3000  
Swagger: http://localhost:3000/api-docs  

## Run locally (no Docker)

1. **Ruby 3.3+**, PostgreSQL, Redis installed.

2. **Install gems**
   ```bash
   cd backend && bundle install
   ```

3. **Database**
   ```bash
   export DATABASE_HOST=localhost DATABASE_USERNAME=postgres DATABASE_PASSWORD=your_password
   bundle exec rails db:create db:migrate
   ```

4. **Start Rails**
   ```bash
   bundle exec rails server
   ```

5. **Start Sidekiq** (separate terminal)
   ```bash
   bundle exec sidekiq
   ```

## Routes

- `GET /up` – health check
- `GET /api-docs` – Swagger UI
- `/api/v1/*` – REST resources (companies, onboarding_steps, onboarding_processes, onboarding_step_submissions, vendors, warehouses, products, sales_history, sync_statuses, users)

## Background jobs

- **RefreshCalculationsWorker** – placeholder worker (e.g. refresh product `forecasting_days`). Enqueue with:
  ```ruby
  RefreshCalculationsWorker.perform_async
  # or for a single product:
  RefreshCalculationsWorker.perform_async("SKU-123")
  ```

## Tests

RSpec + Factory Bot + Faker + Shoulda Matchers. Request specs cover all API endpoints; model specs cover validations and associations.

**Run tests (local):** ensure test DB exists, then run specs:

```bash
cd backend
bundle exec rails db:create db:migrate RAILS_ENV=test
bundle exec rspec
```

**Run tests (Docker):** rebuild image so test gems are installed, then:

```bash
docker compose run --rm backend bash -c "bundle install && bundle exec rails db:create db:migrate RAILS_ENV=test && bundle exec rspec"
```

Use `bundle exec rspec spec/requests` or `bundle exec rspec spec/models` to run a subset. Use `--format documentation` for verbose output.

## Generate Swagger from RSpec (optional)

```bash
bundle exec rspec spec/requests --format Rswag::Specs::SwaggerFormatter
```

This updates `swagger/v1/swagger.yaml` from request specs. The repo ships a hand-written OpenAPI spec so the API is documented without running specs.
