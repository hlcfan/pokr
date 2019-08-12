/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');
const { resolve } = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const autoprefixer = require('autoprefixer');
const PurifyCSSPlugin = require('purifycss-webpack');
const glob = require('glob');
const ManifestPlugin = require('webpack-manifest-plugin');
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader');
const configPath = resolve('..', 'config');
const { output, settings } = webpackConfigLoader(configPath);
const isHMR = !!settings.dev_server ? settings.dev_server.hmr : false;

module.exports = {
  mode: 'production',
  entry: {
    'vendor-bundle': [
      'babel-polyfill'
    ],
    'app-bundle': [
      './app/bundles/Room/startup/registration',
    ]
  },
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        sourceMap: true,
        uglifyOptions: {
          comments: false,
          warnings: false
        },
      }),
    ],
    splitChunks: {
      cacheGroups: {
        vendor: {
          chunks: "initial",
          test: "vendor-bundle",
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
  devtool: 'cheap-module-source-map',
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
              hmr: false
            }
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
              hmr: false,
            }
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
            loader: 'sass-loader'
          }
        ]
      }
    ]
  },
  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: 'production' }),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.AggressiveMergingPlugin(),
    new MiniCssExtractPlugin({
      filename: '[name]-[hash].css',
      allChunks: true
    }),
    new PurifyCSSPlugin({
      moduleExtensions: [
        '.html',
        '.js',
        '.jsx',
      ],
      paths: glob.sync(resolve(__dirname, 'client/app/**/*.{js,jsx,html}')),
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
      publicPath: output.publicPath,
      writeToFileEmit: true
    }),
    // new webpack.optimize.CommonsChunkPlugin({
    //   // This name 'vendor-bundle' ties into the entry definition
    //   name: 'vendor-bundle',

    //   // We don't want the default vendor.js name
    //   filename: 'vendor-bundle-[hash].js',

    //   minChunks(module) {
    //     // this assumes your vendor imports exist in the node_modules directory
    //     return module.context && module.context.indexOf('node_modules') !== -1;
    //   },
    // }),
  ]
}
