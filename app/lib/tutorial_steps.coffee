translate = require 'lib/translate'
{Tutorial} = require 'zootorial'
{Step} = Tutorial

inline = (string) ->
  string = string.replace '\n\n', '_NEWLINE_'
  string = string.replace '\n', ' '
  string = string.replace '_NEWLINE_', '\n'
  string

# TODO: Drop all these strings into en_us.coffee.

module.exports = [
  new Step
    content: inline '''
      Welcome to Snapshot Serengeti!

      This short tutorial will walk you through your first classification.

      Let's get started!
    '''
    buttons: ['Continue']
    className: 'up arrow'

  new Step
    content: inline '''
      All over the Serengeti, scientists have set up camera traps --
      cameras that take photos whenever something walks in front of them.
      Many of these photos come as a sequence of two or three.
      Check out other snapshots in the sequence using the buttons below the image.
    '''
    focus: '.image-switcher'
    nextOn: click: '.image-switcher button'

  new Step
    content: inline '''
      Your task is to identify the different animals that appear in the photos.
      The species that will appear are listed to the right.
      That's a big list, and not all the species are familiar,
      so let's take a look at some ways we can narrow that list down using
      charactaristics we can identify in the image.
    '''

  new Step
    content: inline '''
      The creature on the left is shaped a lot like a horse.
      Let's choose "Cow/horse" from the "looks like" menu.
    '''

  new Step
    content: inline '''
      That narrows things down quite a bit.

      It's got stripes running vertically over most of its body,
      so let's choose the vertical stripes icon under the "Pattern" menu.
    '''

  new Step
    content: inline '''
      Great, that leaves us with two options! This looks like a zebra.
      Let's click "Zebra" to describe it and add it to our classification.
    '''

  new Step
    content: inline '''
      We can confirm that this is indeed a zebra by comparing it to to the photos here.

      Chooose "1" from the count menu and "Walking around" from the behavior menu.
      Then click "Identify" to move on to the next animal.
    '''

  new Step
    content: inline '''
      ...same thing, different animal, maybe show off the search feature...
    '''

  new Step
    content: inline '''
      Nice job! Now you\'re ready to classify on your own.
      Click "Next" to move on.
      Don't forget: you can discuss an image with professional and citizen scientists after classifying it.
    '''
]
