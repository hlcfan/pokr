module.exports = {
  "moduleNameMapper": {
    "^libs(.*)$": "<rootDir>/app/libs$1",
    "\\.(css|less)$": "identity-obj-proxy",
    "\\.(ico|jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$": "<rootDir>/__mocks__/fileMock.js",
  },
  "coveragePathIgnorePatterns": [
    "spec/fixture",
  ]
}