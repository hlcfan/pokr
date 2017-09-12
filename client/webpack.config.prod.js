/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const merge = require('webpack-merge');
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const autoprefixer = require('autoprefixer');
const PurifyCSSPlugin = require('purifycss-webpack');
const glob = require('glob');
const ManifestPlugin = require('webpack-manifest-plugin');
const config = require('./webpack.config.base');

module.exports = merge.smart(config, {
  devtool: 'cheap-module-source-map',
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                minimize: true,
                modules: true,
                importLoaders: 1,
                localIdentName: 'prf_[local]__[hash:base64:5]',
              },
            },
            {
              loader: 'postcss-loader', options: {
                plugins: [autoprefixer]
            }}
          ],
        }),
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                minimize: true,
                modules: true,
                importLoaders: 3,
                localIdentName: 'prf_[local]__[hash:base64:5]',
              },
            },
            {
              loader: 'postcss-loader',
              options: {
                plugins: 'autoprefixer'
              }
            },
            {
              loader: 'sass-loader',
            }
          ],
        }),
      },
    ]
  },
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
    new ExtractTextPlugin({
      filename: '[name]-[hash].css',
      allChunks: true
    }),
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
        whitelist: ['*polyfill*', '*prf*'],
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
    new ManifestPlugin({
      publicPath: config.output.publicPath,
      writeToFileEmit: true
    }),
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
