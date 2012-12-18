rails g migration AddColumnsToUsers provider:string uid:string name:string
rake db:migrate

Then, if you are using "attr_accessible" in your User Model, remember to add :provider, :uid and :name.

    attr_accessible :provider, :uid, :name
    
    
QUEUE=* rake resque:work