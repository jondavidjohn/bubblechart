# bubblechartjs

```html
  <canvas id="my-bubblechart" height="500" width="600"></canvas>
```

```js

(function() {
  var chart = new BubbleChart({
    canvasId: "my-bubblechart",
    dataInterface: new BCI_Github()
    colorPalette: ...
  });

  chart.reload();
  chart.refresh();
})();

```
