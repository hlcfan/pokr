/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const { resolve } = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const autoprefixer = require('autoprefixer');
const ManifestPlugin = require('webpack-manifest-plugin');
const configPath = resolve('..', 'config');
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader');
const { output, settings } = webpackConfigLoader(configPath);
const isHMR = !!settings.dev_server ? settings.dev_server.hmr : false;

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
    filename: isHMR ? '[name]-[hash].js' : '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',

    publicPath: output.publicPath,
    path: output.path,
  },
  devtool: 'eval-source-map',
  resolve: {
    extensions: ['.js', '.jsx', '.css', '.scss'],
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
        test: /\.(woff2?|jpe?g|png|gif|svg|ico|cur)$/,
        loader: 'url-loader',
        options: {
          limit: 10000
        }
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            {
              loader: 'css-loader',
              options: {
                minimize: false,
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
                minimize: false,
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
    new webpack.EnvironmentPlugin({ NODE_ENV: process.env.NODE_ENV }),
    new ExtractTextPlugin({
      filename: '[name]-[hash].css',
      allChunks: true
    }),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.LoaderOptionsPlugin({
      minimize: false,
      debug: false
    }),
    new ManifestPlugin({
      publicPath: output.publicPath,
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
  ]
}