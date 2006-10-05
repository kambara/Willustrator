class Tag < ActiveRecord::Base
  belongs_to :image

  validates_length_of :name, :within=>1..40
  # <>&/\'",.;
  validates_format_of(:name,
                      :with => /^[^<>&\/\\'",\.;]+$/) # "'
  
  def Tag.find_all_by_image_id(image_id)
    find(:all,
         :conditions => ["image_id=?", image_id])
  end
end
