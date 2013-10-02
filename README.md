CoinPost - Start Your own Bitcoin Marketplace
====================

A Ruby-On-Rails-based Bitcoin Item listing and marketplace system
---------------------

![ScreenShot](https://raw.github.com/brighton36/CoinPost/master/public/images/coinpost-home-page.png)
To see an easy example of what this software is about - take a look at www.coinpost.com. 
*Please note* this site is a live and functioning marketplace, so don't post any items or
buy any items unless you intend to commit to your activity.

Features
---------------------
* Real time international to bitcoin currency conversion using the mtgox library
* Item Price fixing to major currencies
* Extensive test to code ratio (~1:1)
* Secure messaging framework for communicating with site users
* Automatic time zone synchronization between browser and server-side using javascript
* Extensive support for image assets on products
* WYSIWYG editing for product descriptions
* Item Categories
* User profiles
* Internationalization support through rails i18n
* Themes and html based on twitter-bootstrap
* Item submissions can be auto-posted by users to /r/bitmarket

Requirements
---------------------

* Developed/Tested on Ruby 1.9.3
* Using Rails 3.2.14
* Developed and tested with both sqlite and postgres persistence backends

Getting Started
---------------------

1. Once you've checked out the repo, in your rails project directory, create a database:
  rake db:migrate

2. And to seed a sample site to work with on your machine, run:
  rake db:seed

3. Once this is complete, go to http://localhost:3000/ and you'll see your marketplace.

4. That's it! Feel free to customize the site templates to match your branding, and to publish the site onto a production server

A Note on Security
---------------------
* Extensive spec and behavioral tests on nearly all app functions and code paths
* nput html is whitelist sanitized through the nokogiri-based sanitize gem
* All ActiveRecord objects use attribute whitelisting
* Extensive ACL definitions through declarative_authorization, with corresponding bdd tests


