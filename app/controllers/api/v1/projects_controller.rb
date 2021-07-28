class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user, except: [:show, :index]


  def index
    #Get all projects

    if Project.exists?
      #Table isn't empty
      final_message = Array.new
      # Iterate over the rows
      Project.all.each do |project|
        user = User.find_by_email(project.userEmail)
        projectData =
          {
              "id": project.id,
              "type": "project",
              "attributes": {
                "title": project.title,
                "thumbnail": project.thumbnail.url,
                "description": project.description,
                "location": project.location,
                "type": project.projectType,
                "ownerName": user.firstName+" "+user.lastName,
                #"ownerName": current_user.firstName+" "+current_user.lastName,
                "createdAt": project.created_at,
                "updatedAt": project.updated_at
              }
          }
        final_message.push(projectData)
      end

      render(json: {"data": final_message}, status: :ok)
    else
      #Table is empty
      render(json: "Project is empty.", status: :unprocessable_entity)
    end

  end

  def create
    modify_params
    @project = Project.create!(projects_params)
    @project.userEmail = current_user.email

    if @project.save
      #@user = User.find_by_email(current_user.email)

      final_message =
        {
            "id": @project.id,
            "type": "project",
            "attributes": {
              "title": @project.title,
              "thumbnail": @project.thumbnail.url,
              "description": @project.description,
              "location": @project.location,
              "type": @project.projectType,
              #"ownerName": @user.firstName+" "+@user.lastName,
              "ownerName": current_user.firstName+" "+current_user.lastName,
              "createdAt": @project.created_at,
              "updatedAt": @project.updated_at
                }
        }

      render(json: {"data": final_message }, status: :created)
    else
      render(json: @project.errors, status: :bad)
    end
  end

  def show
    #Get Project by Id
    project = Project.find(params[:id])

    if project.present?
      #user = User.find_by_email(project.userEmail)
      finalMessage =
        {
            "id": project.id,
            "type": "project",
            "attributes": {
              "title": project.title,
              "thumbnail": project.thumbnail.url,
              "description": project.description,
              "location": project.location,
              "type": project.projectType,
              #"ownerName": user.firstName+" "+user.lastName,
              "ownerName": current_user.firstName+" "+current_user.lastName,
              "createdAt": project.created_at,
              "updatedAt": project.updated_at
            }
        }

      render(json: {"data": finalMessage }, status: :ok)
    else
      render(json: {"message": project.error }, status: :unprocessable_entity)
    end
  end

  def my_projects

    projectQueryResult = Project.where(userEmail: current_user.email)

    if projectQueryResult.exists?

      final_message = Array.new

      projectQueryResult.all.each do |myData|
        projectData =
          {
            "id": myData.id,
            "type": "projects",
            "attributes": {
              "title": myData.title,
              "thumbnail": myData.thumbnail.url,
              "description": myData.description,
              "location": myData.location,
              "type": myData.projectType,
              "createdAt": myData.created_at,
              "updatedAt": myData.updated_at
            }
          }
        final_message.push(projectData)
      end

      render(json: {"data": final_message}, status: :ok)
    else
      render(json: "My project is empty", status: :unprocessable_entity)
    end

  end

  def update

    modify_params
    updatedProject = Project.where(userEmail: current_user.email, id: params[:id]).update(projects_params)

    if updatedProject.present?

      updatedData = Project.find_by_id(params[:id])

      finalMessage =
        {
          "data": {
            "id": updatedData.id,
            "type": "project",
            "attributes": {
              "title": updatedData.title,
              "thumbnail": updatedData.thumbnail.url,
              "description": updatedData.description,
              "location": updatedData.location,
              "type": updatedData.projectType,
              "ownerName": current_user.firstName+" "+current_user.lastName,
              "createdAt": updatedData.created_at,
              "updatedAt": updatedData.updated_at
            }
          }
        }

        render(json: finalMessage, status: :ok)
    else
        render(json: "Failed to update", status: :unprocessable_entity)
    end
  end

  def destroy
    deletedData = Project.where(userEmail: current_user.email).find_by_id(params[:id])

    #deletedData = Project.where(userEmail: current_user.email, id: params[:id])

    if deletedData.present?

      if deletedData.delete

        #Delete all related content
        Content.where(projectId: params[:id]).delete_all

        render(json: {"message": "Deleted"}, status: :ok)

      else
        render(json: deletedData.errors, status: :internal_server_error)
      end
    else
      render(json:{"message": "The data does not exist."}, status: :unprocessable_entity)
    end
  end

  private
  def projects_params

    #params.require(:project).permit(:title, :description, :projectType, :location, :thumbnail)
    params.permit(:title, :description, :projectType, :location, :thumbnail)
  end

  def modify_params

    #Check if params type is present
    if params['type'].present?

      typeValue = params['type']
      params.delete :type

      #Check if upload thumbnail or not ('project' entity exists when user does not upload thumbnail )
      if params['project'].present?
        params['project'].delete :type
        params['project'].merge!({:projectType => typeValue})
      end

      params.merge!({:projectType => typeValue})

    end

  end

end
