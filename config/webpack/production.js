process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

environment.config.merge({
  mode: 'production',
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
  }
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
console.log(environment.toWebpackConfig())
module.exports = environment.toWebpackConfig()

// module.exports = webpackConfig
