# author: @debarron
# 08/12/2018
#
# RUN IT AS: ./local_install
# 
# The following script configures OpenSlide on a local machine.
# Previous to install and configure OpenSlide, we need a set of
# dependencies, which the script installs individually.
# 
# After all dependencies are installed, it downloads two repos: 
# + https://github.com/openslide/openslide.git 
# + https://github.com/openslide/openslide-java.git
# 
# You can check the LOCAL_LOG.log file and check if everythin 
# has been taken care of correctly.

# java -jar openslide.jar
# Run it in cloudlab


# 1 Install dependencies
sudo sed -i -e '2s/^/#/' /etc/apt/sources.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install --yes libjpeg-dev 
sudo apt-get install --yes libpng-dev
sudo apt-get install --yes liblcms2-dev
sudo apt-get install --yes libtiff-dev
sudo apt-get install --yes libpng-dev
sudo apt-get install --yes zlib1g-dev

sudo apt update --yes
sudo apt install --yes libjpeg-dev
sudo apt install --yes libopenjp2-7
sudo apt install --yes libopenjp2-7-dev
sudo apt install --yes libtiff-dev
sudo apt install --yes libcairo-dev
sudo apt install --yes libglib-dev
sudo apt install --yes libgtk2.0-dev
sudo apt install --yes libxml2-dev
sudo apt install --yes sqlite3
sudo apt install --yes libsqlite3-dev
sudo apt install --yes libopenblas-base
sudo apt install --yes openslide-tools
sudo apt install --yes pkg-config 
sudo apt install --yes software-properties
sudo apt install --yes ant 
sudo apt install --yes python-pip 

export JAVA_HOME='/usr/lib/jvm/default-java'

openslide_prefix="$HOME/openslide-dep"
rm -Rf "$openslide_prefix"
mkdir "$openslide_prefix"

# 2 Install openslide
git clone "https://github.com/openslide/openslide.git" "$openslide_prefix/openslide"
cd "$openslide_prefix/openslide"
libtoolize --force && aclocal && autoheader > /dev/null
automake --force-missing --add-missing > /dev/null 
autoconf && ./configure && make && sudo make install > /dev/null


# 3 Install openslide-java
git clone "https://github.com/openslide/openslide-java.git" "$openslide_prefix/openslide-java"
cd "$openslide_prefix/openslide-java"
libtoolize --force && aclocal && autoheader > /dev/null
automake --force-missing --add-missing > /dev/null 
autoconf && ./configure && make && sudo make install > /dev/null

# 4 Fix the link issue
sudo ln -s /usr/local/lib/openslide-java/libopenslide-jni.so /usr/local/lib/openslide-java/libopenslide-jni.jnilib 

# 5 Create a reference to use in nidan-wsi-core
echo "export OPENSLIDE_JAVA='/usr/local/lib/openslide-java'" >> ~/.bashrc

echo "INSTALL PIP OPENSLIDE"
pip install openslide-python
