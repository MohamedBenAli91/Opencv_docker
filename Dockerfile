FROM ubuntu:20.04
MAINTAINER Mohamed BEN ALI <mbenali@linagora.com>

# Refresh the packages index and install the OpenCV package
RUN apt -y update && apt upgrade -y 
RUN apt install software-properties-common -y && apt install wget git nano vim -y
RUN apt install -y python3-opencv

# install dependencies
RUN apt install -y build-essential cmake git pkg-config libgtk-3-dev
RUN add-apt-repository ppa:deadsnakes/ppa -y && apt update -y && apt install python3.8 -y
RUN apt install python3-pip -y 
RUN apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt install -y libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev
RUN apt install -y gfortran openexr libatlas-base-dev python3-dev python3-numpy
RUN apt install -y libtbb2 libtbb-dev libdc1394-22-dev zip nano

# clone the OpenCV's and OpenCV contrib repositories
RUN mkdir -p /OPENCV/opencv_build 
WORKDIR  /OPENCV/opencv_build
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

# Create a buid directory
WORKDIR  /OPENCV/opencv_build/opencv
RUN mkdir build 
WORKDIR /OPENCV/opencv_build/opencv/build

# Set up the OpenCV build with CMake
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \ 
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/OPENCV/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

# compilation process
RUN make -j4

#install opencv with make
RUN make install

# verify installation
RUN pkg-config --modversion opencv4

# install jupyter 
RUN pip3 install jupyter

# configure jupyter notebook
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py

# expose to port 
EXPOSE 8888

# run process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/OPENCV", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
