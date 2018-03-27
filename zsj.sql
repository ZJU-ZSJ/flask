-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: zsj
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('ea85bc491295');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) DEFAULT NULL,
  `body` text,
  `body_html` text,
  `create_time` datetime DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  KEY `category_id` (`category_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categorys` (`id`),
  CONSTRAINT `articles_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (9,'mysql_config not found 解决','缺少运行的前置库\r\n\r\n终端中执行即可\r\n\r\n`\r\napt-get install libmysqld-dev\r\n`\r\n','<p>缺少运行的前置库</p>\n<p>终端中执行即可</p>\n<p><code>apt-get install libmysqld-dev</code></p>','2017-08-14 12:24:50',3,1),(10,'flask nginx, uwsgi, supervisor部署','##Nginx\r\n\r\n安装并运行Nginx：\r\n\r\n<pre><code>\r\nsudo apt-get install nginx\r\nsudo /etc/init.d/nginx start\r\n</code></pre>\r\nNginx是一个提供静态文件访问的web服务，然而，它不能直接执行托管Python应用程序，而uWSGI解决了这个问题。让我们先安装uWSGI，稍候再配置Nginx和uWSGI之间的交互。\r\n\r\n<pre><code>\r\nsudo pip install uwsgi\r\n</code></pre>\r\n\r\n###里程碑 1\r\n打开浏览器访问你的服务器，你应该能看到Nginx欢迎页：\r\n##示例应用\r\n我们将托管的应用是经典的“Hello, world!”。这个应用只有一个页面，已经猜到页面上将有什么内容了吧。将所有应用相关的文件存放在/var/www/demoapp文件夹中。下面创建这个文件夹并在其中初始化一个虚拟环境：\r\n\r\n<pre><code>\r\nsudo mkdir /var/www\r\nsudo mkdir /var/www/demoapp\r\n</code></pre>\r\n由于我们使用root权限创建了这个文件夹，它目前归root用户所有，让我们更改它的所有权给你登录的用户（我的例子中是ubuntu）\r\n\r\n<pre><code>\r\nsudo chown -R ubuntu:ubuntu /var/www/demoapp/\r\n</code></pre>\r\n\r\n创建并激活一个虚拟环境，在其中安装Flask：\r\n\r\n<pre><code>\r\ncd /var/www/demoapp\r\nvirtualenv venv\r\n. venv/bin/activate\r\npip install flask\r\n</code></pre>\r\n\r\n使用下面的代码创建hello.py文件：\r\n\r\n<pre><code>\r\nfrom flask import Flask\r\napp = Flask(__name__)\r\n\r\n@app.route(\"/\")\r\ndef hello():\r\n    return \"Hello World!\"\r\n\r\nif __name__ == \"__main__\":\r\n    app.run(host=\'0.0.0.0\', port=8080)\r\n</code></pre>\r\n\r\n###里程碑 2\r\n让我们执行我们刚创建的脚本：\r\n\r\n<pre><code>\r\npython hello.py\r\n</code></pre>\r\n\r\n现在你可以通过浏览器访问你服务器的8080端口\r\n\r\n##配置Nginx\r\n首先删除掉Nginx的默认配置文件：\r\n\r\n<pre><code>\r\nsudo rm /etc/nginx/sites-enabled/default\r\n</code></pre>\r\n\r\n注意：如果你安装了其他版本的Nginx，默认配置文件可能在/etc/nginx/conf.d文件夹下。\r\n\r\n创建一个我们应用使用的新配置文件/var/www/demoapp/demoapp_nginx.conf：\r\n\r\n<pre><code>\r\nserver {\r\n    listen      80;\r\n    server_name localhost;\r\n    charset     utf-8;\r\n    client_max_body_size 75M;\r\n\r\n    location / { try_files $uri @yourapplication; }\r\n    location @yourapplication {\r\n        include uwsgi_params;\r\n        uwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;\r\n    }\r\n}\r\n</code></pre>\r\n\r\n将刚建立的配置文件使用符号链接到Nginx配置文件文件夹中，重启Nginx：\r\n\r\n<pre><code>\r\nsudo ln -s /var/www/demoapp/demoapp_nginx.conf /etc/nginx/conf.d/\r\nsudo /etc/init.d/nginx restart\r\n</code></pre>\r\n\r\n###里程碑 3\r\n访问服务器的公共ip地址，你会看到一个错误：\r\n\r\n别担心，这个错误是正常的，它代表Nginx已经使用了我们新创建的配置文件，但在链接到我们的Python应用网关uWSGI时遇到了问题。到uWSGI的链接在Nginx配置文件的第10行定义：\r\n\r\n<pre><code>\r\nuwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;\r\n</code></pre>\r\n\r\n这代表Nginx和uWSGI之间的链接是通过一个socket文件，这个文件位于/var/www/demoapp/demoapp_uwsgi.sock。因为我们还没有配置uWSGI，所以这个文件还不存在，因此Nginx返回“bad gateway”错误，让我们马上修正它吧。\r\n##配置uWSGI\r\n创建一个新的uWSGI配置文件/var/www/demoapp/demoapp_uwsgi.ini：\r\n\r\n<pre><code>\r\n[uwsgi]\r\n#application\'s base folder\r\nbase = /var/www/demoapp\r\n\r\n#python module to import\r\napp = hello\r\nmodule = %(app)\r\n\r\nhome = %(base)/venv\r\npythonpath = %(base)\r\n\r\n#socket file\'s location\r\nsocket = /var/www/demoapp/%n.sock\r\n\r\n#permissions for the socket file\r\nchmod-socket    = 666\r\n\r\n#the variable that holds a flask application inside the module imported at line #6\r\ncallable = app\r\n\r\n#location of log files\r\nlogto = /var/log/uwsgi/%n.log\r\n</code></pre>\r\n\r\n创建一个新文件夹存放uWSGI日志，更改文件夹的所有权：\r\n\r\n<pre><code>\r\nsudo mkdir -p /var/log/uwsgi\r\nsudo chown -R ubuntu:ubuntu /var/log/uwsgi\r\n</code></pre>\r\n\r\n###里程碑 4\r\n执行uWSGI，用新创建的配置文件作为参数：\r\n\r\n<pre><code>\r\nuwsgi --ini /var/www/demoapp/demoapp_uwsgi.ini\r\n</code></pre>\r\n\r\n接下来访问你的服务器，现在Nginx可以连接到uWSGI进程了：\r\n\r\n我们现在基本完成了，唯一剩下的事情是配置uWSGI在后台运行\r\n\r\n##SUPERVISOR\r\n安装supervisor\r\n`\r\npip install supervisor\r\n`\r\n\r\n再项目SMT目录下初始化配置文件\r\n<pre><code>\r\necho_supervisord_conf > supervisor.conf\r\n\r\nvim supervisor.conf\r\n</code></pre>\r\n在配置文件最底部加入\r\n<pre><code>\r\n[program:smt]\r\ncommand=/data/python/SMT/venv/bin/gunicorn -w 4 -b 0.0.0.0:7000 app:app    ; supervisor启动命令\r\ndirectory=/data/python/SMT                                                 ; 项目的文件夹路径\r\nstartsecs=0                                                                             ; 启动时间\r\nstopwaitsecs=0                                                                          ; 终止等待时间\r\nautostart=false                                                                         ; 是否自动启动\r\nautorestart=false                                                                       ; 是否自动重启\r\nstdout_logfile=/data/python/SMT/log/gunicorn.log                           ; log 日志\r\nstderr_logfile=/data/python/SMT/log/gunicorn.err                           ; 错误日志\r\n</code></pre>\r\n保存！\r\n\r\n启动supervisord\r\n\r\n`\r\nsupervisord -c supervisor.conf\r\n`\r\n\r\n查看状态\r\n\r\n`\r\nsupervisorctl -c supervisor.conf status \r\n`','<h2>Nginx</h2>\n<p>安装并运行Nginx：</p>\n<pre><code>\nsudo apt-get install nginx\nsudo /etc/init.d/nginx start\n</code></pre>\n\n<p>Nginx是一个提供静态文件访问的web服务，然而，它不能直接执行托管Python应用程序，而uWSGI解决了这个问题。让我们先安装uWSGI，稍候再配置Nginx和uWSGI之间的交互。</p>\n<pre><code>\nsudo pip install uwsgi\n</code></pre>\n\n<h3>里程碑 1</h3>\n<p>打开浏览器访问你的服务器，你应该能看到Nginx欢迎页：</p>\n<h2>示例应用</h2>\n<p>我们将托管的应用是经典的“Hello, world!”。这个应用只有一个页面，已经猜到页面上将有什么内容了吧。将所有应用相关的文件存放在/var/www/demoapp文件夹中。下面创建这个文件夹并在其中初始化一个虚拟环境：</p>\n<pre><code>\nsudo mkdir /var/www\nsudo mkdir /var/www/demoapp\n</code></pre>\n\n<p>由于我们使用root权限创建了这个文件夹，它目前归root用户所有，让我们更改它的所有权给你登录的用户（我的例子中是ubuntu）</p>\n<pre><code>\nsudo chown -R ubuntu:ubuntu /var/www/demoapp/\n</code></pre>\n\n<p>创建并激活一个虚拟环境，在其中安装Flask：</p>\n<pre><code>\ncd /var/www/demoapp\nvirtualenv venv\n. venv/bin/activate\npip install flask\n</code></pre>\n\n<p>使用下面的代码创建hello.py文件：</p>\n<pre><code>\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef hello():\n    return \"Hello World!\"\n\nif __name__ == \"__main__\":\n    app.run(host=\'0.0.0.0\', port=8080)\n</code></pre>\n\n<h3>里程碑 2</h3>\n<p>让我们执行我们刚创建的脚本：</p>\n<pre><code>\npython <a href=\"http://hello.py\" rel=\"nofollow\">hello.py</a>\n</code></pre>\n\n<p>现在你可以通过浏览器访问你服务器的8080端口</p>\n<h2>配置Nginx</h2>\n<p>首先删除掉Nginx的默认配置文件：</p>\n<pre><code>\nsudo rm /etc/nginx/sites-enabled/default\n</code></pre>\n\n<p>注意：如果你安装了其他版本的Nginx，默认配置文件可能在/etc/nginx/conf.d文件夹下。</p>\n<p>创建一个我们应用使用的新配置文件/var/www/demoapp/demoapp_nginx.conf：</p>\n<pre><code>\nserver {\n    listen      80;\n    server_name localhost;\n    charset     utf-8;\n    client_max_body_size 75M;\n\n    location / { try_files $uri @yourapplication; }\n    location @yourapplication {\n        include uwsgi_params;\n        uwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;\n    }\n}\n</code></pre>\n\n<p>将刚建立的配置文件使用符号链接到Nginx配置文件文件夹中，重启Nginx：</p>\n<pre><code>\nsudo ln -s /var/www/demoapp/demoapp_nginx.conf /etc/nginx/conf.d/\nsudo /etc/init.d/nginx restart\n</code></pre>\n\n<h3>里程碑 3</h3>\n<p>访问服务器的公共ip地址，你会看到一个错误：</p>\n<p>别担心，这个错误是正常的，它代表Nginx已经使用了我们新创建的配置文件，但在链接到我们的Python应用网关uWSGI时遇到了问题。到uWSGI的链接在Nginx配置文件的第10行定义：</p>\n<pre><code>\nuwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;\n</code></pre>\n\n<p>这代表Nginx和uWSGI之间的链接是通过一个socket文件，这个文件位于/var/www/demoapp/demoapp_uwsgi.sock。因为我们还没有配置uWSGI，所以这个文件还不存在，因此Nginx返回“bad gateway”错误，让我们马上修正它吧。</p>\n<h2>配置uWSGI</h2>\n<p>创建一个新的uWSGI配置文件/var/www/demoapp/demoapp_uwsgi.ini：</p>\n<pre><code>\n[uwsgi]\n#application\'s base folder\nbase = /var/www/demoapp\n\n#python module to import\napp = hello\nmodule = %(app)\n\nhome = %(base)/venv\npythonpath = %(base)\n\n#socket file\'s location\nsocket = /var/www/demoapp/%n.sock\n\n#permissions for the socket file\nchmod-socket    = 666\n\n#the variable that holds a flask application inside the module imported at line #6\ncallable = app\n\n#location of log files\nlogto = /var/log/uwsgi/%n.log\n</code></pre>\n\n<p>创建一个新文件夹存放uWSGI日志，更改文件夹的所有权：</p>\n<pre><code>\nsudo mkdir -p /var/log/uwsgi\nsudo chown -R ubuntu:ubuntu /var/log/uwsgi\n</code></pre>\n\n<h3>里程碑 4</h3>\n<p>执行uWSGI，用新创建的配置文件作为参数：</p>\n<pre><code>\nuwsgi --ini /var/www/demoapp/demoapp_uwsgi.ini\n</code></pre>\n\n<p>接下来访问你的服务器，现在Nginx可以连接到uWSGI进程了：</p>\n<p>我们现在基本完成了，唯一剩下的事情是配置uWSGI在后台运行</p>\n<h2>SUPERVISOR</h2>\n<p>安装supervisor\n<code>pip install supervisor</code></p>\n<p>再项目SMT目录下初始化配置文件\n</p><pre><code>\necho_supervisord_conf &gt; supervisor.conf<p></p>\n</code><p><code>vim supervisor.conf\n</code></p></pre>\n在配置文件最底部加入\n<pre><code>\n[program:smt]\ncommand=/data/python/SMT/venv/bin/gunicorn -w 4 -b 0.0.0.0:7000 app:app    ; supervisor启动命令\ndirectory=/data/python/SMT                                                 ; 项目的文件夹路径\nstartsecs=0                                                                             ; 启动时间\nstopwaitsecs=0                                                                          ; 终止等待时间\nautostart=false                                                                         ; 是否自动启动\nautorestart=false                                                                       ; 是否自动重启\nstdout_logfile=/data/python/SMT/log/gunicorn.log                           ; log 日志\nstderr_logfile=/data/python/SMT/log/gunicorn.err                           ; 错误日志\n</code></pre>\n保存！<p></p>\n<p>启动supervisord</p>\n<p><code>supervisord -c supervisor.conf</code></p>\n<p>查看状态</p>\n<p><code>supervisorctl -c supervisor.conf status</code></p>','2017-08-14 12:25:30',2,1),(11,'pip换源','##临时使用\r\n\r\n`\r\npip install pythonModuleName -i https://pypi.douban.com/simple\r\n`\r\n\r\n在命令行中添加以上参数，可以让pip从指定的镜像源安装软件。\r\n\r\n##修改配置文件\r\n\r\n为了修改默认的镜像源，在我的Arch Linux系统中，需要修改/root/.pip/pip.conf。\r\n\r\n<pre><code>\r\n[global]\r\nindex-url = https://pypi.douban.com/simple\r\n</code></pre>\r\n\r\n在pip.conf中，添加以上内容，就修改了默认的软件源。以后pip命令会直接从制定的软件源安装软件。\r\n','<h2>临时使用</h2>\n<p><code>pip install pythonModuleName -i <a href=\"https://pypi.douban.com/simple\" rel=\"nofollow\">https://pypi.douban.com/simple</a></code></p>\n<p>在命令行中添加以上参数，可以让pip从指定的镜像源安装软件。</p>\n<h2>修改配置文件</h2>\n<p>为了修改默认的镜像源，在我的Arch Linux系统中，需要修改/root/.pip/pip.conf。</p>\n<pre><code>\n[global]\nindex-url = <a href=\"https://pypi.douban.com/simple\" rel=\"nofollow\">https://pypi.douban.com/simple</a>\n</code></pre>\n\n<p>在pip.conf中，添加以上内容，就修改了默认的软件源。以后pip命令会直接从制定的软件源安装软件。</p>','2017-08-14 13:26:07',3,1),(28,'ubuntu下允许root用户ssh远程登录','SSH服务器，可以通过SSH协议来访问远程服务器，代替telnet和ftp。但是ubuntu默认是不启用root用户也不允许root远程登录的。所以需要先启用root用户\r\n \r\n启用root用户：`sudo passwd root             //修改密码后就启用了。`\r\n\r\n\r\n`$ sudo vi /etc/ssh/sshd_config`\r\n\r\n找到PermitRootLogin no一行，改为PermitRootLogin yes','<p>SSH服务器，可以通过SSH协议来访问远程服务器，代替telnet和ftp。但是ubuntu默认是不启用root用户也不允许root远程登录的。所以需要先启用root用户</p>\n<p>启用root用户：<code>sudo passwd root             //修改密码后就启用了。</code></p>\n<p><code>$ sudo vi /etc/ssh/sshd_config</code></p>\n<p>找到PermitRootLogin no一行，改为PermitRootLogin yes</p>','2017-08-14 17:42:39',3,1),(29,'How To Set Up a Minecraft Server on Linux','Setting up a Minecraft server on Linux (Ubuntu 12.04) is a fairly easy task on the command line.\r\n\r\nWhen choosing your server, be sure that it has (at a minimum)1GB of RAM, preferably at least 2GB.\r\n\r\nThe first thing you need to do is to connect to your server through SSH. If you are on a mac, you can open up Terminal, or if you are on a PC, you can connect with PuTTY. Once the command line is opened, login by typing:\r\n\r\n`ssh username@ipaddress`\r\n\r\nEnter the password when prompted. Although you can set up the server on the root user, it is not as secure as setting it up under another username. You can check out this tutorial to see how to add users.\r\n\r\n##Step One—Install the Requirements\r\n\r\nBefore going further, we should run a quick update on apt-get, the program through which we will download all of the server requirements.\r\n\r\n`sudo apt-get update`\r\n\r\nAfter that, we need to be sure that Java is installed on our server. You can check by typing this command:\r\n\r\n` java -version`\r\n\r\nIf you don’t have Java installed, you will get a message that says \"java: command not found\". You can, then, download java through apt-get:\r\n\r\n`sudo apt-get install default-jdk`\r\n\r\nYou also need to supply your server with Screen which will keep your server running if you drop the connection:\r\n\r\n`sudo apt-get install screen`\r\n\r\n##Install the Minecraft Server\r\nStart off by creating a new directory where you will store the Minecraft files:\r\n\r\n`mkdir minecraft`\r\n\r\nOnce the directory is created, switch into it:\r\n\r\n`cd minecraft`\r\n\r\nWithin that directory, download the Minecraft server software:\r\n\r\n<pre><code>\r\nwget -O minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar\r\n</code></pre>\r\n\r\nSince we have installed screen, you can start it running (-S sets the sessions title):\r\n\r\n`screen -S \"Minecraft server\"`\r\n\r\nAfter the file downloads, you can run it with Java:\r\n\r\n`java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui`\r\n\r\nThe launching text should look something like this:\r\n\r\n<pre><code>\r\n2012-08-06 21:12:52 [INFO] Loading properties\r\n2012-08-06 21:12:52 [WARNING] server.properties does not exist\r\n2012-08-06 21:12:52 [INFO] Generating new properties file\r\n2012-08-06 21:12:52 [INFO] Default game type: SURVIVAL\r\n2012-08-06 21:12:52 [INFO] Generating keypair\r\n2012-08-06 21:12:53 [INFO] Starting Minecraft server on *:25565\r\n2012-08-06 21:12:53 [WARNING] Failed to load operators list: java.io.FileNotFoundException: ./ops.txt (No such file or directory)\r\n2012-08-06 21:12:53 [WARNING] Failed to load white-list: java.io.FileNotFoundException: ./white-list.txt (No such file or directory)\r\n2012-08-06 21:12:53 [INFO] Preparing level \"world\"\r\n2012-08-06 21:12:53 [INFO] Preparing start region for level 0\r\n2012-08-06 21:12:54 [INFO] Preparing spawn area: 4%\r\n2012-08-06 21:12:55 [INFO] Preparing spawn area: 12%\r\n2012-08-06 21:12:56 [INFO] Preparing spawn area: 20%\r\n2012-08-06 21:12:57 [INFO] Preparing spawn area: 24%\r\n2012-08-06 21:12:58 [INFO] Preparing spawn area: 32%\r\n2012-08-06 21:12:59 [INFO] Preparing spawn area: 36%\r\n2012-08-06 21:13:00 [INFO] Preparing spawn area: 44%\r\n2012-08-06 21:13:01 [INFO] Preparing spawn area: 48%\r\n2012-08-06 21:13:02 [INFO] Preparing spawn area: 52%\r\n2012-08-06 21:13:03 [INFO] Preparing spawn area: 61%\r\n2012-08-06 21:13:04 [INFO] Preparing spawn area: 69%\r\n2012-08-06 21:13:05 [INFO] Preparing spawn area: 77%\r\n2012-08-06 21:13:06 [INFO] Preparing spawn area: 85%\r\n2012-08-06 21:13:07 [INFO] Preparing spawn area: 93%\r\n2012-08-06 21:13:08 [INFO] Done (15.509s)! For help, type \"help\" or \"?\"\r\n</code></pre>\r\n\r\nYour Minecraft server is now all set up. You can exit out of screen by pressing\r\n\r\n`ctl-a d`\r\n\r\nTo reattach screen, type\r\n\r\n`screen -R`\r\n\r\nYou can change the settings of your server by opening up the server properties file:\r\n\r\n` nano ~/minecraft/server.properties`','<p>Setting up a Minecraft server on Linux (Ubuntu 12.04) is a fairly easy task on the command line.</p>\n<p>When choosing your server, be sure that it has (at a minimum)1GB of RAM, preferably at least 2GB.</p>\n<p>The first thing you need to do is to connect to your server through SSH. If you are on a mac, you can open up Terminal, or if you are on a PC, you can connect with PuTTY. Once the command line is opened, login by typing:</p>\n<p><code>ssh username@ipaddress</code></p>\n<p>Enter the password when prompted. Although you can set up the server on the root user, it is not as secure as setting it up under another username. You can check out this tutorial to see how to add users.</p>\n<h2>Step One—Install the Requirements</h2>\n<p>Before going further, we should run a quick update on apt-get, the program through which we will download all of the server requirements.</p>\n<p><code>sudo apt-get update</code></p>\n<p>After that, we need to be sure that Java is installed on our server. You can check by typing this command:</p>\n<p><code>java -version</code></p>\n<p>If you don’t have Java installed, you will get a message that says \"java: command not found\". You can, then, download java through apt-get:</p>\n<p><code>sudo apt-get install default-jdk</code></p>\n<p>You also need to supply your server with Screen which will keep your server running if you drop the connection:</p>\n<p><code>sudo apt-get install screen</code></p>\n<h2>Install the Minecraft Server</h2>\n<p>Start off by creating a new directory where you will store the Minecraft files:</p>\n<p><code>mkdir minecraft</code></p>\n<p>Once the directory is created, switch into it:</p>\n<p><code>cd minecraft</code></p>\n<p>Within that directory, download the Minecraft server software:</p>\n<pre><code>\nwget -O minecraft_server.jar <a href=\"https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar\" rel=\"nofollow\">https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar</a>\n</code></pre>\n\n<p>Since we have installed screen, you can start it running (-S sets the sessions title):</p>\n<p><code>screen -S \"Minecraft server\"</code></p>\n<p>After the file downloads, you can run it with Java:</p>\n<p><code>java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui</code></p>\n<p>The launching text should look something like this:</p>\n<pre><code>\n2012-08-06 21:12:52 [INFO] Loading properties\n2012-08-06 21:12:52 [WARNING] server.properties does not exist\n2012-08-06 21:12:52 [INFO] Generating new properties file\n2012-08-06 21:12:52 [INFO] Default game type: SURVIVAL\n2012-08-06 21:12:52 [INFO] Generating keypair\n2012-08-06 21:12:53 [INFO] Starting Minecraft server on *:25565\n2012-08-06 21:12:53 [WARNING] Failed to load operators list: java.io.FileNotFoundException: ./ops.txt (No such file or directory)\n2012-08-06 21:12:53 [WARNING] Failed to load white-list: java.io.FileNotFoundException: ./white-list.txt (No such file or directory)\n2012-08-06 21:12:53 [INFO] Preparing level \"world\"\n2012-08-06 21:12:53 [INFO] Preparing start region for level 0\n2012-08-06 21:12:54 [INFO] Preparing spawn area: 4%\n2012-08-06 21:12:55 [INFO] Preparing spawn area: 12%\n2012-08-06 21:12:56 [INFO] Preparing spawn area: 20%\n2012-08-06 21:12:57 [INFO] Preparing spawn area: 24%\n2012-08-06 21:12:58 [INFO] Preparing spawn area: 32%\n2012-08-06 21:12:59 [INFO] Preparing spawn area: 36%\n2012-08-06 21:13:00 [INFO] Preparing spawn area: 44%\n2012-08-06 21:13:01 [INFO] Preparing spawn area: 48%\n2012-08-06 21:13:02 [INFO] Preparing spawn area: 52%\n2012-08-06 21:13:03 [INFO] Preparing spawn area: 61%\n2012-08-06 21:13:04 [INFO] Preparing spawn area: 69%\n2012-08-06 21:13:05 [INFO] Preparing spawn area: 77%\n2012-08-06 21:13:06 [INFO] Preparing spawn area: 85%\n2012-08-06 21:13:07 [INFO] Preparing spawn area: 93%\n2012-08-06 21:13:08 [INFO] Done (15.509s)! For help, type \"help\" or \"?\"\n</code></pre>\n\n<p>Your Minecraft server is now all set up. You can exit out of screen by pressing</p>\n<p><code>ctl-a d</code></p>\n<p>To reattach screen, type</p>\n<p><code>screen -R</code></p>\n<p>You can change the settings of your server by opening up the server properties file:</p>\n<p><code>nano ~/minecraft/server.properties</code></p>','2017-08-14 17:48:53',3,1),(31,'flask数据库三个指令','<pre><code>\r\npython manage.py db init\r\npython manage.py db migrate -m \"first init db\"\r\npython manage.py db upgrade\r\n</code></pre>','<pre><code>\npython <a href=\"http://manage.py\" rel=\"nofollow\">manage.py</a> db init\npython <a href=\"http://manage.py\" rel=\"nofollow\">manage.py</a> db migrate -m \"first init db\"\npython <a href=\"http://manage.py\" rel=\"nofollow\">manage.py</a> db upgrade\n</code></pre>','2017-10-02 17:06:20',2,1),(32,'Debian 8 VPS如何安装WordPress','##关于Wordpress\r\nWordPress是一个免费自由开源的博客平台。在全球流量前1000万的网站中，超过18.9%使用WordPress来搭建网站。这使得WordPress成为最流行的博客系统。之前我们介绍过如何在树莓派上安装WordPress，Debian 8的WordPress安装过程与树莓派稍微有点不同。\r\n##安装LEMP\r\n在Debian 8 VPS上安装WordPress之前，我们首先需要安装好LEMP。如果你没有安装好Ngnix, MySQL和PHP，那么请看[这篇教程进行安装](https://www.linuxdashen.com/debian-8-server%E5%A6%82%E4%BD%95%E5%AE%89%E8%A3%85lemp-nginx-mysqlmariadb-php)\r\n\r\n以下的命令不是以root用户执行的，而是以另外一个管理员账号执行的，如果命令前面没有加sudo，就表示这条命令不需要root权限。\r\n##下载并设置WordPress\r\n安装好LEMP后，通过SSH登录Debian 8 。然后输入下面的命令下载WordPress:\r\n\r\n`wget http://wordpress.org/latest.tar.gz`\r\n\r\n下载完后，解压安装包：\r\n\r\n`tar -xzvf latest.tar.gz`\r\n\r\n解压后，在用户的home目录会生成一个wordpress目录。\r\n##为WordPress创建一个数据库和用户\r\n首先输入下面的命令以root用户登录MySQL shell，注意这个root用户是MySQL数据库的root用户，不是Debian系统上的root用户。\r\n\r\n`mysql -u root -p`\r\n\r\n这篇教程将创建一个名为wordpress的数据库，你也可以将数据库命名为其他名字，比如wp。在MySQL shell中输入下面的命令，注意不要漏掉分号。如果你漏掉了分号，那么可以在下一行添加分号，再按Enter键。\r\n\r\n`create database wordpress;`\r\n\r\n然后为新建的数据库创建一个新的用户。这篇教程创建的用户是wpuser。\r\n\r\n`create user wpuser@localhost;`\r\n\r\n为新用户设置一个密码。我设置的密码是dbpassword。\r\n\r\n`set password for wpuser@localhost= password(\"dbpassword\");`\r\n\r\n赋予用户所有的权限，否则wordpress的安装程序不能启动。\r\n\r\n`grant all privileges on wordpress.* to wpuser@localhost identified by \'dbpassword\';\r\n`\r\n\r\n刷新MySQL\r\n\r\n`flush privileges;`\r\n\r\n退出MySQL shell\r\n\r\n`exit\r\n`\r\n\r\n##设置WordPress\r\n我们需要把WordPress的样本配置文件的内容复制到一个新的文件中，然后在新文件中编辑内容。\r\n\r\n`cp ~/wordpress/wp-config-sample.php ~/wordpress/wp-config.php`\r\n\r\n用nano文本编辑器打开新文件wp-config.php，你也可以用vim文本编辑器。\r\n\r\n`nano ~/wordpress/wp-config.php`\r\n\r\n在wp-config.php文件中找到如下内容，根据之前的自己的设置修改文件中的数据库名、用户名和密码。\r\n\r\n<pre><code>// ** MySQL settings - You can get this info from your web host ** //\r\n/** The name of the database for WordPress */\r\ndefine(\'DB_NAME\', \'wordpress\');\r\n\r\n/** MySQL database username */\r\ndefine(\'DB_USER\', \'wpuser\');\r\n\r\n/** MySQL database password */\r\ndefine(\'DB_PASSWORD\', \'dbpassword\');</code></pre>\r\n\r\n保存文件后退出nano文本编辑器。\r\n##复制文件\r\n将wordpress目录下的所有文件复制到网站根目录:\r\n\r\n`sudo cp -r ~/wordpress/* /var/www/html/`\r\n\r\n最后我们需要将网站根目录的所有者更改为nginx用户，否则在wordpress安装主题和插件时会要求你输入FTP用户名和密码。www- data是nginx用户。我们也需要将当前用户添加到www-data组中，所以当前用户也可以对网站根目录进行读写。输入下面的命令\r\n<pre><code>sudo chown www-data:www-data /var/www/html/ -R\r\n\r\nsudo usermod -a -G www-data username\r\n\r\nnewgrp www-data</code></pre>\r\n##安装WordPress\r\nWordPress安装程序的运行需要php5-gd的支持，输入下面的命令安装php5-gd:\r\n\r\n`sudo apt-get install php5-gd`\r\n\r\n然后在浏览器的地址栏输入 ip/wp-admin/install.php，ip是Debian VPS的IP地址。填写好弹出来的表单。\r\n\r\n填写好表单后，wordpress就安装好了。我们现在可以在浏览器地址栏输入Debian VPS的IP地址来访问我们的网站了。\r\n\r\n\r\n本文转载自`Linux大神博客(https://www.linuxdashen.com/debian-8-vps)`','<h2>关于Wordpress</h2>\n<p>WordPress是一个免费自由开源的博客平台。在全球流量前1000万的网站中，超过18.9%使用WordPress来搭建网站。这使得WordPress成为最流行的博客系统。之前我们介绍过如何在树莓派上安装WordPress，Debian 8的WordPress安装过程与树莓派稍微有点不同。</p>\n<h2>安装LEMP</h2>\n<p>在Debian 8 VPS上安装WordPress之前，我们首先需要安装好LEMP。如果你没有安装好Ngnix, MySQL和PHP，那么请看<a>这篇教程进行安装</a></p>\n<p>以下的命令不是以root用户执行的，而是以另外一个管理员账号执行的，如果命令前面没有加sudo，就表示这条命令不需要root权限。</p>\n<h2>下载并设置WordPress</h2>\n<p>安装好LEMP后，通过SSH登录Debian 8 。然后输入下面的命令下载WordPress:</p>\n<p><code>wget <a href=\"http://wordpress.org/latest.tar.gz\" rel=\"nofollow\">http://wordpress.org/latest.tar.gz</a></code></p>\n<p>下载完后，解压安装包：</p>\n<p><code>tar -xzvf latest.tar.gz</code></p>\n<p>解压后，在用户的home目录会生成一个wordpress目录。</p>\n<h2>为WordPress创建一个数据库和用户</h2>\n<p>首先输入下面的命令以root用户登录MySQL shell，注意这个root用户是MySQL数据库的root用户，不是Debian系统上的root用户。</p>\n<p><code>mysql -u root -p</code></p>\n<p>这篇教程将创建一个名为wordpress的数据库，你也可以将数据库命名为其他名字，比如wp。在MySQL shell中输入下面的命令，注意不要漏掉分号。如果你漏掉了分号，那么可以在下一行添加分号，再按Enter键。</p>\n<p><code>create database wordpress;</code></p>\n<p>然后为新建的数据库创建一个新的用户。这篇教程创建的用户是wpuser。</p>\n<p><code>create user wpuser@localhost;</code></p>\n<p>为新用户设置一个密码。我设置的密码是dbpassword。</p>\n<p><code>set password for wpuser@localhost= password(\"dbpassword\");</code></p>\n<p>赋予用户所有的权限，否则wordpress的安装程序不能启动。</p>\n<p><code>grant all privileges on wordpress.* to wpuser@localhost identified by \'dbpassword\';</code></p>\n<p>刷新MySQL</p>\n<p><code>flush privileges;</code></p>\n<p>退出MySQL shell</p>\n<p><code>exit</code></p>\n<h2>设置WordPress</h2>\n<p>我们需要把WordPress的样本配置文件的内容复制到一个新的文件中，然后在新文件中编辑内容。</p>\n<p><code>cp ~/wordpress/wp-config-sample.php ~/wordpress/wp-config.php</code></p>\n<p>用nano文本编辑器打开新文件wp-config.php，你也可以用vim文本编辑器。</p>\n<p><code>nano ~/wordpress/wp-config.php</code></p>\n<p>在wp-config.php文件中找到如下内容，根据之前的自己的设置修改文件中的数据库名、用户名和密码。</p>\n<pre><code>// ** MySQL settings - You can get this info from your web host ** //\n/** The name of the database for WordPress */\ndefine(\'DB_NAME\', \'wordpress\');\n\n/** MySQL database username */\ndefine(\'DB_USER\', \'wpuser\');\n\n/** MySQL database password */\ndefine(\'DB_PASSWORD\', \'dbpassword\');</code></pre>\n\n<p>保存文件后退出nano文本编辑器。</p>\n<h2>复制文件</h2>\n<p>将wordpress目录下的所有文件复制到网站根目录:</p>\n<p><code>sudo cp -r ~/wordpress/* /var/www/html/</code></p>\n<p>最后我们需要将网站根目录的所有者更改为nginx用户，否则在wordpress安装主题和插件时会要求你输入FTP用户名和密码。www- data是nginx用户。我们也需要将当前用户添加到www-data组中，所以当前用户也可以对网站根目录进行读写。输入下面的命令\n</p><pre><code>sudo chown www-data:www-data /var/www/html/ -R<p></p>\n<p>sudo usermod -a -G www-data username</p>\n</code><p><code>newgrp www-data</code></p></pre><p></p>\n<h2>安装WordPress</h2>\n<p>WordPress安装程序的运行需要php5-gd的支持，输入下面的命令安装php5-gd:</p>\n<p><code>sudo apt-get install php5-gd</code></p>\n<p>然后在浏览器的地址栏输入 ip/wp-admin/install.php，ip是Debian VPS的IP地址。填写好弹出来的表单。</p>\n<p>填写好表单后，wordpress就安装好了。我们现在可以在浏览器地址栏输入Debian VPS的IP地址来访问我们的网站了。</p>\n<p>本文转载自<code>Linux大神博客(<a href=\"https://www.linuxdashen.com/debian-8-vps\" rel=\"nofollow\">https://www.linuxdashen.com/debian-8-vps</a>)</code></p>','2017-11-15 19:34:25',3,1),(35,'无法安装libmysqld-dev','<pre><code>\r\nReading package lists... Done\r\nBuilding dependency tree       \r\nReading state information... Done\r\nSome packages could not be installed. This may mean that you have\r\nrequested an impossible situation or if you are using the unstable\r\ndistribution that some required packages have not yet been created\r\nor been moved out of Incoming.\r\nThe following information may help to resolve the situation:\r\n\r\nThe following packages have unmet dependencies:\r\n libmysqld-dev : Depends: libnuma-dev but it is not going to be installed\r\nE: Unable to correct problems, you have held broken packages.\r\n\r\n</code></pre>\r\n原因是依赖的版本不对，继续往下查libnuma-dev这个依赖\r\n\r\n```\r\napt install libnuma-dev```\r\n\r\n<pre><code>\r\nReading package lists... Done\r\nBuilding dependency tree       \r\nReading state information... Done\r\nSome packages could not be installed. This may mean that you have\r\nrequested an impossible situation or if you are using the unstable\r\ndistribution that some required packages have not yet been created\r\nor been moved out of Incoming.\r\nThe following information may help to resolve the situation:\r\n\r\nThe following packages have unmet dependencies:\r\n libnuma-dev : Depends: libnuma1 (= 2.0.11-1ubuntu1) but 2.0.11-1ubuntu1.1 is to be installed\r\nE: Unable to correct problems, you have held broken packages.\r\n</code></pre>\r\n发现源头了，是libnuma1的版本不对，接下来只要安装要求的版本就ok了','<pre><code>\nReading package lists... Done\nBuilding dependency tree       \nReading state information... Done\nSome packages could not be installed. This may mean that you have\nrequested an impossible situation or if you are using the unstable\ndistribution that some required packages have not yet been created\nor been moved out of Incoming.\nThe following information may help to resolve the situation:\n\nThe following packages have unmet dependencies:\n libmysqld-dev : Depends: libnuma-dev but it is not going to be installed\nE: Unable to correct problems, you have held broken packages.\n\n</code></pre>\n\n<p>原因是依赖的版本不对，继续往下查libnuma-dev这个依赖</p>\n<p><code>apt install libnuma-dev</code></p>\n<pre><code>\nReading package lists... Done\nBuilding dependency tree       \nReading state information... Done\nSome packages could not be installed. This may mean that you have\nrequested an impossible situation or if you are using the unstable\ndistribution that some required packages have not yet been created\nor been moved out of Incoming.\nThe following information may help to resolve the situation:\n\nThe following packages have unmet dependencies:\n libnuma-dev : Depends: libnuma1 (= 2.0.11-1ubuntu1) but 2.0.11-1ubuntu1.1 is to be installed\nE: Unable to correct problems, you have held broken packages.\n</code></pre>\n\n<p>发现源头了，是libnuma1的版本不对，接下来只要安装要求的版本就ok了</p>','2018-02-11 21:22:40',3,1),(36,'nginx无法启动','部署网站时发现nginx无法启动，困扰了很久，检查nginx状态时给出如下代码。\r\n<pre><code>\r\n● nginx.service - A high performance web server and a reverse proxy server\r\n   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)\r\n   Active: failed (Result: exit-code) since Mon 2018-02-12 14:59:44 CST; 1min 17s ago\r\n  Process: 10502 ExecStop=/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid (code=exited, status=0/SUCCESS)\r\n  Process: 10462 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)\r\n  Process: 10578 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=1/FAILURE)\r\n Main PID: 10465 (code=exited, status=0/SUCCESS)\r\n\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: Starting A high performance web server and a reverse proxy server...\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ nginx[10578]: nginx: [emerg] unknown directive \"&lt;U+FEFF&gtserver\" in /etc/nginx/sites-enabled/default:1\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ nginx[10578]: nginx: configuration file /etc/nginx/nginx.conf test failed\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: nginx.service: Control process exited, code=exited status=1\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: Failed to start A high performance web server and a reverse proxy server.\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: nginx.service: Unit entered failed state.\r\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: nginx.service: Failed with result \'exit-code\'.\r\n</code></pre>\r\n后来又发现从别的服务器上拷贝来nginx配置文件可以运行，但是将其中的内容拷贝过来又会出错。\r\n\r\n其实错误代码中已经写出来了[emerg] unknown directive \"&lt;U+FEFF&gt;server\"，在server前面有个&lt;U+FEFF&gt;，上网搜索一下发现是编码的问题。其实问题出在我的编辑器上，换一个编辑器或者更改一下编辑器的编码就可以了。','<p>部署网站时发现nginx无法启动，困扰了很久，检查nginx状态时给出如下代码。\n</p><pre><code>\n● nginx.service - A high performance web server and a reverse proxy server\n   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)\n   Active: failed (Result: exit-code) since Mon 2018-02-12 14:59:44 CST; 1min 17s ago\n  Process: 10502 ExecStop=/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid (code=exited, status=0/SUCCESS)\n  Process: 10462 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)\n  Process: 10578 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=1/FAILURE)\n Main PID: 10465 (code=exited, status=0/SUCCESS)<p></p>\n</code><p><code>Feb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: Starting A high performance web server and a reverse proxy server...\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ nginx[10578]: nginx: [emerg] unknown directive \"&lt;U+FEFF&amp;gtserver\" in /etc/nginx/sites-enabled/default:1\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ nginx[10578]: nginx: configuration file /etc/nginx/nginx.conf test failed\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: nginx.service: Control process exited, code=exited status=1\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: Failed to start A high performance web server and a reverse proxy server.\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: nginx.service: Unit entered failed state.\nFeb 12 14:59:44 iZuf61q38vbvbav4hd0saeZ systemd[1]: nginx.service: Failed with result \'exit-code\'.\n</code></p></pre>\n后来又发现从别的服务器上拷贝来nginx配置文件可以运行，但是将其中的内容拷贝过来又会出错。<p></p>\n<p>其实错误代码中已经写出来了[emerg] unknown directive \"&lt;U+FEFF&gt;server\"，在server前面有个&lt;U+FEFF&gt;，上网搜索一下发现是编码的问题。其实问题出在我的编辑器上，换一个编辑器或者更改一下编辑器的编码就可以了。</p>','2018-02-12 15:17:07',2,1),(37,'shadowsocks启动失败','最近好几次ssserver无法启动，后来终于查出来了，是openssl升级导致的。\r\n\r\n**是因为openssl1.1.0版本中，废弃了EVP_CIPHER_CTX_cleanup函数，可以用EVP_CIPHER_CTX_reset来代替此函数\r\n此文件/usr/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py中搜索所有的EVP_CIPHER_CTX_cleanup以EVP_CIPHER_CTX_reset代替即可，总共有两处。**','<p>最近好几次ssserver无法启动，后来终于查出来了，是openssl升级导致的。</p>\n<p><strong>是因为openssl1.1.0版本中，废弃了EVP_CIPHER_CTX_cleanup函数，可以用EVP_CIPHER_CTX_reset来代替此函数\n此文件/usr/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py中搜索所有的EVP_CIPHER_CTX_cleanup以EVP_CIPHER_CTX_reset代替即可，总共有两处。</strong></p>','2018-02-13 13:05:33',3,1);
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `c5game`
--

DROP TABLE IF EXISTS `c5game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `c5game` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `address` varchar(64) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `min` float DEFAULT NULL,
  `verify` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB AUTO_INCREMENT=553407192 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `c5game`
--

LOCK TABLES `c5game` WRITE;
/*!40000 ALTER TABLE `c5game` DISABLE KEYS */;
INSERT INTO `c5game` VALUES (806358,'铭刻 炎铸大太刀','https://www.c5game.com/dota/2820-S.html',12.5,10,1),(145422562,'生还者长发','https://www.c5game.com/dota/145421808-S.html',194.99,194.5,1),(553407191,'魔倾乾坤','https://www.c5game.com/dota/553443315-S.html',31.48,31.35,1);
/*!40000 ALTER TABLE `c5game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorys`
--

DROP TABLE IF EXISTS `categorys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorys`
--

LOCK TABLES `categorys` WRITE;
/*!40000 ALTER TABLE `categorys` DISABLE KEYS */;
INSERT INTO `categorys` VALUES (3,'linux'),(2,'web'),(5,'随便写');
/*!40000 ALTER TABLE `categorys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `body` text,
  `body_html` text,
  `create_time` datetime DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `ix_comments_create_time` (`create_time`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `articles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `record`
--

DROP TABLE IF EXISTS `record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime DEFAULT NULL,
  `comment` text,
  `verify` tinyint(1) DEFAULT NULL,
  `comment_html` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record`
--

LOCK TABLES `record` WRITE;
/*!40000 ALTER TABLE `record` DISABLE KEYS */;
INSERT INTO `record` VALUES (5,'2017-08-26 22:27:07','##ss账号\r\n8.20 微信：曼殊沙华\r\n\r\n8.27 微信：L dong',0,'<h2>ss账号</h2>\n<p>8.20 微信：曼殊沙华</p>\n<p>8.27 微信：L dong</p>'),(6,'2017-09-15 23:29:31','create database baoming default character set utf8 collate utf8_general_ci;',0,'<p>create database baoming default character set utf8 collate utf8_general_ci;</p>'),(7,'2017-11-07 19:43:13','工号34069',0,'<p>工号34069</p>'),(8,'2017-11-17 16:34:29','太强了',0,'<p>太强了</p>'),(9,'2017-12-12 18:58:00','测试',0,'<p>测试</p>'),(10,'2017-12-12 18:59:41','测试',0,'<p>测试</p>'),(11,'2017-12-21 00:09:27','测试',0,'<p>测试</p>'),(12,'2017-12-21 00:22:33','1',0,'<p>1</p>'),(13,'2017-12-21 00:23:40','test',0,'<p>test</p>'),(14,'2018-01-08 00:22:20','爱情就是这么不公平呀，站在爱情制高点的人成了神，你把你所有的爱给了她，把你所有的光都打在她的身上，让她成了耀眼的神，可是你知道吗，你才是光本身啊！',1,'<p>爱情就是这么不公平呀，站在爱情制高点的人成了神，你把你所有的爱给了她，把你所有的光都打在她的身上，让她成了耀眼的神，可是你知道吗，你才是光本身啊！</p>'),(15,'2018-02-19 22:33:27','ali half:987924d0',0,'<p>ali half:987924d0</p>'),(16,'2018-02-19 22:34:33','virmach:c3229991',0,'<p>virmach:c3229991</p>'),(17,'2018-02-19 22:39:16','tencenthk:db4a57f5',0,'<p>tencenthk:db4a57f5</p>'),(18,'2018-02-23 22:30:07','guest test post \r\n<a href=\" http://temresults2018.com/ \">bbcode</a> \r\n<a href=\"http://temresults2018.com/\">html</a> \r\nhttp://temresults2018.com/ simple',0,'<p>guest test post \n<a href=\" http://temresults2018.com/ \" rel=\"nofollow\">bbcode</a> \n<a href=\"http://temresults2018.com/\" rel=\"nofollow\">html</a> \n<a href=\"http://temresults2018.com/\" rel=\"nofollow\">http://temresults2018.com/</a> simple</p>');
/*!40000 ALTER TABLE `record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `password_hash` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'zhangshijie','pbkdf2:sha256:50000$6uWscYY1$28f0b6a170ae8f8b0243c6a674cc2040d14c2bff564f6fada38b10581aa37aa0');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-02-27 17:51:44
