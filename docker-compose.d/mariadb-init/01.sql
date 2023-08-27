CREATE DATABASE IF NOT EXISTS `astronomican`;
GRANT ALL PRIVILEGES ON astronomican.* TO 'astronomican'@'%' IDENTIFIED BY 'astronomican';

CREATE DATABASE IF NOT EXISTS `kea`;
GRANT ALL PRIVILEGES ON kea.* TO 'kea'@'%' IDENTIFIED BY 'kea';
