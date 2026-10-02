# Mini Capstone API

A RESTful JSON API for an e-commerce store, built with **Ruby on Rails 8** and **PostgreSQL**.
Products, suppliers, categories, image galleries, a shopping cart, and order checkout with tax
calculation — plus session-based authentication and admin-only write access.

**Live API:** [mini-capstone-api-lv9j.onrender.com](https://mini-capstone-api-lv9j.onrender.com/products.json)
· **Live storefront:** [frontend-mini-capstone.onrender.com](https://frontend-mini-capstone.onrender.com/photos)
([frontend repo](https://github.com/mkanwal-iit/frontend-mini-capstone))

> Hosted on Render's free tier, which sleeps after 15 minutes of inactivity.
> The first request after a sleep takes roughly 30 seconds to wake the container.

---

## Features

- **Catalogue** — products belonging to suppliers, grouped into categories, each with multiple images
- **Cart** — add and remove line items, held against the signed-in user until checkout
- **Orders** — checkout computes subtotal, tax, and total, and converts cart items into an order
- **Authentication** — registration and login with `bcrypt`-hashed passwords
- **Authorization** — writes to the catalogue are restricted to admin users

---

## Tech Stack

| Layer | Technology |
| --- | --- |
| Framework | Ruby on Rails 8 |
| Language | Ruby 3.3.5 |
| Database | PostgreSQL (hosted on [Neon](https://neon.tech)) |
| Views | Jbuilder |
| Testing | Minitest |
| Security scanning | Brakeman |
| Linting | RuboCop |
| Containerization | Docker |
| CI | GitHub Actions |

---

## API Endpoints

### Products
| Method | Endpoint | Description | Auth |
| --- | --- | --- | --- |
| `GET` | `/products` | List all products | — |
| `GET` | `/products/:id` | Fetch a single product | — |
| `GET` | `/one_product` | Fetch a single featured product | — |
| `POST` | `/products` | Create a product | Admin |
| `PATCH` | `/products/:id` | Update a product | Admin |
| `DELETE` | `/products/:id` | Delete a product | Admin |

### Cart
| Method | Endpoint | Description | Auth |
| --- | --- | --- | --- |
| `GET` | `/carted_products` | List the current user's cart | User |
| `POST` | `/carted_products` | Add an item to the cart | User |
| `DELETE` | `/carted_products/:id` | Remove an item from the cart | User |

### Orders
| Method | Endpoint | Description | Auth |
| --- | --- | --- | --- |
| `GET` | `/orders` | List the current user's orders | User |
| `GET` | `/orders/:id` | Fetch a single order | User |
| `POST` | `/orders` | Check out the cart into an order | User |

### Users and sessions
| Method | Endpoint | Description |
| --- | --- | --- |
| `POST` | `/users` | Register a new user |
| `POST` | `/sessions` | Log in |
| `DELETE` | `/sessions` | Log out |
| `GET` | `/up` | Health check |

---

## Data Model

```
User                 Product              Order
├── name             ├── name             ├── user_id    → User
├── email            ├── price            ├── subtotal
├── password_digest  ├── description      ├── tax
└── admin            └── supplier_id      └── total
                          ↓
                     Supplier             CartedProduct
                     ├── name             ├── user_id    → User
                     ├── email            ├── product_id → Product
                     └── phone_number     ├── order_id   → Order
                                          ├── quantity
Category             Image                └── status
└── name             ├── url
     ↕               └── product_id → Product
CategoryProduct
├── category_id → Category
└── product_id  → Product
```

---

## Getting Started

### Prerequisites
- Ruby 3.3.5
- PostgreSQL
- Bundler

### Setup

```bash
git clone https://github.com/mkanwal-iit/mini-capstone-api.git
cd mini-capstone-api

bundle install
bin/rails db:prepare     # create the database and load the schema
bin/rails db:seed        # load the sample catalogue
bin/rails server         # start on http://localhost:3000
```

### Example request

```bash
curl http://localhost:3000/products.json
```

---

## Development

```bash
bin/rails test     # run the test suite
bin/rubocop        # check code style
bin/brakeman       # scan for security vulnerabilities
```

---

## Deployment

Deployed to [Render](https://render.com) as a Docker service, built from the `Dockerfile` in this
repository. Pushes to `main` trigger an automatic redeploy.

Configuration is supplied through environment variables, so the same image runs unchanged locally,
in CI, and in production:

| Variable | Purpose |
| --- | --- |
| `DATABASE_URL` | PostgreSQL connection string |
| `RAILS_MASTER_KEY` | Decrypts `config/credentials.yml.enc` |
| `WEB_CONCURRENCY` | Number of Puma worker processes |

[`bin/docker-entrypoint`](bin/docker-entrypoint) applies migrations and seeds the catalogue before
booting Puma. Seeding runs explicitly because `db:prepare` only seeds a database it creates itself;
[`db/seeds.rb`](db/seeds.rb) uses `find_or_create_by!` throughout, so repeating it on every
container start is safe.

### Recovering the deployment

This API had been offline for some time, and bringing it back surfaced three separate problems.

**The database no longer existed.** The original managed instance had expired, and the first
failure was `could not translate host name` — DNS could not resolve a host that had been deleted.
Rebuilt on [Neon](https://neon.tech), whose free tier does not expire.

**`DATABASE_URL` was being ignored.** With a new database attached, the error changed to
`connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed` — Rails was looking for
PostgreSQL on the container's own filesystem rather than at the host it had been given. The cause
was in `config/database.yml`: Rails merges `DATABASE_URL` automatically only into a
*single-database* production config, and the generated block named four (`primary`, `cache`,
`queue`, `cable`). Unable to tell which the variable referred to, Rails ignored it entirely and
fell back to credentials with no host. Reading the variable explicitly, and pointing every role at
that one database, resolved it.

**The tables were empty.** `db:prepare` seeds only a database it creates itself, and this one
already existed by the time it ran, so the catalogue never loaded. Seeding explicitly required the
seeds to be safe on repeat, since the container restarts after every deploy and every wake from
sleep — hence the rewrite to `find_or_create_by!`, and the replacement of hardcoded foreign keys
with real references.

---

## Continuous Integration

Every push and pull request triggers [`.github/workflows/ci.yml`](.github/workflows/ci.yml), which
runs in parallel:

| Job | Purpose |
| --- | --- |
| `test` | Runs the Minitest suite against a live PostgreSQL service container |
| `scan_ruby` | Brakeman static analysis for Rails security vulnerabilities |
| `lint` | Enforces consistent style with RuboCop |
