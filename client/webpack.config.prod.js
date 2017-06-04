/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const merge = require('webpack-merge');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const PurifyCSSPlugin = require('purifycss-webpack');
const glob = require('glob');
const ManifestPlugin = require('webpack-manifest-plugin');
const config = require('./webpack.config.base');

module.exports = merge(config, {
  devtool: 'cheap-module-source-map',
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: 'production' }),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,
      comments: false,
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
    new webpack.LoaderOptionsPlugin({
      minimize: true,
      debug: false
    }),
    new ManifestPlugin(),
  ]
});