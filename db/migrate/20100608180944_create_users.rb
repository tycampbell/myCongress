class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string, :limit => 64, :null => false
      t.column :email, :string, :limit => 128, :null => false
      t.column :hashed_password, :string, :limit => 64
      t.column :enabled, :boolean, :default => true, :null => false
      
      t.string :roles, :default => "--- []"
      
      t.column :created_at, :datetime
      t.colimn :updated_at, :datetime
      t.column :last_login_at, :datetime
    end
    add_index :users, :username
    
    user = User.new(:username => 'admin', :email => 'admin', 
          :password => 'nbuser', :password_confirmation => 'nbuser',
          :enabled => true)
    user.add_role('Administrator')
    user.save
      
  end

  def self.down
    drop_table :users
  end
end
