CREATE USER 'kelompokf10'@'%' IDENTIFIED BY 'passwordf10';
CREATE USER 'kelompokf10'@'localhost' IDENTIFIED BY 'passworf10';
CREATE DATABASE dbkelompokf10;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf10'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokf10'@'localhost';
FLUSH PRIVILEGES;