const { environment } = require('@rails/webpacker')
const { resolve } = require('path');

environment.config.merge({
  resolve: {
    extensions: ['.js', '.jsx', '.css', '.scss'],
    alias: {
      libs: resolve('app/javascript/react/libs')
    }
    // fallback: {
    //   fs: false
    // }
  },
  entry: {
    'vendor-bundle': [
      '@babel/polyfill'
    ],
    // 'app-bundle': [
    //   resolve('app/javascript/react/bundles/Room/containers/Room'),
    // ]
  },
})

module.exports = environment
