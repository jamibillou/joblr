class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :headline
      t.string :experience
      t.string :last_job
      t.string :past_companies
      t.string :education
      t.string :skill_1
      t.string :skill_1_level
      t.string :skill_2
      t.string :skill_2_level
      t.string :skill_3
      t.string :skill_3_level
      t.string :quality_1
      t.string :quality_2
      t.string :quality_3
      t.string :file
      t.string :url
      t.string :text
      t.string :linkedin_url
      t.string :twitter_url
      t.string :facebook_url
      t.string :google_url

      t.timestamps
    end
  end
end
