# Install dependencies first
sudo apt install -y ocl-icd-libopencl1 ocl-icd-opencl-dev clinfo

# Create temporary directory
mkdir -p ~/intel-opencl-temp
cd ~/intel-opencl-temp

# Download LATEST packages (January 2026)
wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.27.10/intel-igc-core-2_2.27.10+20617_amd64.deb
wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.27.10/intel-igc-opencl-2_2.27.10+20617_amd64.deb
wget https://github.com/intel/compute-runtime/releases/download/26.01.36711.4/libigdgmm12_22.9.0_amd64.deb
wget https://github.com/intel/compute-runtime/releases/download/26.01.36711.4/intel-opencl-icd_26.01.36711.4-0_amd64.deb
wget https://github.com/intel/compute-runtime/releases/download/26.01.36711.4/libze-intel-gpu1_26.01.36711.4-0_amd64.deb

# Install in correct order
sudo dpkg -i libigdgmm12_22.9.0_amd64.deb
sudo dpkg -i intel-igc-core-2_2.27.10+20617_amd64.deb
sudo dpkg -i intel-igc-opencl-2_2.27.10+20617_amd64.deb
sudo dpkg -i intel-opencl-icd_26.01.36711.4-0_amd64.deb
sudo dpkg -i libze-intel-gpu1_26.01.36711.4-0_amd64.deb

# Fix any dependencies
sudo apt --fix-broken install -y

# Verify installation
clinfo | grep -i intel

# Add user to render group
getent group render && sudo usermod -a -G render $USER