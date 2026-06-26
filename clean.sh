#!/bin/bash

# ==========================================
# Qualcomm 410 / Debian 13 垃圾清理工具 v1.1
# 路径：/root/clean.sh
# 命令：clean
# ==========================================

set -e

# ===== 必须 root =====
if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 运行：bash /root/clean.sh 或 clean"
  exit 1
fi

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
NC="\033[0m"

# =========================
# 垃圾扫描
# =========================
scan_junk() {
  echo -e "${YELLOW}扫描系统垃圾中...${NC}"

  echo ""
  echo "APT缓存："
  du -sh /var/cache/apt/archives 2>/dev/null || true

  echo ""
  echo "日志占用："
  du -sh /var/log/* 2>/dev/null | sort -h | tail -n 10 || true

  echo ""
  echo "用户缓存："
  du -sh /home/*/.cache 2>/dev/null || true

  echo ""
  echo "大文件（>100MB）："
  find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{print $9, $5}' | head -n 20

  echo ""
  echo "扫描完成"
}

# =========================
# 安全清理
# =========================
safe_clean() {
  echo -e "${YELLOW}安全清理中...${NC}"

  apt clean -y
  apt autoclean -y
  apt autoremove -y --purge

  journalctl --vacuum-time=7d

  find /tmp -mindepth 1 -delete 2>/dev/null || true
  find /var/tmp -mindepth 1 -delete 2>/dev/null || true

  find /var/log -type f -name "*.gz" -delete
  find /var/log -type f -name "*.1" -delete
  find /var/log -type f -exec truncate -s 0 {} \;

  for dir in /home/*; do
    [ -d "$dir/.cache" ] && rm -rf "$dir/.cache"/*
  done

  echo -e "${GREEN}安全清理完成${NC}"
}

# =========================
# 深度清理（双确认防误删）
# =========================
deep_clean() {
  echo -e "${RED}深度清理模式${NC}"

  apt clean -y
  apt autoremove -y --purge

  dpkg -l | awk '/^rc/ {print $2}' | xargs -r dpkg -P

  journalctl --vacuum-size=50M

  find /tmp -mindepth 1 -delete 2>/dev/null || true
  find /var/tmp -mindepth 1 -delete 2>/dev/null || true

  find /var/log -type f -exec truncate -s 0 {} \;

  # =========================
  # 内核清理（双确认防误删）
  # =========================
  echo ""
  echo "当前内核：$(uname -r)"
  echo "重要操作：清理旧内核可能影响系统回滚能力"

  read -p "第一步确认（输入 y 继续，输入 n 跳过）： " confirm1

  if [ "$confirm1" = "y" ]; then

    echo ""
    echo "二次确认：此操作将删除旧内核（不可恢复）"
    echo "请输入 DELETE 以确认执行，否则将跳过"

    read -p "输入确认： " confirm2

    if [ "$confirm2" = "DELETE" ]; then
      CURRENT_KERNEL=$(uname -r)
      dpkg -l | awk '/linux-image/ {print $2}' | grep -v "$CURRENT_KERNEL" | xargs -r apt purge -y
      echo -e "${GREEN}旧内核清理完成${NC}"
    else
      echo "二次确认失败，已跳过内核清理"
    fi

  else
    echo "已跳过内核清理"
  fi

  echo -e "${GREEN}深度清理完成${NC}"
}

# =========================
# 自定义清理
# =========================
custom_clean() {
  echo "请输入要清理的目录："
  read target

  if [ -d "$target" ]; then
    rm -rf "$target"/*
    echo -e "${GREEN}已清理 $target${NC}"
  else
    echo -e "${RED}目录不存在${NC}"
  fi
}

# =========================
# 一键卸载工具
# =========================
uninstall_tool() {
  echo -e "${YELLOW}您正准备卸载垃圾清理工具（/root/clean.sh）${NC}"
  echo "此操作将删除脚本本体 + clean 命令"

  read -p "确认卸载？输入 y 继续，输入 n 取消： " confirm

  if [ "$confirm" = "y" ]; then
    rm -f /root/clean.sh
    rm -f /usr/local/bin/clean
    echo -e "${GREEN}垃圾清理工具已完全卸载${NC}"
    exit 0
  else
    echo "已取消卸载"
  fi
}

# =========================
# 菜单
# =========================
menu() {
  while true; do
    echo ""
    echo "=================================="
    echo "Qualcomm 410 / Debian 13 垃圾清理工具 v1.1"
    echo "=================================="
    echo "1. 扫描垃圾"
    echo "2. 安全清理（推荐）"
    echo "3. 深度清理"
    echo "4. 自定义清理"
    echo "5. 卸载"
    echo "0. 退出"
    echo "=================================="

    read -p "请选择: " opt

    case $opt in
      1) scan_junk ;;
      2) safe_clean ;;
      3) deep_clean ;;
      4) custom_clean ;;
      5) uninstall_tool ;;
      0) exit 0 ;;
      *) echo "无效选项" ;;
    esac
  done
}

menu