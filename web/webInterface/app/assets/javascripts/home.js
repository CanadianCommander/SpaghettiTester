// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

//add a test argument to the test form
function addTestArgument() {
  let newArg = $("#argument-group-source").clone();
  newArg.attr("id", null);
  $("#argument-list").append(newArg);
  newArg.css("display", "flex");
}

//remove test argument from the test form
function removeTestArgument(target) {
  $(target).closest(".argument-group").remove();
}
