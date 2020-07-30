class Procedure < ActiveRecord::Base
    belongs_to :assets
    has_many :workorders

end