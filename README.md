# Enterprise Engineering Knowledge Assistant

The Engineering Knowledge Assistant is an internal knowledge platform that continuously captures, organizes, secures, and retrieves engineering knowledge across software projects. This repository contains the backend and foundation for Phase 0 of the project.

## Folder Structure

The project follows the layered architecture defined in the architecture specifications:

```
├── backend/
│   ├── src/
│   │   ├── config/       # Env, Logger, Security, Database configs
│   │   ├── middleware/   # Express middlewares (Error, 404, Request ID)
│   │   ├── modules/      # Feature-based domains
│   │   │   └── health/   # Health check controller and routes
│   │   ├── routes/       # Central API routing
│   │   ├── shared/       # Shared constants and utilities
│   │   ├── app.ts        # Express app initialization
│   │   └── server.ts     # Application entry point
│   ├── Dockerfile
│   ├── package.json
│   ├── vitest.config.ts
│   └── tsconfig.json
└── docker-compose.yml
```

> **Note on Architecture (Recommendation):**
> Currently, the backend follows the layered architecture specified in `04-IMPLEMENTATION.md` (`controllers/`, `services/`, etc.). For future scalability and to align with modular boundaries, it is highly recommended to migrate to a **Feature-Based Architecture** (e.g., `src/modules/health/controller/...`). However, to maintain adherence to the source documents, the layered structure is used for this phase.

> **Flutter Initialization (Recommendation):**
> The Flutter UI client is not required for Phase 0. When transitioning to the frontend implementation phase, you can initialize the Flutter app with:
> `flutter create --org com.enterprise --project-name knowledge_assistant frontend`

## Prerequisites

- [Node.js](https://nodejs.org/en/) (v20+)
- [pnpm](https://pnpm.io/installation) (v8+)
- [Docker](https://www.docker.com/) & Docker Compose

## Running Locally

### Using Docker Compose (Recommended)

To start the backend and a local MongoDB instance:

```bash
docker-compose up --build
```

The backend will be available at `http://localhost:3000`.

### Running Locally without Docker

1. **Install Dependencies:**
   ```bash
   cd backend
   pnpm install
   ```

2. **Configure Environment Variables:**
   Create a `.env` file in the `backend/` directory:
   ```env
   PORT=3000
   NODE_ENV=development
   MONGO_URI=mongodb://localhost:27017/engineering-knowledge
   ```

3. **Start MongoDB:**
   Ensure you have a MongoDB instance running locally or update `MONGO_URI` to point to a MongoDB Atlas cluster.

4. **Start the Development Server:**
   ```bash
   pnpm dev
   ```

## API Endpoints (Phase 0)

### Health Check

Verify the service is running correctly:

```bash
curl http://localhost:3000/api/v1/health
```

**Response:**
```json
{
  "status": "UP",
  "service": "Engineering Knowledge Assistant",
  "version": "1.0.0"
}
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | The port the backend server listens on | `3000` |
| `NODE_ENV` | The environment mode (`development`, `production`) | `development` |
| `MONGO_URI` | MongoDB connection string | `mongodb://localhost:27017/engineering-knowledge` |
