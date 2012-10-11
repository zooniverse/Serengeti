require 'bson'
require './lib/mysql_connection'

ProjectName =       'serengeti'
ProjectId  =        BSON::ObjectId('5077375154558fabd7000001')
WorkflowId =        BSON::ObjectId('5077375154558fabd7000002')
TutorialSubjectId = BSON::ObjectId('5077375154558fabd7000003')

ProjectSubject = SerengetiSubject

@project = Project.where(name: ProjectName).first || Project.create({
  _id: ProjectId,
  name: ProjectName
})

@workflow = @bats_project.workflows.first || Workflow.create({
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
