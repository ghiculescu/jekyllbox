# Jekyllbox - instantly updating [Jekyll](http://jekyllrb.com/) sites (using [Dropbox](https://www.dropbox.com))

Jekyllbox watches for changes to your Jekyll source, and automatically builds and publishes your Jekyll site. Set Jekyllbox to watch a shared Dropbox folder, and your entire team can instantly push changes to static sites.

### Dropbox Setup

Install Dropbox via the command line, and install the dropbox.py tools: https://www.dropbox.com/install?os=lnx

You may want to create a new Dropbox account for this, so you can restrict which content ends up on your server. Once you've created that account, create a directory for the static site you're setting up inside your Dropbox. Share this Dropbox folder with anyone who'll be able to edit the site using the Dropbox web UI.

Ensure Dropbox is running on your server:

	./dropbox.py start

### Jekyllbox Setup

Grab the code and put it in `/jekyllbox` on your server. Set the absolute paths to your input and output directories in the `config.yml` file. The input directory is where your Jekyll source (posts, images, css, etc.) will be - this should be your Dropbox shared folder, the output directory is where the site will be built to (this would otherwise default to `_site`).

Ensure that you have all the dependencies to build your site installed. Running `bundle install` in the `jekyllbox` directory will install you have `jekyll` installed, which is a bare minimum.

### Usage

To do a test run:

	ruby jekyllbox_control.rb run

Once you're happy with the results, you can run jekyllbox as a daemon:

	ruby jekyllbox_control.rb start

Jekyllbox will watch for changes to the input directory (your Dropbox shared folder) and will run a `jekyll build` whenever it sees changes. The build will be sent to the output directory. You can then use something like [nginx](http://nginx.org/) to publish this site to the world.