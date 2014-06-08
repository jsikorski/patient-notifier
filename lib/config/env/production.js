'use strict';

module.exports = {
  env: 'production',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         'mongodb://localhost/fullstack'
  },
  transport: 'GMAIL',
  transportOptions: {
      port: 465,
      host: "smtp.gmail.com",
      secureConnection: true,
      auth: {
          user: sender,
          pass: "3?'6Xcp=T;l^ed8LXpkN"
      },
      domains: ["gmail.com", "googlemail.com"],
      requiresAuth: true
  }
};