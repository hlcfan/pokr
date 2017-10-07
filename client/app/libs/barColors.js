export const defaultTourColor = {
      mainColor: '#31b0d5',
      beacon: {
        inner: '#31b0d5',
        outer: '#269abc',
      }
    }
const barColors = {
  // 0 1 2 3 4 5 6 7 8 13 20 40 100 ? coffee
  "coffee": "#000532",
  "?": "#376182",
  "100": "#5e6370",
  "40":  "#a4a0a2",
  "20":  "#ff4265",
  "13":  "#07adeb",
  "8":   "#287d85",
  "7":   "#66CCCC",
  "6":   "#78bac2",
  "5":   "#a7cabe",
  "4":   "#acdfe8",
  "3":   "#b4eeb4",
  "2":   "#cbf3ad",
  "1":   "#ffc0cb",
  "0":   "#ffe4e1"
}

const pointEmojis = {
  "coffee": "☕",
  "null" : "skipped"
}

export default {
  color(point) {
    return barColors[point]
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
