#!/bin/sh

# install nginx & git & some others
apt-get install -y nginx
apt-get install -y git
apt-get install -y build-essential
apt-get install -y zliblg-dev
apt-get install -y libsqlite3-dev
apt-get install -y libreadline6-dev
apt-get install -y libgdbm-dev
apt-get install -y libbz2-dev
apt-get install -y tk-dev
apt-get install -y vim

# install some packages which may needed before pip 
apt-get install -y python-dev
apt-get install -y libevent-dev

# install pip & django & uwsgi
apt-get install -y python-pip
echo -n "Please input your Django version:"
read d_version
pip install Django==$d_version
pip install uwsgi
# uwsgi may need south to work...
pip install South

# install pip package
echo -n "Please input your pip package, separated by black space:"
read pip_package
pip install $pip_package


# check git or not
echo -n "Did you use Git or not?(yes/no)"
read git_or_not
if [ $git_or_not = "yes" ]
then
	echo -n "Please input the directory where you'd like to put your project:"
	read project_parent_directory
	cd $project_parent_directory
	echo -n "Please input your Repository url:"
	read url
	git clone $url
	# todo auto detect project name
	echo -n "Please input your project name:"
	read p_name
	cd $p_name
else
	echo -n "Please input your project directory:"
	read project_directory
	cd $project_directory
fi

current_path = `pwd`
sep = "/"
echo -n "Please input your nginx conf file name:"
read conf_name
ln -s ${current_path}${sep}${conf_name} /etc/nginx/sites-enabled/

echo -n "Please input your uwsgi file name:"
read uwsgi_name
mkdir /var/log/uwsgi/
touch /var/log/uwsgi/$p_name.log

echo "Try to start uwsgi..."
uwsgi --ini $current_path/$uwsgi_name
# todo check if start properly

echo "Try to restart nginx..."
service nginx restart
# todo check if start properly