// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "output" ];

  connect() {
    // console.log("The 'mood' controller is now loaded!");
  }

  enable() {
    // console.log("The 'enable' action was triggered!");
    let emoji = (document.getElementById('mood_rating_1').checked || document.getElementById('mood_rating_2').checked || document.getElementById('mood_rating_3').checked || document.getElementById('mood_rating_4').checked || document.getElementById('mood_rating_5').checked || (document.getElementById('mood_rating_6').checked));
    let journal = (document.getElementById('mood_journal_entry').value)
    if (emoji && journal) {
      document.querySelector(".btn-gradient").disabled = false;
    }
  }
}
