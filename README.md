# 🧹 Clean Tool 系统垃圾清理工具

<img width="350" height="200" alt="image" src="https://github.com/user-attachments/assets/a21dcbad-7384-442f-8744-4eb49869aabe" />

一款适用于 **Debian 13 / Qualcomm 410 / ARM 设备** 的轻量级系统清理脚本工具，支持菜单模式与 `clean` 命令快速启动。

---

## 📌 项目简介

Clean Tool 是一个用于 Linux 系统的自动化垃圾清理工具，主要用于释放磁盘空间、清理系统垃圾、优化系统状态。

支持：

- APT 缓存清理
- 系统日志清理
- 用户缓存清理
- 大文件扫描
- 深度清理模式
- 一键卸载
- clean 快捷命令启动

---

## ⚙️ 支持环境

- Debian 10 / 11 / 12 / 13
- Ubuntu（兼容）
- ARM 架构设备（如 Qualcomm 410）
- x86_64 服务器

---

## 🚀 安装方式

### ▶️ 一键安装脚本

`curl -fsSL https://raw.githubusercontent.com/huang-junye/Clean-Tool/refs/heads/main/clean.sh -o /root/clean.sh
chmod +x /root/clean.sh
ln -sf /root/clean.sh /usr/local/bin/clean`

### ⚡ 使用方法  
启动工具：  
`clean`  或：  `bash /root/clean.sh`  

### 📋 功能菜单  
1. 扫描垃圾  
2. 安全清理（推荐）  
3. 深度清理  
4. 自定义清理  
5. 卸载工具  
0. 退出  

### 🧹 功能说明  
#### 🔍 1. 系统垃圾扫描  
查看系统占用情况：APT 缓存、系统日志、用户缓存、大文件（>100MB）  
### 🧼 2. 安全清理（推荐）  
安全执行以下操作：清理 apt 缓存、清理 /tmp 与 /var/tmp、清理系统日志、清理用户缓存、不影响系统运行  
#### ⚠ 3. 深度清理（双重确认）  
高级清理模式：删除残留安装包、清理日志文件、清理临时文件、可选删除旧内核（双重确认）  
#### 🛡 内核保护机制  
删除旧内核需要：第一步：输入 y；第二步：输入 DELETE；否则不会执行危险操作。  
#### 📂 4. 自定义清理  
用户手动输入目录进行清理：请输入要清理的目录：  
#### 🗑 5. 卸载工具  
执行后将删除：/root/clean.sh、/usr/local/bin/clean  

### 📦 卸载方式  
`clean` → 选择 5，或手动：`rm -f /root/clean.sh && rm -f /usr/local/bin/clean`  

### ⚠ 注意事项  
建议在系统空闲时运行；深度清理前确认是否需要旧内核；不建议在数据库/生产环境运行 /tmp 清理。 
