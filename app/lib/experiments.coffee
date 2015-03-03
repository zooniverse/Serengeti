$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
###
This will contact the experiment server (synchronously) to find the cohort for this user & subject
###
getExperiment = (experiment, user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  $.ajax({
    url: 'http://experiments.zooniverse.org/experiment/' + experiment + '?userid=' + user_id,
    dataType: 'json'
  }).promise()

exports.getExperiment = getExperiment
