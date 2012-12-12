{Tutorial} = require 'zootorial'
{Step} = Tutorial
translate = require 'lib/translate'
$ = require 'jqueryify'

Step::defaultButton = translate 'classify.tutorial.continueButton'

inline = (string) ->
  string = string.replace '\n\n', '_NEWLINE_', 'g'
  string = string.replace '\n', ' ', 'g'
  string = string.replace '_NEWLINE_', '\n', 'g'
  string

module.exports = [
  new Step
    header: inline translate 'classify.tutorial.welcomeHeader'
    content: inline translate 'classify.tutorial.welcome'

  new Step
    header: inline translate 'classify.tutorial.trapsHeader'
    content: inline translate 'classify.tutorial.traps'
    attachment: x: 'left', margin: -10, to: '.subject-viewer', at: x: 'right'
    focus: '.subject-viewer'
    block: 'button[name="finish"]'
    className: 'arrow left'

  new Step
    header: inline translate 'classify.tutorial.taskHeader'
    content: inline translate 'classify.tutorial.task'
    attachment: x: 'right', margin: -10, to: '.animal-selector', at: x: 'left'
    focus: '.animal-selector'
    block: '.animal-selector'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.chooseAntelopeHeader'
    content: inline translate 'classify.tutorial.chooseAntelope'
    nextOn: click: 'button[value="likeAntelopeDeer"]'
    attachment: x: 'right', margin: 10, to: 'button[name="characteristic"][value="like"]', at: x: 'left'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.chooseSolidHeader'
    content: inline translate 'classify.tutorial.chooseSolid'
    nextOn: click: 'button[value="patternSolid"]'
    attachment: x: 'right', margin: 10, to: 'button[name="characteristic"][value="pattern"]', at: x: 'left'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.chooseCurlyHeader'
    content: inline translate 'classify.tutorial.chooseCurly'
    nextOn: click: 'button[value="hornsCurly"]'
    attachment: y: 'top', margin: 10, to: 'button[name="characteristic"][value="horns"]', at: y: 'bottom'
    className: 'arrow up'

  new Step
    header: inline translate 'classify.tutorial.chooseWildebeestHeader'
    content: inline translate 'classify.tutorial.chooseWildebeest'
    nextOn: click: '[data-animal="wildebeest"]'
    attachment: y: 'top', to: '[data-animal="wildebeest"]', at: y: 'bottom'
    className: 'arrow up'

  new Step
    header: inline translate 'classify.tutorial.confirmWildebeestHeader'
    content: inline translate 'classify.tutorial.confirmWildebeest'
    attachment: x: 'right', to: '.animal-details .image-changer', at: x: 'left'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.identifyWildebeestHeader'
    content: inline translate 'classify.tutorial.identifyWildebeest'
    attachment: x: 'right', margin: 10, to: '.animal-details .options', at: x: 'left'
    className: 'arrow right'
    nextOn: click: 'button[name="identify"]'

  new Step
    header: inline translate 'classify.tutorial.findZebrasHeader'
    content: inline translate 'classify.tutorial.findZebras'
    attachment: x: 'left', margin: -10, to: '.subject-viewer', at: x: 'right'
    focus: '.subject-viewer'
    block: 'button[name="finish"]'
    className: 'arrow left'

  new Step
    header: inline translate 'classify.tutorial.typeZebraHeader'
    content: inline translate 'classify.tutorial.typeZebra'
    attachment: x: 'right', margin: 10, to: '.animal-selector .search', at: x: 'left'
    className: 'arrow right'
    nextOn: {} # This is handled by onEnter.

    onEnter: (tutorial, step) ->
      doc = $(document)
      search = $('.animal-selector input[name="search"]')

      doc.on 'keydown.typeZebra', (e) ->
        setTimeout ->
          if search.val().toLowerCase() is 'zebra'
            doc.off 'keydown.typeZebra'
            tutorial.next()

  new Step
    header: inline translate 'classify.tutorial.clickZebraHeader'
    content: inline translate 'classify.tutorial.clickZebra'
    attachment: x: 'right', margin: 10, to: '[data-animal="zebra"]', at: x: 'left'
    nextOn: click: '[data-animal="zebra"]'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.confirmZebraHeader'
    content: inline translate 'classify.tutorial.confirmZebra'
    attachment: x: 'right', to: '.animal-details .image-changer', at: x: 'left'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.identifyZebraHeader'
    content: inline translate 'classify.tutorial.identifyZebra'
    attachment: x: 'right', margin: 10, to: '.animal-details .options', at: x: 'left'
    nextOn: click: 'button[name="identify"]'
    className: 'arrow right'

  new Step
    header: inline translate 'classify.tutorial.finishHeader'
    content: inline translate 'classify.tutorial.finish'
    attachment: y: 'bottom', margin: 10, to: 'button[name="finish"]', at: y: 'top'
    className: 'arrow down'
    nextOn: click: 'button[name="finish"]'
]
