'use strict';

module.exports = {
  env: 'test',
  mongo: {
    uri: 'mongodb://localhost/fullstack-test'
  },
  transport: 'PICKUP',
  transportOptions: {
      directory: 'C:\\Pickup'
  }
};