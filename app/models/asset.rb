class Asset < ActiveRecord::Base
    has_many :workorders
    has_many :procedures
end