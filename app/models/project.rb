class Project < ApplicationRecord

  mount_uploader :thumbnail, ThumbnailUploader
  enum projectType: [:in_house, :external, :international ]

  validates :title, :location, :projectType, :thumbnail, presence:true

end
