// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "controllers"
import "bootstrap"
import "chartkick/highcharts"

const Chartkick = require("chartkick");
Chartkick.use(require("highcharts"));

Chartkick.options = {
  library: {"plotOptions": {
    "series": {
      enableMouseTracking: false,
      "pointWidth": 30,
      "dataLabels": {
        useHTML: true,
        enabled: true,
        crop: false,
        overflow: 'allow',
        formatter: function() {
          if (this.y === 1)  {return "😢"}
          else if (this.y === 2)  {return "💩"}
          else if (this.y === 3)  {return "😡"}
          else if (this.y === 4)  {return "😐"}
          else if (this.y === 5)  {return "☺️"}
          else if (this.y === 5)  {return "😀"}
          },
        style: {
          fontFamily: 'Montserrat',
          fontWeight: 400,
          fontSize: '16px',
          color: '#614BA5',
          chart: {
            backgroundColor: null,
          },
        }
      }
    }
  }}
}
