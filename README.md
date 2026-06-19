# NexsNews

NexsNews is a Docker-first Ruby on Rails application designed to become a professional technical news and publishing platform.

The project is built incrementally with a strong focus on maintainability, security, testing, database discipline, and a production-oriented development workflow.

> Current stage: early MVP foundation.

## Table of Contents

- Overview (#overview)
- Current Capabilities (#current-capabilities)
- Tech Stack (#tech-stack)
- Architecture (#architecture)
- Development Workflow (#development-workflow)
- Requirements (#requirements)
- Setup (#setup)
- Docker Services (#docker-services)
- Database (#database)
- Testing (#testing)
- Code Quality and Security (#code-quality-and-security)
- Continuous Integration (#continuous-integration)
- Git Workflow (#git-workflow)
- Troubleshooting (#troubleshooting)
- Roadmap (#roadmap)

## Overview

NexsNews aims to provide a clean editorial platform for publishing technical articles with structured content, categories, tags, comments, moderation, and administration.

The project is currently focused on building the foundation correctly before adding user-facing features too quickly.

The current codebase includes:

- a Rails full-stack application
- a Docker Compose development environment
- PostgreSQL as the application database
- a custom home page
- Importmap-based JavaScript setup
- CI checks for tests, linting, and security
- a protected main branch workflow
- the first domain model: Article

## Current Capabilities

Implemented:

- Rails application booting through Docker
- PostgreSQL connection through Docker Compose
- Custom root page at /
- Health check endpoint at /up
- Initial Article model
- Article validations
- Article fixtures
- Article model tests
- GitHub Actions CI
- Branch protection on main

Not implemented yet:

- article listing page
- article detail page
- article creation UI
- categories
- tags
- comments
- authentication
- admin area
- moderation workflow
- production deployment

## Tech Stack

   Layer                  Technology
━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Language               Ruby 3.4.9
─────────────────────  ──────────────────────────────────────────
   Framework              Ruby on Rails 8.1.3
─────────────────────  ──────────────────────────────────────────
   Database               PostgreSQL 17
─────────────────────  ──────────────────────────────────────────
   Views                  ERB
─────────────────────  ──────────────────────────────────────────
   Frontend behavior      Turbo, Stimulus
─────────────────────  ──────────────────────────────────────────
   JavaScript             Importmap
─────────────────────  ──────────────────────────────────────────
   Assets                 Propshaft
─────────────────────  ──────────────────────────────────────────
   Web server             Puma
─────────────────────  ──────────────────────────────────────────
   Development runtime    Docker, Docker Compose
─────────────────────  ──────────────────────────────────────────
   CI                     GitHub Actions
─────────────────────  ──────────────────────────────────────────
   Security checks        Brakeman, Bundler Audit, Importmap audit
─────────────────────  ──────────────────────────────────────────
   Code style             RuboCop Rails Omakase

## Architecture

NexsNews is currently a Rails full-stack monolith.

The application follows the standard Rails structure:

app/
   controllers/
   models/
   views/
config/
db/
test/

Current domain model:

Article

Article fields:

   Field           Type        Required    Notes
━━━━━━━━━━━━━━  ━━━━━━━━━━  ━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   title           string      yes         Public article title
──────────────  ──────────  ──────────  ────────────────────────────────
   slug            string      yes         Unique URL-friendly identifier
──────────────  ──────────  ──────────  ────────────────────────────────
   excerpt         text        no          Short summary
──────────────  ──────────  ──────────  ────────────────────────────────
   body            text        yes         Main article content
──────────────  ──────────  ──────────  ────────────────────────────────
   status          integer     yes         Publication state
──────────────  ──────────  ──────────  ────────────────────────────────
   published_at    datetime    no          Publication timestamp

Article statuses:

   Status       Meaning
━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   draft        Work in progress
───────────  ─────────────────────────────────────
   published    Publicly available in the future UI
───────────  ─────────────────────────────────────
   archived     Removed from active publication

Database constraints:

- articles.title cannot be null
- articles.slug cannot be null
- articles.body cannot be null
- articles.status cannot be null
- articles.status defaults to draft
- articles.slug has a unique index

Rails validations mirror the important database constraints.

## Development Workflow

This project uses a Docker-first workflow.

Rails commands should be executed inside the web container:

docker compose exec web bin/rails ...

The host machine does not need a local Ruby installation for normal development.

Development rules:

- do not work directly on main
- create a branch for each change
- keep commits focused
- run tests before opening a Pull Request
- keep CI green
- merge through GitHub Pull Requests

## Requirements

Required on the host machine:

- Git
- Docker
- Docker Compose

Optional:

- GitHub CLI
- a local Ruby installation for editor integrations only

## Setup

Build the development image:

docker compose build web

Start the services:

docker compose up -d

Prepare the database:

docker compose exec web bin/rails db:prepare

Open the application:

http://localhost:3000

Check running services:

docker compose ps

Stop the services:

docker compose down

## Docker Services

Docker Compose defines two services:

   Service    Purpose
━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━
   web        Rails application
─────────  ─────────────────────
   db         PostgreSQL database

Docker volumes:

   Volume           Purpose
━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━
   bundle           Bundler gems
───────────────  ─────────────────
   postgres_data    PostgreSQL data

The Rails app is mounted into the container at:

/rails

The Bundler volume is mounted at:

/usr/local/bundle

## Database

Run migrations:

docker compose exec web bin/rails db:migrate

Check migration status:

docker compose exec web bin/rails db:migrate:status

Prepare the test database:

docker compose exec web bin/rails db:test:prepare

Reset the development database:

docker compose exec web bin/rails db:reset

Use db:reset carefully because it drops and recreates the development database.

## Testing

Run the full Rails test suite:

docker compose exec web bin/rails test

Run a specific test file:

docker compose exec web bin/rails test test/models/article_test.rb

Current test coverage includes:

- root page response test
- article fixture validity
- article title validation
- article slug uniqueness validation
- article default status behavior

System tests are not enabled in CI yet. They will be introduced when browser-level workflows are added.

## Code Quality and Security

Run RuboCop:

docker compose exec web bin/rubocop

Run Brakeman:

docker compose exec web bin/brakeman --no-pager

Run Bundler Audit:

docker compose exec web bin/bundler-audit

Run Importmap audit:

docker compose exec web bin/importmap audit

Recommended local check before opening a Pull Request:

docker compose exec web bin/rails test
docker compose exec web bin/rubocop
docker compose exec web bin/brakeman --no-pager
docker compose exec web bin/bundler-audit
docker compose exec web bin/importmap audit

## Continuous Integration

GitHub Actions runs on:

- Pull Requests
- pushes to main

Current CI jobs:

   Job          Purpose
━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   scan_ruby    Brakeman and Bundler Audit
───────────  ─────────────────────────────
   scan_js      Importmap dependency audit
───────────  ─────────────────────────────
   lint         RuboCop
───────────  ─────────────────────────────
   test         Rails tests with PostgreSQL

The main branch is protected. Pull Requests must pass the required checks before merge.

## Git Workflow

Start new work from an up-to-date main:

git switch main
git pull --ff-only origin main
git switch -c feature/my-feature

After making changes:

docker compose exec web bin/rails test
docker compose exec web bin/rubocop
git status
git add <files>
git commit -m "Describe the change"
git push -u origin feature/my-feature

Then open a Pull Request into main.

Recommended branch prefixes:

   Prefix       Use case
━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━
   feature/     New product functionality
───────────  ───────────────────────────
   fix/         Bug fixes
───────────  ───────────────────────────
   docs/        Documentation changes
───────────  ───────────────────────────
   chore/       Maintenance work
───────────  ───────────────────────────
   security/    Security-related updates

## Troubleshooting

### Missing gem after pulling changes

If Gemfile.lock changed and the web container cannot find a gem:

docker compose run --rm web bundle install
docker compose up -d

### Bundler permission error

If Bundler cannot write to /usr/local/bundle, fix only the Bundler volume permissions:

docker compose run --rm --user root web chown -R 1000:1000 /usr/local/bundle
docker compose run --rm web bundle install
docker compose up -d

Do not run docker compose down -v unless you intentionally want to remove all Compose volumes, including PostgreSQL data.

### Web container exits immediately

Check all containers:

docker compose ps -a

Read the Rails container logs:

docker compose logs web --tail=120

### Database connection issues

Check that PostgreSQL is running:

docker compose ps

Then verify Rails can prepare the database:

docker compose exec web bin/rails db:prepare

## Roadmap

Near-term roadmap:

1. Article listing page
2. Article detail page
3. Article slugs in routes
4. Categories
5. Tags
6. Comments
7. Authentication
8. Authorization and admin area
9. Moderation workflow
10. System tests
11. Security hardening
12. Production readiness
13. Deployment
14. Final documentation

Long-term goal:

NexsNews should become a production-ready Rails publishing platform with a clean editorial workflow, strong test coverage, secure defaults, and maintainable architecture.