module.exports = {
  JWT_SECRET: 'smartedu_secret_key_2024',
  JWT_EXPIRES_IN: '7d',
  PORT: process.env.PORT || 5000,
  MONGODB_URI: process.env.MONGODB_URI || 'mongodb://localhost:27017/smartedu'
};
