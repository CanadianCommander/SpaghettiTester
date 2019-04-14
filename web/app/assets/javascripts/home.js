// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
var testUpdateIntervalId = null

//add a test argument to the test form
function addTestArgument() {
  let newArg = $("#argument-group-source").clone()
  newArg.attr("id", null);
  $("#argument-list").append(newArg);
  newArg.css("display", "flex");
}

//remove test argument from the test form
function removeTestArgument(target) {
  $(target).closest(".argument-group").remove()
}

// updates the test output and checks for complete
function updateTest() {
  $.ajax({
    url: 'updateTestStatus',
    method: 'post',
    data: {
      uuid: $("#test-uuid").attr('content')
    },
    success: function (data) {
      if (data.line !== undefined) {
        $("#test-output").val($("#test-output").val() + data.line)
      }

      if (data.complete) {
        if (data.success)
        {
          $(".content_area").css("background-color", "#33bb33bb")
        }
        else
        {
          $(".content_area").css("background-color", "#bb3333bb")
        }
        window.clearInterval(testUpdateIntervalId)
      }

    }
  })
}

$(document).ready(function () {
  if ($("#test-uuid").length > 0)
  {
    testUpdateIntervalId = window.setInterval(updateTest, 500)
  }
})
