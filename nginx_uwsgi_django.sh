#!/bin/sh

# install nginx & git & some others
sudo apt-get update
sudo apt-get install -y nginx
sudo apt-get install -y git
sudo apt-get install -y build-essential
sudo apt-get install -y zliblg-dev
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y libreadline6-dev
sudo apt-get install -y libgdbm-dev
sudo apt-get install -y libbz2-dev
sudo apt-get install -y tk-dev
sudo apt-get install -y vim
sudo apt-get install -y uwsgi-plugin-python
sudo apt-get install -y mysql-server
sudo apt-get install -y python-mysqldb

# install some packages which may needed before pip 
sudo apt-get install -y python-dev
sudo apt-get install -y libevent-dev

# install pip & django & uwsgi
sudo apt-get install -y python-pip
echo -n "Please input your Django version:"
read d_version
sudo pip Django==$d_version
sudo pip install uwsgi
# uwsgi may need south to work...
sudo pip install South

# install pip package
echo -n "Please input your pip package, separated by black space:"
read pip_package
sudo pip install $pip_package


# check git or not
echo -n "Did you use Git or not?(yes/no)"
read git_or_not
if [ $git_or_not = "yes" ]
then
	echo -n "Please input the directory where you'd like to put your project:"
	read project_parent_directory
	# check if directory exists
	if [ -d $project_parent_directory ]; then
        cd $project_parent_directory
	else
	    # mkdir
		mkdir -p $project_parent_directory
		cd $project_parent_directory
    fi
	
	echo -n "Please input your Repository url:"
	read url
	git clone $url
	# todo auto detect project name
	echo -n "Please input your project name:"
	read p_name
	if [ -d $p_name ]; then
        cd $p_name
	else
	    # mkdir
		mkdir -p $p_name
		cd $p_name
    fi
else
	echo -n "Please input your project directory:"
	read project_directory
	if [ -d $project_directory ]; then
        cd $project_directory
	else
	    # mkdir
		mkdir -p $project_directory
		cd $project_directory
    fi
fi

current_path=`pwd`
sep="/"
echo -n "Please input your nginx conf file name:"
read conf_name
# rm old ones
ln -s ${current_path}${sep}${p_name}${sep}${conf_name} /etc/nginx/sites-enabled/

echo -n "Please input your uwsgi(*.ini) file name:"
read uwsgi_name
mkdir /var/log/uwsgi/
touch /var/log/uwsgi/$p_name.log

echo "Try to start uwsgi..."
uwsgi --ini ${current_path}${sep}/$uwsgi_name
if [ $? = 0 ]
then
	echo "uwsgi start successfully"
else
	echo "uwsgi did not start, error code is $?"
	echo "error msg stored in /var/log/uwsgi/$p_name.log"
	exit $?
fi

echo "Try to restart nginx..."
service nginx restart
if [ $? = 0 ]
then
	echo "nginx start successfully"
else
	echo "nginx did not start, error code is $?"
	echo "error msg stored in nginx log file(maybe /var/log/nginx/error.log)"
	exit $?
