rails g migration AddColumnsToUsers provider:string uid:string name:string
rake db:migrate

Then, if you are using "attr_accessible" in your User Model, remember to add :provider, :uid and :name.

    attr_accessible :provider, :uid, :name
    
prepare your redis directory /opt/var/db/redis    
    rake redis:start    
    
    QUEUE=* rake resque:work

For Development
    VVERBOSE=1 QUEUE=* rake environment resque:work