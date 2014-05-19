'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    crypto = require('crypto'),
    validation = require('./validation');

/**
 * User Schema
 */
var UserSchema = new Schema({
  name: String,
  email: {
      type: String,
      unique: true
  },
  role: {
    type: String,
    default: 'user'
  },
  hashedPassword: String,
  provider: String,
  salt: String,
  facebook: {},
  twitter: {},
  github: {},
  google: {},
  active: {
    type: Boolean,
    default: false
  }
});

/**
 * Virtuals
 */
UserSchema
  .virtual('password')
  .set(function(password) {
    this._password = password;
    this.salt = this.makeSalt();
    this.hashedPassword = this.encryptPassword(password);
  })
  .get(function() {
    return this._password;
  });

// Basic info to identify the current authenticated user in the app
UserSchema
  .virtual('userInfo')
  .get(function() {
    return {
      'name': this.name,
      'role': this.role,
      'provider': this.provider
    };
  });

// Public profile information
UserSchema
  .virtual('profile')
  .get(function() {
    return {
      'name': this.name,
      'role': this.role
    };
  });
    
/**
 * Validations
 */

UserSchema.path('email').validate(validation.required, 'Email cannot be blank');
UserSchema.path('hashedPassword').validate(validation.required, 'Password cannot be blank');

var validatePresenceOf = function(value) {
  return value && value.length;
};

/**
 * Pre-save hook
 */
UserSchema
  .pre('save', function(next) {
    if (!this.isNew) return next();

    if (!validatePresenceOf(this.hashedPassword))
      next(new Error('Invalid password'));
    else
      next();
  });

/**
 * Methods
 */
UserSchema.methods = {
  authenticate: function(plainText) {
    return this.encryptPassword(plainText) === this.hashedPassword && this.active;
  },

  makeSalt: function() {
    return crypto.randomBytes(16).toString('base64');
  },

  encryptPassword: function(password) {
    if (!password || !this.salt) return '';
    var salt = new Buffer(this.salt, 'base64');
    return crypto.pbkdf2Sync(password, salt, 10000, 64).toString('base64');
  }
};

module.exports = mongoose.model('User', UserSchema);