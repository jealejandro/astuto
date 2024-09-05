class Like < ApplicationRecord
  include TenantOwnable
  
  belongs_to :post

  validates :anonymous_id, presence: true
  validates :anonymous_id, uniqueness: { scope: :post_id }
end