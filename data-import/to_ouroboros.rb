require 'bson'
require 'json'
require_relative 'lib/mysql_connection'
require_relative 'lib/q'

ProjectName = 'serengeti'
SubjectRoot = '/subjects/standard'

ProjectId  =        BSON::ObjectId('5077375154558fabd7000001')
WorkflowId =        BSON::ObjectId('5077375154558fabd7000002')
TutorialSubjectId = BSON::ObjectId('5077375154558fabd7000003')

ProjectSubject = SerengetiSubject

@project = Project.where(name: ProjectName).first || Project.create({
  _id: ProjectId,
  name: ProjectName
})

@workflow = @project.workflows.first || Workflow.create({
  _id: WorkflowId,
  project_id: @project.id,
  primary: true,
  name: ProjectName,
  description: ProjectName,
  entities: []
})

unless SerengetiSubject.find(TutorialSubjectId)
  ProjectSubject.create({
    _id: TutorialSubjectId,
    project_id: @project.id,
    workflow_ids: [@workflow.id],
    tutorial: 'true',
    location: {},
    coords: [],
    metadata: {}
  })
end

subjects_to_create = Mysql.query 'SELECT * FROM zooniverse_subjects WHERE zooniverse_id IS NULL'
@total = subjects_to_create.count

subjects_to_create.each_with_index do |protosubject, i|
  puts "#{i + 1} / #{@total}"

  id = BSON::ObjectId.new

  location = JSON.parse(protosubject['local_location']).each_with_index.map do |_, locationIndex|
    "#{SubjectRoot}/#{id}_#{locationIndex}.jpg"
  end

  subject = ProjectSubject.create({
    project_id: @project.id,
    workflow_ids: [@workflow.id],
    location: {standard: location},
    coords: JSON.parse(protosubject['coords']),
    metadata: JSON.parse(protosubject['metadata'])
  })

  Mysql.query "
    UPDATE zooniverse_subjects
    SET location = #{q(JSON.dump location)},
    bson_id = #{q id.to_s},
    zooniverse_id = #{q subject.zooniverse_id}
    WHERE id = #{q protosubject['id'].to_s}
  "
end
