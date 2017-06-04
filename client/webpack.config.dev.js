/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const merge = require('webpack-merge');
const { resolve } = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');
const configPath = resolve('..', 'config');
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader');
const { webpackOutputPath, webpackPublicOutputDir } = webpackConfigLoader(configPath);
const config = require('./webpack.config.base');

module.exports = merge(config, {
  devtool: 'eval-source-map',
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: 'development' }),
    new ExtractTextPlugin('[name].css'),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.LoaderOptionsPlugin({
      minimize: false,
      debug: false
    }),
    new ManifestPlugin(),
    // https://webpack.github.io/docs/list-of-plugins.html#2-explicit-vendor-chunk
    new webpack.optimize.CommonsChunkPlugin({
      // This name 'vendor-bundle' ties into the entry definition
      name: 'vendor-bundle',

      // We don't want the default vendor.js name
      filename: 'vendor-bundle-[hash].js',

      minChunks(module) {
        // this assumes your vendor imports exist in the node_modules directory
        return module.context && module.context.indexOf('node_modules') !== -1;
      },
    }),
  ]
});