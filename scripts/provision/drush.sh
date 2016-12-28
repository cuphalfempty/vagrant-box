#!/bin/bash

# Borrowed from Drush docs
# @see https://github.com/drush-ops/drush

php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush \
	&& php drush core-status \
        && chmod +x drush \
	&& sudo mv drush /usr/local/bin

# Skip because is interactive
#drush init
