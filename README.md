# MetaCTO Feature Voting System

A FastAPI-based feature voting system where users can propose features and vote on others' suggestions.

## Features

-   **User Authentication**: Register and login with JWT tokens
-   **Feature Management**: Create and browse feature requests
-   **Voting System**: Vote for features (with business rules preventing self-voting and duplicate votes)
-   **Database Migrations**: Alembic for schema management
-   **Comprehensive Testing**: Full test suite with pytest
-   **Docker Support**: Containerized deployment with PostgreSQL

## API Endpoints

### Authentication (`/auth`)

-   `POST /auth/register` - Register a new user
-   `POST /auth/login` - Login and get JWT token

### Features (`/features`)

-   `POST /features/` - Create a new feature (requires authentication)
-   `GET /features/` - List all features with vote counts
-   `GET /features/{id}` - Get specific feature details

### Voting (`/votes`)

-   `POST /votes/` - Vote for a feature (requires authentication)
-   `DELETE /votes/{feature_id}` - Remove your vote (requires authentication)

## Quick Start

### Option 1: Docker (Recommended)

1. **Clone and build**:

    ```bash
    git clone <repository-url>
    cd metaCTO
    docker-compose up --build
    ```

2. **Access the application**:
    - Frontend: http://localhost:3000
    - Backend API: http://localhost:8000
    - API docs: http://localhost:8000/docs
    - Database: PostgreSQL on localhost:5432

### Option 2: Local Development

1. **Install dependencies**:

    ```bash
    pip install -r requirements.txt
    ```

2. **Run database migrations**:

    ```bash
    cd app && alembic upgrade head
    ```

3. **Start the server**:

    ```bash
    uvicorn app.main:app --reload
    ```

4. **Access the API**:
    - API: http://localhost:8000
    - Interactive docs: http://localhost:8000/docs

## Testing

Run the test suite:

```bash
pytest
```

Run with coverage:

```bash
pytest --cov=app tests/
```

Run specific test files:

```bash
pytest tests/test_auth.py
pytest tests/test_features.py
pytest tests/test_votes.py
```

## Database Management

### Creating Migrations

After modifying models in `app/models.py`:

```bash
cd app && alembic revision --autogenerate -m "Description of changes"
```

### Applying Migrations

```bash
cd app && alembic upgrade head
```

### Rolling Back

```bash
cd app && alembic downgrade -1
```

## Environment Variables

Create a `.env` file for local development:

```env
DATABASE_URL=sqlite:///./app.db
SECRET_KEY=your-secret-key-here
```

For production with PostgreSQL:

```env
DATABASE_URL=postgresql://user:password@localhost/dbname
SECRET_KEY=your-production-secret-key
```

## Project Structure

```
metaCTO/
├── app/                     # FastAPI backend
│   ├── routers/
│   │   ├── auth.py          # Authentication endpoints
│   │   ├── features.py      # Feature management endpoints
│   │   └── votes.py         # Voting endpoints
│   ├── models.py            # SQLAlchemy models
│   ├── schemas.py           # Pydantic schemas
│   ├── database.py          # Database configuration
│   ├── auth.py              # Authentication utilities
│   └── main.py              # FastAPI application
├── frontend/                # Next.js React frontend
│   ├── src/
│   │   ├── app/             # App router pages
│   │   ├── components/      # React components
│   │   ├── providers/       # Context providers
│   │   └── theme/           # Material-UI theme
│   ├── package.json         # Frontend dependencies
│   └── next.config.js       # Next.js configuration
├── tests/                   # Test suite
├── alembic/                 # Database migrations
├── docker-compose.yml       # Docker configuration
├── Dockerfile               # Docker image definition
├── requirements.txt         # Python dependencies
└── README.md               # This file
```

## Frontend Development

### Running the Frontend

Navigate to the frontend directory and install dependencies:
```bash
cd frontend
npm install
npm run dev
```

The frontend will be available at http://localhost:3000

### Frontend Structure

- **Pages**: `/`, `/login`, `/register`, `/features`
- **Components**: Reusable UI components with Material-UI
- **Theme**: Centralized Material-UI theme configuration
- **TypeScript**: Full type safety throughout the application

## Docker Development

Build and run all services with Docker Compose:
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
docker-compose logs backend    # Backend API logs
docker-compose logs frontend   # Frontend logs
docker-compose logs db         # Database logs
```

Run individual services:
```bash
docker-compose up backend      # Just backend + database
docker-compose up frontend     # Just frontend (requires backend running)
```

## Business Rules

-   Users must register and login to create features or vote
-   Users cannot vote for their own features
-   Users cannot vote multiple times for the same feature
-   Vote counts are automatically calculated and displayed with features
-   Users can remove their votes

## Development

### Adding New Features

1. Update models in `app/models.py`
2. Create migration: `cd app && alembic revision --autogenerate -m "description"`
3. Add Pydantic schemas in `app/schemas.py`
4. Create router endpoints in `app/routers/`
5. Include router in `app/main.py`
6. Write tests in `tests/`
7. Run tests: `pytest`

### API Documentation

FastAPI automatically generates interactive API documentation:

-   Swagger UI: http://localhost:8000/docs
-   ReDoc: http://localhost:8000/redoc
