#!/usr/bin/env python3

from flask import Flask, send_from_directory, jsonify, request
import os
import subprocess
import threading
import time
import signal
import psutil

app = Flask(__name__)

# Global variable to track boot status
boot_status = {
    'status': 'ready',
    'progress': 0,
    'message': 'System ready to boot'
}

# Global variable to track current boot process
current_boot_process = None

def kill_existing_android_processes():
    """Kill any existing Android/QEMU processes"""
    try:
        # Kill any qemu-system-x86_64 processes
        result = subprocess.run(['pkill', '-f', 'qemu-system-x86_64'],
                              capture_output=True, text=True)
        print(f"Killed existing QEMU processes: {result.returncode}")

        # Also kill any boot-bliss.sh processes
        result = subprocess.run(['pkill', '-f', 'boot-bliss.sh'],
                              capture_output=True, text=True)
        print(f"Killed existing boot processes: {result.returncode}")

        # Wait a moment for processes to terminate
        time.sleep(2)

    except Exception as e:
        print(f"Error killing processes: {e}")

def run_boot_process():
    """Run the Android boot process in a separate thread"""
    global boot_status, current_boot_process

    try:
        # Kill any existing Android processes first
        kill_existing_android_processes()

        boot_status['status'] = 'booting'
        boot_status['progress'] = 25
        boot_status['message'] = 'Terminating existing Android instances...'

        time.sleep(1)

        boot_status['progress'] = 50
        boot_status['message'] = 'Starting QEMU virtual machine...'

        # Run the boot script in background
        current_boot_process = subprocess.Popen(
            ['/home/bliss/boot-bliss.sh'],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            cwd='/home/bliss',
            preexec_fn=os.setsid  # Create new process group
        )

        boot_status['progress'] = 75
        boot_status['message'] = 'Android is booting...'

        # Give it a moment to start
        time.sleep(3)

        # Check if process is still running
        if current_boot_process.poll() is None:
            boot_status['status'] = 'running'
            boot_status['progress'] = 100
            boot_status['message'] = 'Android boot initiated! Access via VNC console at http://localhost:8000'
        else:
            boot_status['status'] = 'error'
            boot_status['progress'] = 0
            boot_status['message'] = 'Android boot process terminated unexpectedly'

    except Exception as e:
        boot_status['status'] = 'error'
        boot_status['progress'] = 0
        boot_status['message'] = f'Boot error: {str(e)}'

@app.route('/')
def index():
    """Serve the main Bliss OS index page"""
    return send_from_directory('/build', 'index.html')

@app.route('/boot', methods=['POST'])
def boot():
    """Trigger the Android boot process - allows multiple boots"""
    # Always allow boot requests - kill existing and start new
    if boot_status['status'] != 'booting':
        # Start boot in background thread
        boot_thread = threading.Thread(target=run_boot_process)
        boot_thread.daemon = True
        boot_thread.start()

        return jsonify({'status': 'starting', 'message': 'Boot process initiated (terminating existing instances first)'})
    else:
        return jsonify({'status': 'booting', 'message': 'Boot already in progress...'})

@app.route('/status')
def status():
    """Get current boot status"""
    # Check if current process is still running
    if current_boot_process and current_boot_process.poll() is not None:
        # Process has terminated, reset status
        boot_status['status'] = 'ready'
        boot_status['progress'] = 0
        boot_status['message'] = 'System ready to boot'

    return jsonify(boot_status)

@app.route('/shutdown', methods=['POST'])
def shutdown():
    """Shutdown current Android instance"""
    global boot_status

    try:
        kill_existing_android_processes()
        boot_status['status'] = 'ready'
        boot_status['progress'] = 0
        boot_status['message'] = 'Android instance terminated'
        return jsonify({'status': 'shutdown', 'message': 'Android instance terminated successfully'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': f'Shutdown error: {str(e)}'})

@app.route('/novnc')
def novnc():
    """Redirect to noVNC interface"""
    return send_from_directory('/noVNC', 'index.html')

@app.route('/bliss-index')
def bliss_index():
    """Serve the Bliss OS specific index page"""
    return send_from_directory('/noVNC', 'bliss-index.html')

if __name__ == '__main__':
    from werkzeug.serving import WSGIRequestHandler
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    app.run(host='0.0.0.0', port=int(os.environ.get('WEB_PORT', '8080')), debug=False, threaded=True)
