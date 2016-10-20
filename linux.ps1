break
# #############################################################################
# Linux and DSC
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# TWITTER: @TechTrainerTim
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

#region Install Linux Prereqs

yum groupinstall 'Development Tools'
yum install pam-devel
yum install openssl-devel
yum install wget

#endregion

#region Install OMI on Linux

mkdir /root/downloads
cd /root/downloads
wget https://collaboration.opengroup.org/omi/documents/30532/omi-1.0.8.tar.gz
tar -xvf omi-1.0.8.tar.gz

cd omi-1.0.8/
./configure
make
sudo make install

#endregion

#region Install DSC on Linux

yum install python
yum install python-devel
cd /root/downloads
wget https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-294/dsc-1.1.1-294.ssl_100.x64.rpm
sudo rpm -Uvh dsc-1.1.1-294.ssl_098.x64.rpm

https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-294/dsc-1.1.1-294.ssl_098.x64.rpm

#endregion



