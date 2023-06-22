#!/bin/bash
source /home/bubify/.bashrc
sudo /etc/init.d/nginx start

cd portal/frontend
npm run build-dev
cd ..
mvn spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=development -Dspring-boot.run.jvmArguments=-XX:+UseZGC

