/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const PurifyCSSPlugin = require('purifycss-webpack');
const glob = require('glob');

const config = {
  entry: [
    'es5-shim/es5-shim',
    'es5-shim/es5-sham',
    'babel-polyfill',
    './app/bundles/Room/startup/registration',
  ],

  output: {
    filename: 'webpack-bundle.js',
    path: path.resolve(__dirname, '../app/assets/webpack'),
  },

  devtool: 'cheap-module-source-map',

  resolve: {
    extensions: ['.js', '.jsx'],
    alias: {
      libs: path.resolve(__dirname, 'app/libs')
    }
  },
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: 'production' }),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,
      compressor: {
        warnings: false
      }
    }),
    new webpack.optimize.AggressiveMergingPlugin(),
    new ExtractTextPlugin('[name].css'),
    new PurifyCSSPlugin({
      moduleExtensions: [
        '.html',
        '.js',
        '.jsx',
      ],
      paths: glob.sync(path.resolve(__dirname, 'client/app/**/*.{js,jsx,html}')),
      purifyOptions: {
        minify: true,
        info: true,
        whitelist: ['*polyfill*'],
      },
      styleExtensions: [
        '.css',
        '.scss',
      ],
    }),
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