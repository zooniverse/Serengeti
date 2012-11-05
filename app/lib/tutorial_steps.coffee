{Tutorial} = require 'zootorial'
translate = require 'lib/translate'

class Step extends Tutorial.Step
  defaultButton: translate 'classify.tutorial.continueButton'

inline = (string) ->
  string = string.replace '\n\n', '_NEWLINE_', 'g'
  string = string.replace '\n', ' ', 'g'
  string = string.replace '_NEWLINE_', '\n', 'g'
  string

# TODO: Drop all these strings into en_us.coffee.

module.exports = [
  new Step
    content: inline translate 'classify.tutorial.welcome'

  new Step
    content: inline translate 'classify.tutorial.traps'
    attachment: x: 'left', to: '.subject-viewer', at: x: 'right'
    focus: '.subject-viewer'
    block: 'button[name="finish"]'
    className: 'arrow left'

  new Step
    content: inline translate 'classify.tutorial.task'
    attachment: x: 'right', to: '.animal-selector', at: x: 'left'
    focus: '.animal-selector'
    block: '.animal-selector'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.chooseAntelope'
    nextOn: click: 'button[value="likeAntelopeDeer"]'
    attachment: x: 'right', to: 'button[name="characteristic"][value="like"]', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.chooseSolid'
    nextOn: click: 'button[value="patternSolid"]'
    attachment: x: 'right', to: 'button[name="characteristic"][value="pattern"]', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.chooseBrown'
    nextOn: click: 'button[value="coatBrownBlack"]'
    attachment: y: 'top', to: 'button[name="characteristic"][value="coat"]', at: y: 'bottom'
    className: 'arrow up'

  new Step
    content: inline translate 'classify.tutorial.chooseWildebeest'
    nextOn: click: '[data-animal="wildebeest"]'
    attachment: y: 'top', to: '[data-animal="wildebeest"]', at: y: 'bottom'
    className: 'arrow up'

  new Step
    content: inline translate 'classify.tutorial.confirmWildebeest'
    attachment: x: 'right', to: '.animal-details .image-changer', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.identifyWildebeest'
    attachment: x: 'right', to: '.animal-details .options', at: x: 'left'
    className: 'arrow right'
    nextOn: click: 'button[name="identify"]'

  new Step
    content: inline translate 'classify.tutorial.findZebras'
    attachment: x: 'left', to: '.subject-viewer', at: x: 'right'
    focus: '.subject-viewer'
    block: 'button[name="finish"]'
    className: 'arrow left'

  new Step
    content: inline translate 'classify.tutorial.typeZebra'
    attachment: x: 'right', to: '.animal-selector .search', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.clickZebra'
    attachment: x: 'right', to: '[data-animal="zebra"]', at: x: 'left'
    nextOn: click: '[data-animal="zebra"]'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.confirmZebra'
    attachment: x: 'right', to: '.animal-details .image-changer', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.identifyZebra'
    attachment: x: 'right', to: '.animal-details .options', at: x: 'left'
    nextOn: click: 'button[name="identify"]'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.finish'
    attachment: y: 'bottom', to: 'button[name="finish"]', at: y: 'top'
    className: 'arrow down'
    nextOn: click: 'button[name="finish"]'
]

###
  welcome
  traps
  task
  chooseAntelope
  chooseSolid
  chooseBrown
  chooseWildebeest
  confirmWildebeest
  identifyWildebeest
  findZebras
  typeZebra
  clickZebra
  confirmZebra
  identifyZebra
  finish
###
