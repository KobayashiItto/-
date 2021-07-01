class Tag < ApplicationRecord
    has_many   :tag_relationships, dependent: :destroy
    has_many   :posts, through: :tag_relationships
    validates :name, uniqueness: true
end
