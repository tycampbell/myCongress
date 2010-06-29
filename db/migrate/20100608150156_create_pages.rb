class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title, :limit =>255, :null => false
      t.string :permalink, :limit => 255, :null => false
      t.text :body, :limit => 10000
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
    add_index :pages, :permalink
    
    Page.create(:title => "About myCongress", 
                :permalink => "about",
                :body => "myCongress about Page")
    Page.create(:title => "Privacy Policy", 
                :permalink => "privacy",
                :body => "You will have no privacy in alpha except password encryption.")
    Page.create(:title => "News", 
                :permalink => "news",
                :body => "Currently in alpha")
  end

  def self.down
    drop_table :pages
  end
end
