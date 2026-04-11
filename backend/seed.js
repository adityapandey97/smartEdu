const bcrypt = require('bcryptjs');

let User, Attendance, Assignment, Submission, Mark, Material, Notification, Schedule, Quiz, QuizResult, Feedback, Holiday, LeaveApplication, Event;

const initModels = () => {
  User = require('./models/User');
  Attendance = require('./models/Attendance');
  Assignment = require('./models/Assignment');
  Submission = require('./models/Submission');
  Mark = require('./models/Mark');
  Material = require('./models/Material');
  Notification = require('./models/Notification');
  Schedule = require('./models/Schedule');
  Quiz = require('./models/Quiz');
  QuizResult = require('./models/QuizResult');
  Feedback = require('./models/Feedback');
  Holiday = require('./models/Holiday');
  LeaveApplication = require('./models/LeaveApplication');
  Event = require('./models/Event');
};

const seedData = async () => {
  try {
    initModels();
    const existingUser = await User.findOne({ email: 'student@test.com' });
    if (existingUser) {
      console.log('Seed data already exists');
      return;
    }

    const hashedPassword = await bcrypt.hash('password123', 10);

    const student = new User({
      name: 'John Doe',
      email: 'student@test.com',
      password: hashedPassword,
      role: 'student',
      studentId: 'STU001',
      department: 'Computer Science',
      semester: 5,
      subjects: ['DBMS', 'Operating Systems', 'Computer Networks', 'Software Engineering']
    });
    await student.save();

    const teacher = new User({
      name: 'Prof. Smith',
      email: 'teacher@test.com',
      password: hashedPassword,
      role: 'teacher',
      department: 'Computer Science',
      subjects: ['DBMS', 'Operating Systems']
    });
    await teacher.save();

    const attendanceData = [
      { studentId: student._id, subject: 'DBMS', date: new Date('2026-03-01'), status: 'present' },
      { studentId: student._id, subject: 'DBMS', date: new Date('2026-03-03'), status: 'present' },
      { studentId: student._id, subject: 'DBMS', date: new Date('2026-03-05'), status: 'absent' },
      { studentId: student._id, subject: 'DBMS', date: new Date('2026-03-07'), status: 'present' },
      { studentId: student._id, subject: 'DBMS', date: new Date('2026-03-09'), status: 'present' },
      { studentId: student._id, subject: 'Operating Systems', date: new Date('2026-03-02'), status: 'present' },
      { studentId: student._id, subject: 'Operating Systems', date: new Date('2026-03-04'), status: 'present' },
      { studentId: student._id, subject: 'Operating Systems', date: new Date('2026-03-06'), status: 'present' },
      { studentId: student._id, subject: 'Operating Systems', date: new Date('2026-03-08'), status: 'absent' },
      { studentId: student._id, subject: 'Computer Networks', date: new Date('2026-03-01'), status: 'present' },
      { studentId: student._id, subject: 'Computer Networks', date: new Date('2026-03-03'), status: 'present' },
      { studentId: student._id, subject: 'Computer Networks', date: new Date('2026-03-05'), status: 'present' },
    ];
    await Attendance.insertMany(attendanceData);

    const assignment1 = new Assignment({
      title: 'DBMS Project',
      description: 'Create a database design for a college management system',
      subject: 'DBMS',
      deadline: new Date('2026-04-20'),
      createdBy: teacher._id
    });
    await assignment1.save();

    const assignment2 = new Assignment({
      title: 'OS Case Study',
      description: 'Write about process scheduling algorithms',
      subject: 'Operating Systems',
      deadline: new Date('2026-04-15'),
      createdBy: teacher._id
    });
    await assignment2.save();

    const submission = new Submission({
      assignmentId: assignment1._id,
      studentId: student._id,
      content: 'I have completed the database design with proper normalization',
      status: 'submitted'
    });
    await submission.save();

    const marksData = [
      { studentId: student._id, subject: 'DBMS', examType: 'Mid Term', marks: 75, total: 100, uploadedBy: teacher._id },
      { studentId: student._id, subject: 'DBMS', examType: 'Quiz 1', marks: 8, total: 10, uploadedBy: teacher._id },
      { studentId: student._id, subject: 'Operating Systems', examType: 'Mid Term', marks: 68, total: 100, uploadedBy: teacher._id },
      { studentId: student._id, subject: 'Operating Systems', examType: 'Quiz 1', marks: 7, total: 10, uploadedBy: teacher._id },
      { studentId: student._id, subject: 'Computer Networks', examType: 'Mid Term', marks: 82, total: 100, uploadedBy: teacher._id },
    ];
    await Mark.insertMany(marksData);

    const material1 = new Material({
      title: 'DBMS Lecture 1',
      type: 'ppt',
      subject: 'DBMS',
      fileUrl: 'https://example.com/dbms-lecture1.ppt',
      description: 'Introduction to Database Management Systems',
      uploadedBy: teacher._id
    });
    await material1.save();

    const material2 = new Material({
      title: 'SQL Cheat Sheet',
      type: 'notes',
      subject: 'DBMS',
      fileUrl: 'https://example.com/sql-cheatsheet.pdf',
      description: 'Quick reference guide for SQL queries',
      uploadedBy: teacher._id
    });
    await material2.save();

    const scheduleData = [
      { dayOfWeek: 1, period: 1, subject: 'DBMS', teacherName: 'Prof. Smith', room: 'Room 101' },
      { dayOfWeek: 1, period: 2, subject: 'Operating Systems', teacherName: 'Prof. Smith', room: 'Room 102' },
      { dayOfWeek: 1, period: 3, subject: 'Computer Networks', teacherName: 'Prof. Johnson', room: 'Room 103' },
      { dayOfWeek: 2, period: 1, subject: 'Software Engineering', teacherName: 'Prof. Davis', room: 'Room 101' },
      { dayOfWeek: 2, period: 2, subject: 'DBMS Lab', teacherName: 'Prof. Smith', room: 'Lab 1' },
      { dayOfWeek: 3, period: 1, subject: 'Operating Systems', teacherName: 'Prof. Smith', room: 'Room 102' },
      { dayOfWeek: 3, period: 2, subject: 'DBMS', teacherName: 'Prof. Smith', room: 'Room 101' },
      { dayOfWeek: 4, period: 1, subject: 'Computer Networks', teacherName: 'Prof. Johnson', room: 'Room 103' },
      { dayOfWeek: 4, period: 2, subject: 'Software Engineering', teacherName: 'Prof. Davis', room: 'Room 101' },
      { dayOfWeek: 5, period: 1, subject: 'DBMS', teacherName: 'Prof. Smith', room: 'Room 101' },
      { dayOfWeek: 5, period: 2, subject: 'Operating Systems', teacherName: 'Prof. Smith', room: 'Room 102' },
    ];
    await Schedule.insertMany(scheduleData);

    const quiz = new Quiz({
      title: 'DBMS Fundamentals Quiz',
      subject: 'DBMS',
      duration: 15,
      questions: [
        { question: 'What is a primary key?', options: ['A unique identifier', 'A foreign key', 'An index', 'A constraint'], correctAnswer: 0 },
        { question: 'Which normal form removes transitive dependencies?', options: ['1NF', '2NF', '3NF', 'BCNF'], correctAnswer: 2 },
        { question: 'SQL stands for?', options: ['Structured Query Language', 'Simple Query Language', 'Standard Query Language', 'System Query Language'], correctAnswer: 0 },
        { question: 'What does DDL stand for?', options: ['Data Definition Language', 'Data Manipulation Language', 'Data Control Language', 'Data Query Language'], correctAnswer: 0 },
        { question: 'Which join returns all rows when there is a match in either table?', options: ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL OUTER JOIN'], correctAnswer: 3 },
      ],
      createdBy: teacher._id
    });
    await quiz.save();

    const notifications = [
      { userId: student._id, type: 'attendance', title: 'Attendance Alert', message: 'Your attendance in DBMS is below 75%', read: false },
      { userId: student._id, type: 'assignment', title: 'New Assignment', message: 'DBMS Project assignment has been posted', read: false },
      { role: 'all', type: 'holiday', title: 'Holiday', message: 'Tomorrow is a holiday - Holi Celebration!', read: false },
    ];
    await Notification.insertMany(notifications);

    const holiday = new Holiday({
      title: 'Holi Festival',
      date: new Date('2026-04-14'),
      reason: 'Holi Celebration'
    });
    await holiday.save();

    const event = new Event({
      title: 'Tech Fest 2026',
      description: 'Annual technical festival with coding competitions and workshops',
      date: new Date('2026-04-25'),
      venue: 'Main Auditorium',
      maxParticipants: 100
    });
    await event.save();

    console.log('Seed data inserted successfully!');
    console.log('Student login: student@test.com / password123');
    console.log('Teacher login: teacher@test.com / password123');

  } catch (error) {
    console.error('Error seeding data:', error);
  }
};

module.exports = seedData;
