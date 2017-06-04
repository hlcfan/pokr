/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const { resolve } = require('path');
const configPath = resolve('..', 'config');
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader');
const { webpackOutputPath, webpackPublicOutputDir } = webpackConfigLoader(configPath);
const { manifest } = webpackConfigLoader(configPath);

module.exports = {
  entry: {
    'vendor-bundle': [
      'babel-polyfill'
    ],
    'app-bundle': [
      './app/bundles/Room/startup/registration',
    ]
  },

  output: {
    filename: '[name]-[hash].js',
    // Leading and trailing slashes ARE necessary.
    publicPath: '/' + webpackPublicOutputDir + '/',
    path: webpackOutputPath,
  },

  devtool: 'eval-source-map',

  resolve: {
    extensions: ['.js', '.jsx'],
    alias: {
      libs: resolve(__dirname, 'app/libs')
    }
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        use: 'babel-loader',
        exclude: /node_modules/,
      },
      {
        test: /\.(woff2?|jpe?g|png|gif|svg|ico)$/,
        loader: 'url-loader',
        options: {
          limit: 10000
        }
      },
    ]
  },
};