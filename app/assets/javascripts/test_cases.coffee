class TestCases
  constructor: ->
    $(document).on "click", "#add-input", ->
      tag = '
        <div id="inputs-container" class="form-group">
          <textarea name="test_case[inputs][]" class="form-control"></textarea>
            <a class="btn pull-right remove-input">
              <i class="fa fa-times"></i>
            </a>
        </div>
      '
      $("#inputs-container").append(tag)

    $(document).on "click", ".remove-input", ->
      $(this).parent().remove()

window.APP ?= {}
window.APP.TestCases = TestCases
