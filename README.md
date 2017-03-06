VCCW-Existing
============

A specialized version of [VCCW][vccw] built to wed existing Wordpress installations with Git.

More information incoming.


### Easy Dependency Setup Script (MAC)
```bash
# Install Virtualbox and Vagrant
brew cask install virtualbox
brew cask install vagrant

# Install Git LFS
brew install git-lfs

# Install autocompletion
brew install vagrant-completion

# Install vagrant manager for gui access
brew cask install vagrant-manager

# Hosts updater plugin
vagrant plugin install vagrant-hostsupdater

# Install box
vagrant box add vccw-team/xenial64

# Install direnv for easy enviroment setup
# BE SURE TO ADD THE LINE PROVIDED TO YOUR .bashrc or .profile
brew install direnv
```

[vccw]: http://vccw.cc
