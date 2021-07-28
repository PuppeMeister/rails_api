class Api::V1::ContentsController < ApplicationController
  before_action :authenticate_user, except: [:show, :index]

  def index
    #Get all Contents by ID Project
    if Content.exists?
      #Table isn't empty
      resultData = Array.new

      # Iterate over the rows
      @contentQueryResult = Content.where(projectId: params[:id])
      #@contentQueryResult = Content.join(:bar).select(:value_1, :value_2, :value_3)
      #                        .where('bars.table3_id = ?, table3_id_value)

      if @contentQueryResult.present?

        #emailData = Project.where(id: params[:id]).select(:userEmail)
        #userData = User.find_by_email(emailData.userEmail)
        emailData = Project.find_by(id: params[:id])
        userData = User.find_by_email(emailData.userEmail)

        @contentQueryResult.all.each do |myData|
          contentData =
            {
              "id": myData.id,
              "type": "content",
              "attributes": {
                "projectId": myData.projectId,
                "projectOwnerName": userData.firstName+" "+userData.lastName,
                "title": myData.title,
                "body": myData.body,
                "createdAt": myData.created_at,
                "updatedAt": myData.updated_at
              }
            }
          resultData.push(contentData)
        end
        render(json: {"data": resultData}, status: :ok)
      else
        render(json: "No Related Content to the Project is unavailable.", status: :unprocessable_entity)
      end

    else
      #Table is empty
      render(json: "Content Table is empty" , status: :unprocessable_entity)

    end

  end


  def show

    contentData =  Content.where(:projectId=> params[:id], :id=> params[:contentId])

    if contentData.present?
      user = User.find_by(params[:id])
      finalData =
        {
          "id": contentData[0]["id"],
          "type": "content",
          "attributes": {
            "projectId": contentData[0]['projectId'],
            "projectOwnerName": user.firstName+" "+user.lastName,
            "title": contentData[0]['title'],
            "body": contentData[0]['body'],
            "createdAt": contentData[0]['created_at'],
            "updatedAt": contentData[0]['updated_at']
          }
        }
      render(json: {"data": finalData} , status: :ok)
    else
      render(json: "Requested Content Unavailable." , status: :unprocessable_entity)
    end

  end

  def create

    @checkRightOwner = Project.where(userEmail: current_user.email, id: params[:id])
    if @checkRightOwner.present?

      #insert project ID from url to params
      modify_params
      @content = Content.create!(contents_params)
      if @content.save
        finalMessage = {
            "id": @content.id,
            "type": "content",
            "attributes": {
            "projectId": @content.projectId,
            "projectOwnerName": current_user.firstName+" "+current_user.lastName,
            "title": @content.title,
            "body": @content.body,
            "createdAt": @content.created_at,
            "updatedAt": @content.updated_at
            }
        }
        render(json: {"data": finalMessage}, status: :created)
      end
    else
      render(json: {"data": "Restricted Project"}, status: :unauthorized)
    end
  end

  def update

    updatedContent = Content.where(id: params[:id])
    proID = updatedContent[0]['projectId']
    projectRef = Project.find_by(proID.to_s)

    if projectRef['userEmail'].eql?(current_user.email)

      modify_params_for_update
      updatedData = updatedContent.update(contents_params)
      if updatedData.present?
        finalMessage =
          {
            "data": {
              "id": updatedData[0]['id'],
              "type": "content",
              "attributes": {
                "projectId": updatedData[0]['projectId'],
                "projectOwnerName": current_user.firstName+" "+current_user.lastName,
                "title": updatedData[0]['title'],
                "body": updatedData[0]['body'],
                "createdAt": updatedData[0]['created_at'],
                "updatedAt": updatedData[0]['updated_at']
              }
            }
          }
        render(json: finalMessage, status: :ok)
      else
        render(json: "Failed to Update.", status: :unprocessable_entity)
      end

    else
      render(json: "Restricted Content.", status: :unauthorized)
    end

  end

  def destroy

    deletedContent = Content.where(id: params[:id])

    if deletedContent.present?
      proID = deletedContent[0]['projectId']
      projectRef = Project.find_by(proID.to_s)

      if projectRef['userEmail'].eql?(current_user.email)

        if deletedContent.delete_all
          render(json: {"message": "Deleted"}, status: :ok)
        else
          render(json: "Failed to Delete.", status: :internal_server_error)
        end

      else
        render(json: "Restricted Content.", status: :unauthorized)
      end

    else
      render(json: "No Content Found.", status: :unprocessable_entity)
    end

  end

  private
  def contents_params
    params.permit(:title, :body, :projectId)
  end

  def modify_params
    params.merge!({:projectId => params[:id]})
    params['content'].merge!({:projectId => params[:id]})
  end

  def modify_params_for_update
    params.merge!({:id => params[:id]})
    params['content'].merge!({:id => params[:id]})
  end

  def check_owner_right

    contentData = Content.where(id: params[:id])
    proID = contentData[0]['projectId']
    projectRef = Project.find_by(proID.to_s)

    if projectRef['userEmail'].eql?(current_user.email)
      return contentData
    end

  end

end
