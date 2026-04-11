# SmartEdu - Smart Classroom Application

A full-stack EdTech application built with Flutter (frontend) and Node.js (backend) for hackathon demonstration.

## Features

### Student Features
- **Dashboard** with performance overview (attendance, marks, assignments, notifications)
- **Attendance Module** with 75% attendance warning alert
- **Report Attendance Issue** - Raise disputes for incorrect attendance marks
- **Assignments** - View and submit assignments
- **Marks** - View marks with analytics and charts
- **Quizzes** - Attempt quizzes and view results
- **Study Materials** - View and download materials
- **Schedule** - View lecture timetable
- **Feedback** - Rate lectures
- **Notifications** - Real-time alerts for attendance, marks, holidays, events
- **Holiday & Leave Application** - Apply for leave
- **Events** - View and register for events
- **Smart Suggestions** - AI-like recommendations on dashboard

### Teacher Features
- **Dashboard** with management tools
- **Take Attendance** - Mark student attendance
- **Attendance Issues** - View and resolve (approve/reject) attendance disputes
- **Upload Marks** - Upload marks for students
- **Create Assignments** - Post new assignments
- **Upload Materials** - Share study materials
- **Create Quizzes** - Create and manage quizzes
- **Holiday Management** - Announce holidays
- **Substitute Teacher** - Set substitute teachers
- **Leave Requests** - Review leave applications

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js + Express.js
- **Database**: MongoDB
- **Authentication**: JWT (JSON Web Tokens)

## Project Structure

```
offgrid/
├── backend/                    # Node.js Backend
│   ├── config/                # Configuration
│   ├── controllers/           # Route controllers
│   ├── middleware/             # Auth middleware
│   ├── models/                # MongoDB models
│   ├── routes/                # API routes
│   ├── server.js              # Main server file
│   ├── seed.js                # Seed data
│   └── package.json
│
└── flutter_smartedu/           # Flutter Frontend
    └── lib/
        ├── models/            # Data models
        ├── screens/           # UI screens
        ├── services/           # API services
        ├── utils/             # Theme & constants
        ├── widgets/           # Reusable widgets
        └── main.dart          # App entry point
```

## Getting Started

### Prerequisites
- Node.js (v14+)
- MongoDB (local or Atlas)
- Flutter SDK
- Android Studio / VS Code

### Backend Setup

1. Navigate to backend folder:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Start MongoDB locally or update MONGODB_URI in `config/config.js`

4. Start the server:
```bash
npm start
```

The server will run on `http://localhost:5000` and auto-seed demo data.

### Flutter Setup

1. Navigate to Flutter project:
```bash
cd flutter_smartedu
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

**Note**: For Android emulator, the app connects to `http://10.0.2.2:5000` (localhost).

## Demo Credentials

The backend auto-seeds these accounts:

| Role | Email | Password |
|------|-------|----------|
| Student | student@test.com | password123 |
| Teacher | teacher@test.com | password123 |

## Key API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/profile` - Get user profile

### Attendance
- `POST /api/attendance/mark` - Mark attendance
- `GET /api/attendance/student/:id` - Get student attendance
- `POST /api/attendance/report-issue` - Report attendance issue
- `PUT /api/attendance/resolve/:id` - Resolve attendance issue

### Marks
- `POST /api/marks/upload` - Upload marks
- `GET /api/marks/student/:id` - Get student marks
- `GET /api/marks/analytics/:id` - Get marks analytics

### Assignments
- `POST /api/assignments/create` - Create assignment
- `POST /api/assignments/submit` - Submit assignment
- `GET /api/assignments` - Get all assignments

### Notifications
- `GET /api/notifications` - Get notifications
- `PUT /api/notifications/read/:id` - Mark as read

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary | #2563EB | Main buttons, headers |
| Secondary | #7C3AED | Accents |
| Success | #22C55E | Positive indicators |
| Warning | #F59E0B | Warnings, pending |
| Error | #EF4444 | Errors, alerts |

## Hackathon Highlights

1. **Attendance Dispute System** - Students can report wrong attendance marks; teachers can resolve
2. **75% Attendance Warning** - Automatic alerts when attendance drops below threshold
3. **Real-time Notifications** - Instant alerts for marks, assignments, holidays
4. **Performance Analytics** - Charts and summaries for marks
5. **Clean UI** - Modern design with gradients and cards
6. **Full-stack Implementation** - Complete Flutter + Node.js solution

## Flow for Demo

1. **Login** → Select role (Student/Teacher) → Login with demo credentials
2. **Student Flow**: Dashboard → Attendance → Report Issue → View Marks → Take Quiz
3. **Teacher Flow**: Dashboard → View Attendance Issues → Approve/Reject → Upload Marks

## License

MIT License - Built for hackathon demonstration.
