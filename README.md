# Sinatra / Heroku / HTML5 Boilerplate / 960 Grid System starter app

A very basic [Sinatra](http://www.sinatrarb.com/) application skeleton for deployment to [Heroku](http://heroku.com) using [HTML5 Boilerplate](http://html5boilerplate.com/) and the [960 Grid System](http://960.gs) in the view.

The skeleton is designed as a starting point for rapid prototyping, with the intention of providing something that you can hack on and deploy to Heroku very quickly. I have included the tools that I use for these purposes. I would not necessarily use this as a starting point for a production-ready application, although there is no reason why you couldn't.

## Installation and usage ##

These instructions have been written for OS X.

### Pre-requisites ###
    
  * [Ruby](http://www.ruby-lang.org/) 1.8.7 or 1.9. Use [RVM](http://rvm.beginrescueend.com/) to manage your Ruby installations. It's good.
  * [Rubygems](http://rubygems.org/)
  * [Git](http://git-scm.com/)
  * The [Bundler](http://rubygems.org/gems/bundler) gem. Install with 'gem install bundler'.

### Download ###

Use the zip / tarball link above, or:

    $ git clone git://github.com/froots/sinatra-heroku-boilerplate.git
    $ mv sinatra-heroku-boilerplate [your-app-name]
    $ cd [your-app-name]
    
### Initialise Git ###

You do not need to initialise git if you used git to download the project. If you used the zip / tarball method, then you will need to initialise git for your project. In your project directory:

    $ git init
    $ git add .
    $ git commit -m "Initial commit"
    
### Install dependencies ###

Use Bundler to install project dependencies for you:

    $ bundle install

This will install gems for Sinatra, HAML/SASS, DataMapper, and various other dependencies if not already on your system. It will also create a Gemfile.lock file which will ensure that dependencies do not change on Heroku unless you explicitly rerun `bundle install` again.

### Run locally ###

Bundler will have installed the latest version of [Shotgun](/rtomayko/shotgun), an application-reloading version of rackup designed for local development.

To run the application:

    $ shotgun
    
The app will be viewable at `http://localhost:9393`

### Heroku setup ###

Install the Heroku gem

    $ gem install heroku

[Sign up](https://api.heroku.com/signup) for Heroku if you don't have an account.

Setup your SSH keys to allow access to Heroku if you have not already done so. Details of how to do this can be found on the [Heroku website](http://docs.heroku.com/quickstart#getting-your-app-on-heroku).

Create the application:

    $ heroku create [app-name]
    
    Creating [app-name].... done
    Created http://[app-name].heroku.com/ | git@heroku.com:[app-name].git
    Git remote heroku added
    
### Deploy ###

To deploy the app, commit all changes and:

    $ git push heroku master

Heroku will install gem dependencies specified in Gemfile and start the app.

### Development ###

Views are created in HAML and must be created in the `/views` directory. CSS is written in SASS and must be created in the `/views/css` directory. These will be accessible at `/css/[sheet].css`. JavaScripts, images and other static files are kept in the `/public` directory.