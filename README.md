afterlogic/docker-aurora-files
==============================

Out-of-the-box [Afterlogic Aurora Files](https://afterlogic.org/aurora-files) image

Includes Apache, MySQL and PHP setup based on [fauria/docker-lamp package](https://github.com/fauria/docker-lamp)


Creating the image
------------------

	docker build -t afterlogic/docker-aurora-files .


Running docker image
--------------------

Start your image binding the external port 80:

	docker run -d -p 80:80 afterlogic/docker-aurora-files

and access the container via web browser at http://localhost/


Alternately, you can use any other port available, e.g. 800:

	docker run -d -p 800:80 afterlogic/docker-aurora-files

and access the installation at http://localhost:800/


Accessing admin interface
------------------------------

To configure Aurora Files installation, log into admin interface using main installation URL and `/adminpanel` path.

Default credentials are **superadmin** login and empty password.

Overriding configuration
------------------------------

To override WebMail Lite configuration, put config files with overrides into `data/settings/` or 
`data/settings/modules/`. The file names must be the same as the ones you want to override.

Licensing Terms & Conditions
----------------------------

Content of this repository is available in terms of [AGPLv3 license](http://www.gnu.org/licenses/agpl-3.0.en.html) (see `LICENSE` file)
