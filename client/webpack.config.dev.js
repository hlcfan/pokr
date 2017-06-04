/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const pathLib = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

const config = {
  entry: [
    'es5-shim/es5-shim',
    'es5-shim/es5-sham',
    'babel-polyfill',
    './app/bundles/Room/startup/registration',
  ],

  output: {
    filename: 'webpack-bundle.js',
    path: pathLib.resolve(__dirname, '../app/assets/webpack'),
  },

  devtool: 'eval-source-map',

  resolve: {
    extensions: ['.js', '.jsx'],
    alias: {
      libs: pathLib.resolve(__dirname, 'app/libs')
    }
  },
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: 'development' }),
    new ExtractTextPlugin('[name].css'),
    new webpack.NoEmitOnErrorsPlugin()
  ],
  module: {
    rules: [
      {
        test: require.resolve('react'),
        use: {
          loader: 'imports-loader',
          options: {
            shim: 'es5-shim/es5-shim',
            sham: 'es5-shim/es5-sham',
          }
        },
      },
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
    ],
  },
};

module.exports = config;