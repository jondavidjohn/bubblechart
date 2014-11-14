# BubbleChart

[![Build Status (master,develop)](https://travis-ci.org/jondavidjohn/bubblechart.png?branch=master,develop)](https://travis-ci.org/jondavidjohn/bubblechart)

BubbleChart is a JavaScript module for comparative visualization of two dimensional data in a bubble chart.

## Usage

To Create a new chart you simple create a new `BubbleChart` Object passing it
your configuration options, then to create the chart, just call `.paint()`

```js
var chart = new BubbleChart({
  canvasId: "bubblechart",
  metric: "Kb",
  usedArea: 0.35,
  contain: true,
  popoverOpts: {
    textFont: "Open Sans",
  },
  data : myCustomData()
});
chart.paint();
```

### Options

This is the exploded view of possbile options (with included defaults)

```js
{
  canvasId: "",      // id of target <canvas>
  usedArea: 0.5,     // how much of the canvas you wish to use for bubbles
  data: [],          // Array of data objects (converted into bubbles)
  metric: "",        // Label for your data metric (shown in popover)
  attribution: true, // controls "(Powered by BubbleChart)"
  fillColors: [],    // Array of colors to randomly choose from if data
                     // object lacks fillColor

  contain: false,       // keep bubbles within the canvas
  gutter: 0,            // containment gutter
  borderColor: "",      // Global Bubble border color
  borderSize: 0,        // Global Bubble border size
  textColor: "#fff"     // Bubble label color
  textType: "helvetica" // Font

  popoverOpts: {           // Control the look of the hover popover
    textFont: 'helvetica',
    textColor: '#fff',
    fillColor: '#333',
    labelSize: 22,         // Popover Heading size
    metricSize: 14,        // Popover Metric size
    opacity: 0.6,
    popoverShowData: true  // Show the data value of the bubble in the popover
  }
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
  img_src: 'http://.../someImage.jpg'
}
```

#### Images

You can provide an image to be centered within the bubble by providing
a `img_src` property in your data objects.  **Keep in mind the following:**

  - Images are expected to be square, it will try to be smart and crop the
  image respecting width over height, but providing square images will take
  the guess work out of it.
  - Images will be used at full size if the width of the image is less than
  80% of the bubble diameter.
  - Bubbles will be sized down to fit no more than 80% of the bubble area
  - You can specify a `img_area` to adjust the display

Example of a data object with an image covering 60% of the bubble:

```js
{
  label: "Name of the thing",
  data: 10,
  img_src: 'http://.../image.jpg'
  img_area: 0.6
}
```

##### Retina

If your `img_src` value contains `@2x` it will be treated as a retina image and
be downsized (by 2) for display.

If you do not specify `@2x` images, and the client pixel density is greater
than 1, this module will reduce the image size to prefer image clarity over size.

#### Loading Spinner

There is a provided Spinner object you can use to show a loading animation if
loading your custom data is a time consuming process.

Example

```js
var chart = new BubbleChart({
  canvasId: "bubblechart",
  metric: "Kb",
  usedArea: 0.35,
  contain: true,
  popoverOpts: {
    textFont: "Open Sans",
  }
});

chart.spinner.start();
chart.data = myCustomData();
chart.reload()
chart.spinner.stop();
chart.paint();
```

## Requirements

  - IE9+ (required `<canvas>` support)
  - **No reliance on any external JavaScript Library**

## Development

see [CONTRIBUTING.md](https://github.com/jondavidjohn/bubblechart/blob/develop/CONTRIBUTING.md)

