process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const webpackConfig = require('./environment')

module.exports = webpackConfig
