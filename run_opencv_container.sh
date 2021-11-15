#!/bin/bash
# Mohamed BEN ALI Research engineer

echo ""

echo -e "\run opencv docker container\n"
sudo docker run -d --name opencv_container -v /home/storage_lin/opencv_docker:/home/storage_lin/opencv_docker -p 8888:8888 opencv_docker 

echo ""


