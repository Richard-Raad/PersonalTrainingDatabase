# Personal Training Database

**A comprehensive web application for managing personal training, workout plans, and fitness progress.**

## Team
- Richard Raad (richardtraad)
- Aiden Racelis (aidenr23)
- Vissu Manchem (vissumanchem)
- Sid Jain (siddharthjain)

---

## Overview

Personal Training Database web application designed to solve the challenge of managing personal training and fitness progress in a structured, scalable, and reliable way for both new gym-goers and experienced lifters.

### Problem It Solves
In many real-world situations, users rely on fragmented tools such as paper logs, notes apps, and spreadsheets to store workout plans and performance data. This leads to:
- Duplicated information
- Inconsistent naming of exercises
- Difficulty maintaining accurate relationships between key concepts
- Challenges tracking progress and comparing workouts

PTDB provides a centralized database solution to manage:
- **Clients** & **Trainers** - Define relationships and affiliations
- **Workout Plans** - Create and organize structured training routines
- **Exercises** - Maintain a consistent exercise library with muscle group targeting
- **Performance Logs** - Track workout history and progress over time
- **Body Metrics** - Monitor physical changes and fitness milestones

---

## Features

### Authentication & User Management
- **User Registration** - Sign up as a new client
- **Secure Login** - Password authentication with bcrypt hashing
- **Change Password** - Users can update their passwords securely
- **Role-Based Access Control** - Three roles: Admin, Trainer, and Client
- **Admin Panel** - Create and manage users with specific roles

### Workout Management
- **Workout Plans** - Create, view, and manage structured training plans
- **Exercise Library** - Browse and organize exercises by muscle groups
- **Workout Sessions** - Log completed workouts with detailed performance data
- **Performance Tracking** - Record sets, reps, and weights for each exercise

### Exercise & Performance Tracking
- **Muscle Groups** - Organize exercises by targeted muscle groups
- **Performance Logs** - Track workout history with detailed metrics
- **Body Metrics** - Monitor body measurements and fitness progress over time

###  Trainer & Client Management
- **Trainer Profiles** - View trainer information and credentials
- **Gym Associations** - Link trainers to specific gym locations
- **Client-Trainer Relationships** - Manage trainer-client connections

---

## Screenshots

The application includes detailed ER diagrams and UI screenshots showcasing the system architecture and user interface:

### Database & Architecture
![ER Diagram](docs/er_diagram.png)
*Complete entity-relationship diagram showing all table relationships and data model*

### Application UI Screenshots

**Figure 2.1 - Login Page**
![Figure 2.1](docs/screenshots/figure2.1.png)

**Figure 2.2 - User Registration/Signup Page**
![Figure 2.2](docs/screenshots/figure2.2.png)

**Figure 2.3 - Overview & Tables**
![Figure 2.3](docs/screenshots/figure2.3.png)

**Figure 2.4 - Dashboard Change Password**
![Figure 2.4](docs/screenshots/figure2.4.png)

**Figure 2.5 - Create Account**
![Figure 2.5](docs/screenshots/figure2.5.png)

### Workout Management Screenshots

**Figure 3.1 - Connected to Database**
![Figure 3.1](docs/screenshots/figure3.1.png)

### Feature Demonstrations

**Figure 5.1 - Client Progress Summary**
![Figure 5.1](docs/screenshots/figure5.1.png)

**Figure 5.2 - Trainer Workload Summery**
![Figure 5.2](docs/screenshots/figure5.2.png)

### Additional Features

**Figure 6.1 - Adding Clients**
![Figure 6.1](docs/screenshots/figure6.1.png)

**Figure 6.2 - Succesful Addition of Client**
![Figure 6.2](docs/screenshots/figure6.2.png)

**Figure 6.3 - Current Clients**
![Figure 6.3](docs/screenshots/figure6.3.png)

**Figure 6.4 - Updating Clients**
![Figure 6.4](docs/screenshots/figure6.4.png)

**Figure 6.5 - Succesful Update of Client**
![Figure 6.5](docs/screenshots/figure6.5.png)

**Figure 6.6 - Removing Client**
![Figure 6.6](docs/screenshots/figure6.6.png)

**Figure 6.7 - Succesful Removal of Client**
![Figure 6.7](docs/screenshots/figure6.7.png)

---

## Technology Stack

### Backend
- **Framework**: Flask 
- **Language**: Python 3.14
- **Database Driver**: oracledb (Python Oracle Database Interface)

### Frontend
- **HTML5** - Markup and page structure
- **CSS** - Styling and responsive design

### Database
- **Oracle Database** - Hosted on Oracle FreeSQL

### Environment
- **Python Virtual Environment** (.venv)
- **Environment Variables** - Managed via .env file

---

## Setup Instructions

### Prerequisites
- Python 3.8 or higher
- Oracle Instant Client 
- Git
- Oracle FreeSQL account

### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd PersonalTrainingDatabase
```

### Step 2: Create a Virtual Environment
```bash
# Create virtual environment
python -m venv .venv

# Activate virtual environment
# On Windows:
.venv\Scripts\activate
# On macOS/Linux:
source .venv/bin/activate
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Configure Environment Variables
1. Copy the example environment file:
   ```bash
   cp env_example.sh .env
   ```

2. Edit the `.env` file with your Oracle FreeSQL credentials:
   ```bash
   ORACLE_CLIENT_DIR=~/oracle/instantclient_23_6
   DB_USER=your_username
   DB_PASSWORD=your_password
   DB_DSN=db.freesql.com:1521/your_service
   SECRET_KEY=your_secret_key
   ```

**Configuration Details:**
- `ORACLE_CLIENT_DIR` - Path to Oracle Instant Client installation
- `DB_USER` - Your Oracle FreeSQL username
- `DB_PASSWORD` - Your Oracle FreeSQL password
- `DB_DSN` - Database connection string (format: host:port/service)
- `SECRET_KEY` - Flask session secret key (change in production)

### Step 5: Initialize the Database
1. Execute the database creation script to set up tables:
   ```bash
   # Connect to your Oracle database and run:
   sqlplus your_username@your_dsn @db/PTDB_Create.sql
   ```

2. (Optional) Load sample data:
   ```bash
   sqlplus your_username@your_dsn @db/PTDB_SampleData.sql
   ```


### Step 6: Run the Application
```bash
# Navigate to backend directory
cd backend

# Start the Flask development server
python app.py
```

The application will be running at `http://localhost:5000/`

---

## Project Structure

```
PersonalTrainingDatabase/
├── backend/
│   └── app.py              # Flask application and API routes
├── frontend/
│   ├── static/
│   │   └── style.css       # Application styling
│   └── templates/
│       ├── login.html      # Login page
│       ├── signup.html     # User registration
│       ├── index.html      # Dashboard/home page
│       ├── change_password.html
│       └── create_user.html
├── db/
│   ├── PTDB_Create.sql     # Database schema creation
│   ├── PTDB_Drop.sql       # Drop all tables
│   ├── PTDB_SampleData.sql # Sample data for testing
│   ├── PTDB_Auth.sql       # Authentication setup
│   └── create_admin.py     # Admin user creation script
├── docs/
│   ├── screenshots/        # UI screenshots and diagrams
│   └── er_diagram.png      # Entity-relationship diagram
├── .env_example.sh         # Example environment configuration
└── README.md               # This file
```

---

## Database Schema

The application uses a relational database with the following main entities:

- **Trainer** - Fitness coaches managing clients
- **Client** - Users following workout plans
- **Gym** - Physical gym locations
- **Exercise** - Individual exercises with targeted muscle groups
- **MuscleGroup** - Body part categories
- **WorkoutPlan** - Structured training programs
- **PlanExercise** - Exercises within a workout plan
- **WorkoutSession** - Completed workout instances
- **PerformanceLog** - Detailed workout metrics
- **BodyMetric** - User body measurements over time
- **Notification** - System notifications

