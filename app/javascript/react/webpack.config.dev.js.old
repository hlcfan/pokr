/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const { resolve } = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');
const configPath = resolve('..', 'config');
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader');
const { output, settings } = webpackConfigLoader(configPath);
const isHMR = !!settings.dev_server ? settings.dev_server.hmr : false;

module.exports = {
  mode: "development",
  entry: {
    'vendor-bundle': [
      'babel-polyfill'
    ],
    'app-bundle': [
      './app/bundles/Room/startup/registration',
    ],
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        vendor: {
          chunks: "initial",
          test: /[\\/]node_modules[\\/]/,
          name: "vendor-bundle",
          enforce: true
        }
      }
    }
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
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              // only enable hot in development
              hmr: true,
              // if hmr does not work, this is a forceful method.
              reloadAll: true,
            },
          },
          {
            loader: 'css-loader',
            options: {
              modules: {
                localIdentName: 'prf_[local]__[hash:base64:5]',
              },
              importLoaders: 1,
            },
          },
          {
            loader: 'postcss-loader',
            options: {
              plugins: [
                require('autoprefixer')
              ]
            }
          }
        ],
      },
      {
        test: /\.scss$/,
        use: [
            {
              loader: MiniCssExtractPlugin.loader,
              options: {
                // only enable hot in development
                hmr: true,
                // if hmr does not work, this is a forceful method.
                reloadAll: true,
              },
            },
            {
              loader: 'css-loader',
              options: {
                modules: {
                  localIdentName: 'prf_[local]__[hash:base64:5]',
                },
                importLoaders: 3,
              },
            },
            {
              loader: 'postcss-loader',
              options: {
                plugins: [
                  require('autoprefixer')
                ]
              }
            },
            {
              loader: 'sass-loader',
            }
          ],
        },
    ]
  },
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: process.env.NODE_ENV }),
    new MiniCssExtractPlugin({
      filename: '[name]-[hash].css',
      allChunks: true
    }),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.LoaderOptionsPlugin({
      debug: false
    }),
    new ManifestPlugin({
      publicPath: output.publicPath,
      writeToFileEmit: true
    }),
  ]
}
