export const defaultTourColor = {
      mainColor: '#31b0d5',
      beacon: {
        inner: '#31b0d5',
        outer: '#269abc',
      }
    }
const barColors = {
  // 0 1 2 3 4 5 6 7 8 13 21 40 100 ? coffee XS S M L XL XXL
  "coffee": "#000532",
  "?": "#376182",
  "100": "#5e6370",
  "40":  "#a4a0a2",
  "XXL": "#a4a0a2",
  "21":  "#ff4265",
  "13":  "#07adeb",
  "XL":  "#07adeb",
  "8":   "#287d85",
  "7":   "#66CCCC",
  "L":   "#66CCCC",
  "6":   "#78bac2",
  "5.5": "#96b5ab",
  "5":   "#a7cabe",
  "M":   "#a7cabe",
  "4.5": "#9ac8d0",
  "4":   "#acdfe8",
  "3.5": "#a2d6a2",
  "3":   "#b4eeb4",
  "2.5": "#b6da9b",
  "2":   "#cbf3ad",
  "1.5": "#ffc0cb",
  "1":   "#ffc0cb",
  "0.5": "#e5cdca",
  "S":   "#ffc0cb",
  "0":   "#ffe4e1",
  "XS":  "#ffe4e1",
}

const pointEmojis = {
  "coffee": "☕",
  "null" : "skipped"
}

export default {
  color(point) {
    return barColors[point]
  },

  randomColor() {
    let randomIndex = Math.floor(Math.random() * 27)
    return Object.values( barColors )[randomIndex]
  },

  emoji(point) {
    return pointEmojis[point]
  }
}

// Blue:
// style: {
  // mainColor: '#31b0d5',
  // beacon: {
  //   inner: '#31b0d5',
  //   outer: '#269abc',
  // },
// }

// Orange:
// style: {
//   mainColor: '#f07b50',
//   beacon: {
//     inner: '#f07b50',
//     outer: '#f07b50',
//   },
// },


// Red:
// Default
