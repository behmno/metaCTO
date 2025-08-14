# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A FastAPI application with SQLAlchemy for database operations. The project follows a standard FastAPI structure with separation of concerns between models, database configuration, and application logic.

## Development Setup

Install dependencies:
```bash
pip install -r requirements.txt
```

Run database migrations:
```bash
alembic upgrade head
```

Run the development server:
```bash
uvicorn app.main:app --reload
```

## Docker Development

Build and run with Docker Compose:
```bash
docker-compose up --build
```

Run in detached mode:
```bash
docker-compose up -d
```

Stop services:
```bash
docker-compose down
```

View logs:
```bash
docker-compose logs app
```

## Database Migrations

Create a new migration after model changes:
```bash
alembic revision --autogenerate -m "Description of changes"
```

Apply migrations:
```bash
alembic upgrade head
```

Rollback migration:
```bash
alembic downgrade -1
```

## Architecture Notes

- `app/main.py` - Main FastAPI application and route definitions
- `app/database.py` - SQLAlchemy database configuration and session management
- `app/models.py` - SQLAlchemy ORM models
- Uses SQLite database by default (configurable via DATABASE_URL environment variable)
- Database tables are automatically created on application startup