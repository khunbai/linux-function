# Linux Automation Functions

A collection of utility shell scripts designed to automate common Linux system administration tasks, including LUKS-encrypted drive management, Unison synchronization, and NFS mounting/testing.

## 🚀 Overview

This repository contains modular shell functions for streamlining:
- **Encrypted Storage**: Mounting and unmounting LUKS-encrypted USB volumes.
- **Data Synchronization**: Orchestrating Unison sync between encrypted volumes.
- **Network Storage**: Managing NFS mounts and benchmarking network file system performance.

## 📁 Project Structure

| File | Description | Functions |
| :--- | :--- | :--- |
| `mount-luks-usb.sh` | LUKS management for external USB drives. | `mnt-usb`, `umnt-usb` |
| `unison-sync.sh` | Volume synchronization wrapper. | `unison-sync` |
| `nfs-mount.sh` | NFS connection management. | `nfs-mount`, `nfs-umount` |
| `nfs-testspeed.sh` | Performance benchmarking for mounts. | `nfs-speedtest` |

---

## 🛠 Usage Instructions

### 1. LUKS USB Management
Designed for two specific 120GB ext4 volumes.
- **Mount**: `mnt-usb`
  - Prompts for passphrase once and applies it to both disks.
  - Automatically creates mount points at `/mnt/01-120GB-ext4` and `/mnt/02-120GB-ext4`.
- **Unmount**: `umnt-usb`
  - Safely unmounts and closes the LUKS containers.

### 2. Unison Synchronization
- **Sync**: `unison-sync`
  - Verifies that both LUKS volumes are mounted before initiating `unison luks-sync`.
  - Aborts with a helpful message if volumes are missing.

### 3. NFS Operations
- **Mount**: `nfs-mount` / `nfs-umount`
  - Configured for server `100.107.51.20` and export `/home/khunbai/6-mnt/acasis_ext4`.
  - Uses optimized options: `rw,async,rsize=1048576,wsize=1048576`.
- **Benchmark**: `nfs-speedtest <mountpoint> [size_mb]`
  - Performs direct-IO write and read tests using `dd`.
  - Example: `./nfs-testspeed.sh /mnt/acasis 500`

---

## 📋 Prerequisites

To use these functions, ensure the following tools are installed:
- `cryptsetup` (for LUKS)
- `unison` (for syncing)
- `nfs-common` (for NFS mounting)
- `util-linux` (for `mountpoint` and `readlink`)
- `sudo` privileges for system-level operations.

## 🔧 Installation

To make these functions available in your shell session, source the scripts in your `.bashrc` or `.zshrc`:

```bash
source ~/1-devs/linux-function/mount-luks-usb.sh
source ~/1-devs/linux-function/unison-sync.sh
source ~/1-devs/linux-function/nfs-mount.sh
```

---
*Created with ❤️ for streamlined Linux workflows.*
