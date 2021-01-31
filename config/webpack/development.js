// const MiniCssExtractPlugin = require('mini-css-extract-plugin');

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

environment.config.merge({
  mode: 'development',
  module: {
    rules: [
    //   {
    //     test: /\.jsx?$/,
    //     use: 'babel-loader',
    //     exclude: /node_modules/,
    //   },
      {
        test: /\.(woff2?|jpe?g|png|gif|svg|ico|cur)$/,
        loader: 'url-loader',
        options: {
          limit: 10000
        }
      },
    ]
  },
  plugins: [
    new BundleAnalyzerPlugin()
  ]
  // plugins: [
    // new webpack.EnvironmentPlugin({ NODE_ENV: process.env.NODE_ENV }),
    // new MiniCssExtractPlugin({
    //   filename: '[name]-[hash].css',
    //   // allChunks: true
    // }),
    // new webpack.NoEmitOnErrorsPlugin(),
    // new webpack.LoaderOptionsPlugin({
    //   debug: false
    // }),
    // new ManifestPlugin({
    //   publicPath: output.publicPath,
    //   writeToFileEmit: true
    // }),
  // ]
})

const cssRule = environment.loaders.get('css')
const cssLoader = cssRule.use.find(loader => loader.loader === 'css-loader')

cssLoader.options = Object.assign(cssLoader.options, {
  modules: {
    localIdentName: 'prf_[local]__[hash:base64:5]',
  },
  importLoaders: 3,
})

// console.log("===Loaders: ", environment.loaders)
const scssRule = environment.loaders.get('sass')
const scssLoader = scssRule.use.find(loader => loader.loader === 'css-loader')

scssLoader.options = Object.assign(scssLoader.options, {
  modules: {
    localIdentName: 'prf_[local]__[hash:base64:5]',
  },
  importLoaders: 3,
})

// console.log(environment.toWebpackConfig().module.rules[2].use)
// console.log(environment.toWebpackConfig().module.rules[3].use)
// console.log(environment.toWebpackConfig().module.rules)
module.exports = environment.toWebpackConfig()

