class ModifyLikesForAnonymousVoting < ActiveRecord::Migration[6.0]
    def change
      change_table :likes do |t|
        t.remove :user_id
        t.string :anonymous_id, null: false
      end
  
      remove_index :likes, name: :index_likes_on_user_id_and_post_id
      add_index :likes, [:anonymous_id, :post_id], unique: true
    end
  end
  