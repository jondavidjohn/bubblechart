# BubbleChart

[![Build Status](https://travis-ci.org/jondavidjohn/bubblechart.png?branch=master,develop)](https://travis-ci.org/jondavidjohn/bubblechart)

BubbleChart is a JavaScript module for the comparative visualization of two dimensional data in bubble chart.

### Why write it in Coffeescript?

I've never worked with coffeescript, decided to give it a spin.

## Usage

To Create a new chart you simple create a new `BubbleChart` Object passing it
your configuration options, then to create the chart, just call `.paint()`

```js
chart = new BubbleChart({

});

chart.paint();
```

### Options

This is the exploded view of possbile options (with included defaults)

```js
  {
    canvasId: "",    // id of target <canvas>
    usedArea: 0.5,   // how much of the canvas you wish to use for bubbles
    data: [],        // Array of data objects (converted into bubbles)
    metric: "",      // String label for your data metric (shown in popover)
    colors: [],      // Array of colors to randomly choose from if data
                     // object lacks fillColor

    fps: 60,              // The draw rate/speed
    borderColor: "",      // Global Bubble border color
    borderSize: 0,        // Global Bubble border size
    textColor: "#fff"     // Bubble label color
    textType: "helvetica" // Font
  }
```

### Data Objects

Data objects are what create the bubbles.  Any of these objects will cascade
options set globally in the main BubbleChart Object.

Each data object's `data` property will determine the size of the bubble in
relation to the rest of the data object's `data` properties.  This is how you
get the visual representation of your data.

```js
  {
    label: "Name of the thing",
    data: 10,
    metric: "this specific metric",
    borderColor: "#FFF",
    borderSize: 3,
  }
```

## Process your own data

Generally speaking, you can use any data source that you can manipulate into
compatible data objects.

## Requirements

  - IE9+ (required `<canvas>` support)
  - **No reliance on any external JavaScript Library**

## Development

see [CONTRIBUTING.md](https://github.com/jondavidjohn/bubblechart/edit/develop/CONTRIBUTING.md)

