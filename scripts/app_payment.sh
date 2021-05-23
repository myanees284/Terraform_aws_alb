#!/bin/bash
    yum install httpd -y
    systemctl enable httpd
    mkdir /var/www/html/payment
    echo "<h1> This is PAYMENT APPS<h1>" > /var/www/html/payment/index.html
    service httpd start
    chkconfig httpd on