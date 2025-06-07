#!/bin/bash

cd /root/temp
rm *
cp /var/log/apache2/*access* .
gunzip *access*gz -f
cat * > combined
goaccess -f combined -a
