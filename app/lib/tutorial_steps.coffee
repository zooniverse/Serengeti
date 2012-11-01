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
    content: inline '''
      Welcome to Snapshot Serengeti!

      This short tutorial will walk you through your first classification.

      Let's get started!
    '''

  new Step
    content: inline '''
      All over the Serengeti, scientists have set up motion sensitive camera traps.
      The camera snaps a few shots anytime something moves in front of it.
      Many of these photos come as a sequence of two or three.
      Check out other snapshots in the sequence using the buttons below the image.
    '''
    attachment: x: 'left', to: '.subject-viewer', at: x: 'right'
    focus: '.subject-viewer'
    block: 'button[name="finish"]'
    className: 'arrow left'

  new Step
    content: inline '''
      Your task is to identify all the different animals that appear in the photos.
      The species that will appear are listed to the right.
      That's a big list, and not all the species are familiar,
      so let's take a look at some ways we can narrow that list down using
      characteristics we can identify in the image.
    '''
    attachment: x: 'right', to: '.animal-selector', at: x: 'left'
    focus: '.animal-selector'
    block: '.animal-selector'
    className: 'arrow right'

  new Step
    content: inline '''
      The creature on the left is shaped a lot like a horse.
      Let's choose "Cow/horse" from the "looks like" menu.
    '''
    nextOn: click: 'button[value="likeCowHorse"]'
    attachment: x: 'right', to: 'button[name="characteristic"][value="like"]', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline '''
      That narrows things down quite a bit.

      It's got stripes running vertically over most of its body,
      so let's choose the vertical stripes icon under the "Pattern" menu.
    '''
    nextOn: click: 'button[value="patternVerticalStripe"]'
    attachment: x: 'right', to: 'button[name="characteristic"][value="pattern"]', at: x: 'left'
    className: 'arrow right'

  new Step
    content: inline '''
      Great, that leaves us with two options, because there are two cow/horse-shaped things with stripes.
      This one looks like a zebra. Let's click "Zebra" to describe it and add it to the classification.
    '''
    nextOn: click: '[data-animal="zebra"]'
    attachment: y: 'top', to: '[data-animal="zebra"]', at: y: 'bottom'
    className: 'arrow up'

  new Step
    content: inline '''
      We can confirm that this is indeed a zebra by comparing it to to the photos here
      and reading the description below.
    '''
    attachment: x: 'right', to: '.animal-details .image-changer', at: x: 'left'
    className: 'arrow right'

  new Step
    content: '''
      Chooose "1" from the count menu and "Moving" from the behavior menu.
      Then click "Identify" to move on to the next animal.
    '''
    attachment: x: 'right', to: '.animal-details .options', at: x: 'left'
    className: 'arrow right'
    nextOn: click: 'button[name="identify"]'

  new Step
    content: inline '''
      Nice job! Now you\'re ready to classify some images on your own.
      In each image, make your best effort to identify all the animals you can.
      Your observations will be combined with those of multiple volunteers,
      so even if you're not sure on something, your contribution is still very useful!
      Click "Finish" now to move on.
      Don't forget: you can discuss an image with professional and citizen scientists after classifying it.
    '''
    attachment: y: 'bottom', to: 'button[name="finish"]', at: y: 'top'
    className: 'arrow down'
    nextOn: click: 'button[name="finish"]'
]
