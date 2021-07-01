class Post < ApplicationRecord
    belongs_to :user
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user
    has_many :comments, dependent: :destroy
    mount_uploader :image, ImageUploader
    has_many  :tag_relationships, dependent: :destroy
    has_many  :tags, through: :tag_relationships

    def save_tags(savepost_tags)
        savepost_tags.each do |new_name|
            post_tag = Tag.find_or_create_by(name: new_name)
            self.tags << post_tag
    　 end
    end

    def save_tags(savepost_tags)
        current_tags = self.tags.pluck(:name) unless self.tags.nil?
        old_tags = current_tags - savepost_tags
        new_tags = savepost_tags - current_tags
    
        old_tags.each do |old_name|
          self.tags.delete Tag.find_by(name: old_name)
        end
    
        new_tags.each do |new_name|
          post_tag = Tag.find_or_create_by(name: new_name)
          self.tags << post_tag
        end
    end

    def avg_score
        unless self.comments.empty?
          comments.average(:overall).round(1)
        else
          0.0
        end
    end
    
    def avg_score_percentage
       unless self.comments.empty?
         comments.average(:overall).round(1).to_f*100/5
       else
         0.0
       end
    end

    def self.posts_serach(search)
      Post.where(['title LIKE ? OR content LIKE ?', "%#{search}%", "%#{search}%"])
    end
   
    def save_posts(tags)
      current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
      old_tags = current_tags - tags
      new_tags = tags - current_tags
   
      # Destroy
      old_tags.each do |old_name|
        self.tags.delete Tag.find_by(tag_name:old_name)
      end
   
      # Create
      new_tags.each do |new_name|
        post_tag = Tag.find_or_create_by(tag_name:new_name)
        self.tags << post_tag
      end
    end


end

