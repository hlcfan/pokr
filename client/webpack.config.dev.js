/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const { resolve } = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');
const configPath = resolve('..', 'config');
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader');
const { webpackOutputPath, webpackPublicOutputDir } = webpackConfigLoader(configPath);
const { manifest } = webpackConfigLoader(configPath);

const config = {
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
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: 'development' }),
    new ExtractTextPlugin('[name].css'),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.LoaderOptionsPlugin({
      minimize: false,
      debug: false
    }),
    new ManifestPlugin({
      fileName: manifest,
      writeToFileEmit: true
    }),
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
  ],
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
    ],
  },
};

module.exports = config;