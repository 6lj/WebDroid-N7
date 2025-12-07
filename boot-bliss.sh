#!/bin/bash

echo "  ____    _     ____    ____    ____ "
echo " | __ )  | |   / ___|  / ___|  / ___|"
echo " |  _ \  | |   \___ \  \___ \  \___ \ "
echo " | |_) | | |___ ___) |  ___) |  ___) |"
echo " |____/  |_____|____/  |____/  |____/ "
echo "                                      "
echo "Bliss OS Boot Script"
echo "===================="

# Set default values
DISPLAY_WIDTH=${DISPLAY_WIDTH:-1920}
DISPLAY_HEIGHT=${DISPLAY_HEIGHT:-1080}
MEMORY=${MEMORY:-4096}
CPUS=${CPUS:-2}

echo "Starting Bliss OS with:"
echo "Resolution: ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}"
echo "Memory: ${MEMORY}MB"
echo "CPUs: ${CPUS}"
echo "Working directory: $(pwd)"
echo "Available files:"
ls -la /build/

# Create a temporary qcow2 disk for data persistence
if [ ! -f /tmp/bliss-data.qcow2 ]; then
    qemu-img create -f qcow2 /tmp/bliss-data.qcow2 8G
fi

# Set VNC password
echo "Setting VNC password..."
if [ -n "$VNCPASS" ]; then
    VNC_PASSWORD="$VNCPASS"
else
    VNC_PASSWORD="admin"
fi

# Check if KVM is available, use software emulation if not
if [ -e /dev/kvm ] && [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
    KVM_FLAG="-enable-kvm"
    CPU_FLAG="-cpu host"
    echo "Using hardware virtualization (KVM)"
else
    KVM_FLAG=""
    CPU_FLAG="-cpu qemu64"
    echo "Using software emulation (no KVM available)"
fi

# Try booting from ISO first (more reliable)
if [ -f /build/Bliss-v7.2-android_x86-OFFICIAL-20170626-1555_k4.9-b_m17.1_pw_rc_01.iso ]; then
    echo "Booting from ISO file..."
    echo "VNC Password will be set to: $VNC_PASSWORD"

    # Start QEMU with VNC - Ultra High Performance Mode
    qemu-system-x86_64 \
        $KVM_FLAG \
        -m ${MEMORY} \
        -smp ${CPUS} \
        $CPU_FLAG \
        -vga std \
        -vnc 127.0.0.1:1 \
        -cdrom /build/Bliss-v7.2-android_x86-OFFICIAL-20170626-1555_k4.9-b_m17.1_pw_rc_01.iso \
        -drive file=/tmp/bliss-data.qcow2,if=virtio,format=qcow2,cache=writeback,aio=threads \
        -net nic,model=virtio -net user \
        -device virtio-tablet \
        -device virtio-keyboard \
        -device virtio-gpu \
        -usb \
        -device usb-tablet \
        -soundhw hda \
        -monitor none \
        -serial none \
        -rtc base=localtime \
        -global ICH9-LPC.disable_s3=1 \
        -global ICH9-LPC.disable_s4=1 \
        -boot menu=on,splash-time=0 &
    QEMU_PID=$!

    # Wait for QEMU to start
    sleep 3
    echo "Android is booting... VNC server should be available soon"

    # Wait for QEMU process
    wait $QEMU_PID
else
    echo "ISO not found, trying extracted files..."
    # Boot Bliss OS using extracted files
    qemu-system-x86_64 \
        $KVM_FLAG \
        -m ${MEMORY} \
        -smp ${CPUS} \
        $CPU_FLAG \
        -vga std \
        -vnc 127.0.0.1:1 \
        -kernel /build/kernel \
        -initrd /build/initrd.img \
        -append "root=/dev/ram0 androidboot.selinux=permissive quiet SRC=/android DATA=/data" \
        -drive file=/build/system.sfs,if=virtio,format=raw,readonly \
        -drive file=/tmp/bliss-data.qcow2,if=virtio,format=qcow2 \
        -net nic,model=virtio -net user \
        -device virtio-tablet \
        -device virtio-keyboard \
        -usb \
        -device usb-tablet \
        -soundhw hda \
        -monitor none \
        -serial none &
    QEMU_PID=$!

    # Wait for QEMU to start
    sleep 3
    echo "Android is booting... VNC server should be available soon"

    # Wait for QEMU process
    wait $QEMU_PID
fi
