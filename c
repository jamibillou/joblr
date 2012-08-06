diff --git a/app/assets/javascripts/users.js.coffee b/app/assets/javascripts/users.js.coffee
index d013d27..892a56e 100644
--- a/app/assets/javascripts/users.js.coffee
+++ b/app/assets/javascripts/users.js.coffee
@@ -1,6 +1,3 @@
-jQuery ->
-	#$('#send_email').click( -> send_email())
-
 @select_pic = (uid, url) ->
 	$('.social.pic').removeClass('selected')
 	$('#'+uid).addClass('selected')
diff --git a/app/controllers/sharings_controller.rb b/app/controllers/sharings_controller.rb
index 574664a..f749b50 100644
--- a/app/controllers/sharings_controller.rb
+++ b/app/controllers/sharings_controller.rb
@@ -1,7 +1,17 @@
 class SharingsController < ApplicationController
 
 	def new
-		@user = User.find(params[:id])
+		@user = current_user
 		@sharing = Sharing.new
 	end
+
+	def create
+		@sharing = Sharing.new params[:sharing]
+		unless @sharing.save
+			redirect_to new_sharing_path, flash: { error: error_messages(@sharing)}
+		else
+			UserMailer.share_profile(@sharing).deliver
+    	redirect_to @sharing.user, flash: { success: t('flash.success.profile_shared') }
+		end	
+	end
 end
diff --git a/app/controllers/users_controller.rb b/app/controllers/users_controller.rb
index 2c20f08..1ebcf76 100644
--- a/app/controllers/users_controller.rb
+++ b/app/controllers/users_controller.rb
@@ -24,15 +24,6 @@ class UsersController < ApplicationController
     end
   end
 
-  def share
-    @user = User.find params[:id]
-  end  
-
-  def share_by_email
-    UserMailer.share_profile(params[:email],params[:user_id]).deliver
-    redirect_to @user, flash: { success: t('flash.success.profile_shared') }
-  end
-
   private
 
     def find_user
diff --git a/app/mailers/user_mailer.rb b/app/mailers/user_mailer.rb
index 3a1c4db..90fd6b9 100644
--- a/app/mailers/user_mailer.rb
+++ b/app/mailers/user_mailer.rb
@@ -1,8 +1,9 @@
 class UserMailer < ActionMailer::Base
-  default from: "franck@engaccino.com"
+  default from: "postman@joblr.co"
 
-  def share_profile(email,user_id)
-    @user = User.find(user_id)
-    mail to: email, subject: t('user_mailer.share_profile.subject', fullname: @user.fullname, role: @user.role)
+  def share_profile(sharing)
+    @user = User.find(sharing.user_id)
+    @sharing = sharing
+    mail to: sharing.email, subject: t('user_mailer.share_profile.subject', fullname: @user.fullname, role: @user.role)
   end
 end
diff --git a/app/views/sharings/new.haml b/app/views/sharings/new.haml
index b7be950..1d0a728 100644
--- a/app/views/sharings/new.haml
+++ b/app/views/sharings/new.haml
@@ -68,13 +68,17 @@
               .icon-globe.icon-white
               Site
 
-  .span5.offset2
-    .row
-      %h1{style:'margin-top:45%; text-align:right'}
-        %i= @user.profile.text
-
-      .pull-right#email_form{style:'margin-top:130px;'}
-        Email address:
-        %input#user_id{type:'hidden', value:"#{@user.id}"}
-        %input#email{placeholder: 'sent@to.me'}
-        %input#send_email{type: 'button', value: 'Send'}
\ No newline at end of file
+  .span5.offset2.pull_right
+    = form_for @sharing do |f|
+      = f.text_area :text, class: 'lead', rows: 3, style: "width:400px;", value: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon."
+      %br/
+      = f.hidden_field :user_id, value: "#{@user.id}"
+      = f.email_field :email, class: 'input-large', placeholder: 'sent@to.me'
+      %br/
+      = f.text_field :fullname, placeholder: 'Contact fullname'
+      %br/
+      = f.text_field :role, placeholder: 'Role'
+      %br/
+      = f.text_field :company, placeholder: 'Company'
+      %br/
+      = f.submit 'Send'
\ No newline at end of file
diff --git a/app/views/user_mailer/share_profile.html.haml b/app/views/user_mailer/share_profile.html.haml
index fb2b12e..5517450 100644
--- a/app/views/user_mailer/share_profile.html.haml
+++ b/app/views/user_mailer/share_profile.html.haml
@@ -1,6 +1,7 @@
 %head
   %link{ rel:'stylesheet', type:'text/css', href:'/assets/application.css'}
 %body 
+  %h1=@sharing.text
   .row
     .span5
       .card{ id:"user-#{@user.id}" }
diff --git a/app/views/users/show.haml b/app/views/users/show.haml
index 3c5033f..66b2401 100644
--- a/app/views/users/show.haml
+++ b/app/views/users/show.haml
@@ -89,7 +89,7 @@
             %span.caret
           %ul.dropdown-menu
             %li
-              = link_to 'Email', user_share_path(@user)
+              = link_to 'Email', new_sharing_path
             %li
               = link_to 'Social networks', '#'
 
diff --git a/config/application.rb b/config/application.rb
index 85c5b43..709927d 100644
--- a/config/application.rb
+++ b/config/application.rb
@@ -65,6 +65,6 @@ module Joblr
 
     # Postmark emailing configuration
     config.action_mailer.delivery_method   = :postmark
-    config.action_mailer.postmark_settings = { :api_key => "7903f949-2b9a-4d1a-81d7-3c2c36daacd4" }
+    config.action_mailer.postmark_settings = { :api_key => "0d3b84d0-f242-4ab2-b986-13a536d889a2" }
   end
 end
diff --git a/config/locales/application.en.yml b/config/locales/application.en.yml
index bce1818..0e2fdc9 100644
--- a/config/locales/application.en.yml
+++ b/config/locales/application.en.yml
@@ -2,6 +2,7 @@ en:
   flash:
     success:
       profile_updated: 'Your profile was updated successfully.'
+      profile_shared:  'Your profile was shared successfully.'
     notice:
       provider_removed: "Your %{provider} account was removed successfully."
       provider_added:  "Your %{provider} account was added successfully."
diff --git a/config/routes.rb b/config/routes.rb
index 4c1af0a..7f47594 100644
--- a/config/routes.rb
+++ b/config/routes.rb
@@ -5,13 +5,12 @@ Joblr::Application.routes.draw do
   devise_for :users, controllers: { omniauth_callbacks: 'authentifications', registrations: 'registrations' }
 
   resources :authentifications, only: [:index, :destroy]
+  resources :sharings
   resources :users do
     resources :profiles
-    resources :sharings
   end
 
   get 'users/auth/failure'   => 'authentifications#failure'
-  match 'users/:id/share'    => 'sharings#new', as: :user_share
   post 'users/share_profile' => 'users#share_profile'
 
   match 'home', to: 'pages#home'
