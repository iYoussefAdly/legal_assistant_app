# Legal Assistant App

A Flutter mobile application that provides AI-powered legal assistance. Users can ask legal questions via text, audio, or file attachments and receive answers backed by legal sources. Built as part of the DEPI program.

---

## Features

- **AI Chat** — Send text queries and receive structured legal answers with cited sources
- **Audio Queries** — Record or upload audio and get AI-generated legal responses
- **File Queries** — Attach a document alongside a question for context-aware analysis
- **Document Upload** — Upload legal documents to the backend for processing
- **Authentication** — Sign up, sign in, and forgot-password flows with persistent sessions
- **Markdown Rendering** — AI responses rendered with full markdown support

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter 3, Material Design |
| State Management | flutter_bloc (Cubit) |
| Networking | Dio + pretty_dio_logger |
| Dependency Injection | get_it |
| Local Storage | shared_preferences |
| File Handling | file_picker, mime, http_parser |
| Config | flutter_dotenv |
| Rendering | flutter_markdown |

---

## Architecture

The project follows **Clean Architecture** with strict layer separation:

```
lib/
├── core/
│   ├── di/              # get_it service locator setup
│   ├── errors/          # Failure classes and exception types
│   ├── network/         # Dio clients and API endpoint definitions
│   ├── router/          # Named route definitions (AppRouter)
│   ├── services/        # LocalStorageService
│   └── utils/           # ApiResult<T> sealed class, shared styles/helpers
│
└── features/
    ├── auth/            # Sign in, sign up, forgot password
    ├── chat/            # Text / audio / file query chat interface
    ├── documents/       # Document upload
    └── splash/          # App entry / session check
```

Each feature follows the three-layer pattern:

```
features/{name}/
├── data/        # Remote data sources, repository implementations, models
├── domain/      # Entities, repository contracts, use cases
└── presentation/ # Cubits, states, views, widgets
```

---

## Backends

The app communicates with two backends:

| Backend | Purpose |
|---|---|
| FastAPI (`http://52.143.145.178:8000`) | AI query endpoints (`/api/query/text`, `/api/query/audio`, `/api/query/file`, `/api/init`) |
| Azure Functions (`francecentral-01.azurewebsites.net`) | User management and document upload |

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.9.2`
- Dart SDK `^3.9.2`

### Setup

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd legal_assistant_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the project root and add your Azure Function key:
   ```
   AZURE_FUNCTION_KEY=your_key_here
   ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## App Routes

| Route | Screen |
|---|---|
| `/` | Splash / session check |
| `/sign-in` | Login |
| `/sign-up` | Registration |
| `/forgot-password` | Password recovery |
| `/chat` | Main chat interface |
