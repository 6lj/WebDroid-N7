#  WebDroid-N7

![](https://i.ibb.co/XkXxynB9/Screenshot-2025-12-07-074034.png)

## First Ever Pure Web Android 7.1 Full System


**WebDroid-N7** is the world's first complete Android 7.1 (Nougat) operating system running natively in web browsers. Unlike traditional Android emulators, this provides the full Bliss OS x86 experience with hardware virtualization, multi-user support, and pure web accessibility.


### Android System Files
Before running WebDroid-N7, you need to download and prepare the Android system files:

1. **Download Bliss OS ISO**:
   - 📥 **Download Link**: [Bliss-v7.2-android_x86-OFFICIAL-20170626-1555_k4.9-b_m17.1_pw_rc_01.iso](https://androidfilehost.com/?fid=673791459329053928)
   - 📊 **File Size**: ~697MB

2. **Extract ISO Files**:
   ```bash
   # On Windows: Use 7-Zip or WinRAR
   # On Linux/Mac: Use archive manager or terminal

   # Extract ISO contents to the folder
   # DO NOT DELETE the .iso file after extraction
   ```

3. **File Structure**:
   After extraction, your `Bliss-v7.2-android_x86/` folder should contain:
   ```
   Bliss-v7.2-android_x86/
   Bliss-v7.2-android_x86-OFFICIAL-*.iso  # ← KEEP THIS FILE
   kernel                                 
   initrd.img                            
   system.sfs                            
   ramdisk.img                           
   index.html                            
   ```

### ⚠️ Important Notes
- **Keep the ISO file**: Do NOT delete `Bliss-v7.2-android_x86-OFFICIAL-20170626-1555_k4.9-b_m17.1_pw_rc_01.iso` after extraction
- **Complete extraction**: Ensure all files are properly extracted
- **File integrity**: The system may not work if files are corrupted during download/extraction

## 📋 System Requirements

### Minimum Requirements
- **OS**: Windows 10/11, Linux, or macOS
- **RAM**: 4GB available (8GB recommended)
- **Storage**: 2GB free space for container + Android system files
- **CPU**: Intel/AMD with virtualization support

### Recommended Requirements
- **RAM**: 8GB+ for smooth performance
- **CPU**: Multi-core processor with VT-x/AMD-V enabled
- **Storage**: SSD recommended for faster boot times
- **Network**: Stable internet for initial setup

### Software Prerequisites
- ✅ **Docker Desktop** (latest version)
- ✅ **Docker Compose** V2
- ✅ **Hardware Virtualization** enabled in BIOS/UEFI
- ✅ **Admin/Sudo privileges** for Docker operations

### Verification Commands
```bash
# Check Docker installation
docker --version
docker-compose --version

# Verify virtualization (Windows)
systeminfo | findstr "Virtualization"

# Check available RAM
docker system info | grep "Total Memory"
```



### 1. Download Required Files
**First, download and prepare the Android system files** (see [📥 Download Required Files](#-download-required-files) section above).

### 2. Download WebDroid-N7
```bash
git clone https://github.com/6lj/WebDroid-N7.git
cd WebDroid-N7
```



### 4. Launch Android System

#### 🏃‍♂️ Fast Start (Recommended)
```bash
# One-command launch with optimized build
.\fast-build.ps1
```

#### 🔧 Standard Build
```bash
docker-compose -f docker-compose.bliss.yml up --build
```

#### ⚡ Force Clean Rebuild (Windows)
```powershell
.\build-and-run.ps1  # PowerShell
```
```batch
build-and-run.bat    # Command Prompt
```

### 4. Access Your Android System
1. **Open Browser**: Navigate to `http://localhost:8000`
2. **No Password Required**: Android desktop loads automatically
3. **Multiple Sessions**: Open multiple tabs for independent Android instances
4. **Auto-Scaling**: Interface adapts to your screen size



### Basic Controls
- **Mouse & Keyboard**: Direct input to Android system
- **Shutdown Button**: Gracefully terminate Android instance
- **Refresh**: Reconnect to running session
- **Close**: Disconnect current session

### Multi-User Features
- **Independent Sessions**: Each browser tab runs separate Android instance
- **Automatic Cleanup**: Previous instances terminated when new ones start
- **Resource Management**: Smart memory and process handling

### Performance Tips
- **RAM Allocation**: Increase `MEMORY` for better performance
- **CPU Cores**: More cores = smoother experience
- **SSD Storage**: Faster boot times and app loading
- **Close Unused Tabs**: Free up system resources

## ⚙️ Configuration & Customization

### Core Settings (docker-compose.bliss.yml)




#### High-Performance Setup
```yaml
environment:
  - DISPLAY_WIDTH=2560
  - DISPLAY_HEIGHT=1440
  - MEMORY=8192              # 8GB RAM
  - CPUS=4               
```

#### Lightweight Setup (Low-end hardware)
```yaml
environment:
  - DISPLAY_WIDTH=1280
  - DISPLAY_HEIGHT=720
  - MEMORY=2048              # 2GB RAM
  - CPUS=1                
```

### Network Configuration

#### Custom Ports
```yaml
ports:
  - "3000:8000"    
  - "3001:8080"    
  - "5902:5901"    
```

#### Remote Access
```yaml
ports:
  - "0.0.0.0:8000:8000"  
```

### Data Persistence

#### Persistent User Data
```yaml
volumes:
  - ./android-data:/data:rw     # Persistent app data
  - ./android-downloads:/sdcard/Download:rw  # Downloads folder
```

#### Custom System Files
```yaml
volumes:
  - ./custom-kernel:/build/kernel:ro        # Custom kernel
  - ./custom-initrd:/build/initrd.img:ro    # Custom initrd
```

## 🔧 Troubleshooting & Support

### Quick Diagnosis
```bash
# Check container status
docker-compose -f docker-compose.bliss.yml ps

# View real-time logs
docker-compose -f docker-compose.bliss.yml logs -f webdroid-n7

# Check resource usage
docker stats

# Verify virtualization
docker run --rm -it alpine cat /proc/cpuinfo | grep -E "(vmx|svm)"
```

### Common Issues & Solutions

#### 🚫 "Virtualization not enabled"
**Symptoms**: Container starts but Android won't boot
**Solutions**:
```bash
# Windows: Check virtualization
systeminfo | findstr "Virtualization"

# Enable in BIOS/UEFI (varies by manufacturer)
# Restart computer after enabling
```

#### 🚫 "Port already in use"
**Symptoms**: `bind: address already in use`
**Solutions**:
```yaml
# Change ports in docker-compose.bliss.yml
ports:
  - "8001:8000"  # Try different external port
  - "8081:8080"
  - "5902:5901"
```

#### 🚫 "Insufficient memory"
**Symptoms**: Container exits with memory errors
**Solutions**:
```yaml
environment:
  - MEMORY=2048  # Reduce to 2GB
  - CPUS=1       # Use single core
```

#### 🚫 "Black screen or no display"
**Symptoms**: noVNC connects but shows black screen
**Solutions**:
```bash
# Check Android boot logs
docker-compose -f docker-compose.bliss.yml logs webdroid-n7

# Verify system files exist
ls -la Bliss-v7.2-android_x86/

# Test direct VNC connection
# Connect to localhost:5901 with VNC client
```

#### 🚫 "Build context too large"
**Symptoms**: Build fails with context size errors
**Solutions**:
```bash
# Use optimized build script
.\fast-build.ps1

# Or manually with no-cache
docker-compose -f docker-compose.bliss.yml build --no-cache
```

### Performance Optimization

#### Slow Boot Times
1. **Use SSD storage** for Android system files
2. **Increase RAM allocation** (minimum 4GB)
3. **Enable KVM acceleration** in BIOS
4. **Close other applications** consuming resources

#### Lag/Stuttering
1. **Reduce display resolution** for better performance
2. **Allocate more CPU cores** in configuration
3. **Close unused browser tabs**
4. **Update Docker Desktop** to latest version

### Recovery Commands

```bash
# Force clean restart
docker-compose -f docker-compose.bliss.yml down
docker system prune -f
docker-compose -f docker-compose.bliss.yml up --build

# Reset Android data
rm -f android-data.qcow2
docker-compose -f docker-compose.bliss.yml up --build

# Complete system reset
docker-compose -f docker-compose.bliss.yml down -v
docker system prune -a -f
docker volume prune -f
```

## 🛠️ Development & Contributing

### Local Development Setup
```bash
# Clone repository
git clone https://github.com/6lj/WebDroid-N7.git
cd WebDroid-N7

# Install development dependencies
pip install flask psutil

# Run in development mode
python web_server.py
```





### Building from Source
```bash
# Full rebuild with no cache
docker-compose -f docker-compose.bliss.yml build --no-cache

# Development build
docker-compose -f docker-compose.bliss.yml build --progress=plain

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -t webdroid-n7 .
```

## 📊 Performance Benchmarks

### Boot Times (Approximate)
- **Cold Start**: 45-90 seconds (first time)
- **Warm Start**: 15-30 seconds (cached)
- **Hot Restart**: 5-10 seconds (same container)

### Resource Usage
- **RAM**: 2-8GB (configurable)
- **CPU**: 1-4 cores (configurable)
- **Storage**: ~2GB container + 8GB Android data


### Supported Platforms
- ✅ **Windows 10/11** (Docker Desktop)
- ✅ **macOS** (Docker Desktop)
- ✅ **Linux** (Native Docker)
- ✅ **WSL2** (Windows Subsystem)

## 🌟 Unique Features

### Multi-User Architecture
- **Independent Sessions**: Each browser tab = separate Android instance
- **Automatic Cleanup**: Smart process termination
- **Resource Isolation**: No interference between sessions

### Web-Native Design
- **Zero Installation**: Works in any modern browser
- **Responsive UI**: Adapts to screen size automatically
- **Touch Support**: Optimized for tablets and touchscreens

### Enterprise-Ready
- **Containerized**: Portable and scalable
- **Configurable**: Extensive customization options
- **Monitorable**: Comprehensive logging and metrics

## 🤝 Contributing

### Ways to Contribute
- 🐛 **Bug Reports**: Use GitHub Issues
- 💡 **Feature Requests**: Submit enhancement proposals
- 🔧 **Code Contributions**: Fork and submit PRs
- 📖 **Documentation**: Improve guides and tutorials

### Development Guidelines
1. **Code Style**: Follow PEP 8 for Python
2. **Testing**: Test on multiple platforms
3. **Documentation**: Update README for new features
4. **Compatibility**: Ensure cross-platform support

### Community Support
- 📧 **Email**: q@q5.qa


### Credits & Attribution
- **Bliss OS**: Android-x86 distribution
- **QEMU**: Hardware virtualization
- **noVNC**: Web-based VNC client
- **Docker**: Container platform
- **Ubuntu**: Base container OS

## ⚡ Performance Optimizations

### Ultra-Fast Mode ⭐ **RECOMMENDED**
For maximum performance, use the ultra-fast startup script:
```powershell
.\ultra-fast-start.ps1
```

**Performance Features:**
- 🚀 **12GB RAM** allocation for smooth Android operation
- 🔄 **6 CPU cores** for maximum processing power
- 💾 **4GB shared memory** for better graphics performance
- ⚡ **Docker BuildKit** for 3x faster builds
- 🏗️ **Parallel building** for reduced build times



### Advanced Optimizations

#### QEMU Performance Tuning
- Hardware virtualization (KVM) acceleration
- VirtIO devices for better I/O performance
- Optimized CPU flags for host passthrough
- RTC synchronization for accurate timing

#### Network Optimizations
- Multi-threaded Flask server
- HTTP/1.1 protocol optimization
- Reduced connection timeouts

#### Build Optimizations
- Ubuntu mirror optimization for faster downloads
- APT recommendations disabled
- Parallel package installation
- Minimal build context (10KB vs 1.4GB)


#### By ENDUP



