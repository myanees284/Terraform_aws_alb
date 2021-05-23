#!/bin/bash
    yum install httpd -y
    systemctl enable httpd
    mkdir /var/www/html/product
    echo "<h1> This is PRODUCT APPS<h1>" > /var/www/html/product/index.html
    service httpd start
    chkconfig httpd on