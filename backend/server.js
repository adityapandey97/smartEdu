const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const config = require('./config/config');

const authRoutes = require('./routes/auth');
const attendanceRoutes = require('./routes/attendance');
const assignmentRoutes = require('./routes/assignments');
const markRoutes = require('./routes/marks');
const notificationRoutes = require('./routes/notifications');
const quizRoutes = require('./routes/quizzes');
const materialRoutes = require('./routes/materials');
const scheduleRoutes = require('./routes/schedules');
const feedbackRoutes = require('./routes/feedback');
const holidayRoutes = require('./routes/holidays');
const leaveRoutes = require('./routes/leaves');
const eventRoutes = require('./routes/events');

const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api/auth', authRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/assignments', assignmentRoutes);
app.use('/api/marks', markRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/quizzes', quizRoutes);
app.use('/api/materials', materialRoutes);
app.use('/api/schedules', scheduleRoutes);
app.use('/api/feedback', feedbackRoutes);
app.use('/api/holidays', holidayRoutes);
app.use('/api/leaves', leaveRoutes);
app.use('/api/events', eventRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'SmartEdu API is running' });
});

mongoose.connect(config.MONGODB_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('MongoDB connection error:', err));

const PORT = config.PORT;
app.listen(PORT, async () => {
  console.log(`SmartEdu server running on port ${PORT}`);
  const seedData = require('./seed');
  await seedData();
});

module.exports = app;
