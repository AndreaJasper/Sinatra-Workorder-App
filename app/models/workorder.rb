class Workorder < ActiveRecord::Base
    belongs_to :assets
    has_many :procedures
end