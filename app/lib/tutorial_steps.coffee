translate = require 'lib/translate'
{Tutorial} = require 'zootorial'
{Step} = Tutorial

inline = (string) ->
  string = string.replace '\n\n', '_NEWLINE_', 'g'
  string = string.replace '\n', ' ', 'g'
  string = string.replace '_NEWLINE_', '\n', 'g'
  string

Step::defaultButton = translate 'classify.tutorial.continueButton'

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
    content: inline translate 'classify.tutorial.chooseHorse'
    nextOn: click: 'button[value="likeCowHorse"]'
    attachment: x: 'right', to: 'button[name="characteristic"][value="like"]', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.chooseStripes'
    nextOn: click: 'button[value="patternVerticalStripe"]'
    attachment: x: 'right', to: 'button[name="characteristic"][value="pattern"]', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline translate 'classify.tutorial.chooseZebra'
    nextOn: click: '[data-animal="zebra"]'
    attachment: y: 'top', to: '[data-animal="zebra"]', at: y: 'bottom'
    className: 'arrow up'

  new Step
    content: inline translate 'classify.tutorial.confirmZebra'
    attachment: x: 'right', to: '.animal-details .image-changer', at: x: 'left'
    className: 'arrow right'

  new Step
    content: translate 'classify.tutorial.identifyZebra'
    attachment: x: 'right', to: '.animal-details .options', at: x: 'left'
    className: 'arrow right'
    nextOn: click: 'button[name="identify"]'

  new Step
    content: inline translate 'classify.tutorial.finish'
    attachment: y: 'bottom', to: 'button[name="finish"]', at: y: 'top'
    className: 'arrow down'
    nextOn: click: 'button[name="finish"]'
]
