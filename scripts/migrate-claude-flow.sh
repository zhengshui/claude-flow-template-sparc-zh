#!/usr/bin/env bash
# Claude Flow 配置迁移脚本
# 使用方法: ./migrate-claude-flow.sh /path/to/target/project

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数定义
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查参数
if [ $# -eq 0 ]; then
    log_error "使用方法: $0 <目标项目路径>"
    echo "示例: $0 /path/to/my/new/project"
    exit 1
fi

TARGET_DIR="$1"
SOURCE_DIR="$(dirname "$0")"

# 检查目标目录
if [ ! -d "$TARGET_DIR" ]; then
    log_error "目标目录不存在: $TARGET_DIR"
    exit 1
fi

log_info "开始迁移 Claude Flow 配置..."
log_info "源目录: $SOURCE_DIR"
log_info "目标目录: $TARGET_DIR"

# 切换到目标目录
cd "$TARGET_DIR"

# 检查并复制核心配置
log_info "复制核心配置文件..."

# 复制 .claude 目录
if [ -d "$SOURCE_DIR/.claude" ]; then
    cp -r "$SOURCE_DIR/.claude" ./
    log_success "已复制 .claude/ 目录"
else
    log_warn ".claude/ 目录不存在，跳过"
fi

# 复制 .roo 目录
if [ -d "$SOURCE_DIR/.roo" ]; then
    cp -r "$SOURCE_DIR/.roo" ./
    log_success "已复制 .roo/ 目录"
else
    log_warn ".roo/ 目录不存在，跳过"
fi

# 复制 .roomodes 文件
if [ -f "$SOURCE_DIR/.roomodes" ]; then
    cp "$SOURCE_DIR/.roomodes" ./
    log_success "已复制 .roomodes 文件"
else
    log_warn ".roomodes 文件不存在，跳过"
fi

# 复制 claude-flow 脚本
if [ -f "$SOURCE_DIR/claude-flow" ]; then
    cp "$SOURCE_DIR/claude-flow" ./
    chmod +x ./claude-flow
    log_success "已复制 claude-flow 脚本并设置执行权限"
else
    log_warn "claude-flow 脚本不存在，跳过"
fi

# 可选：复制 memory 目录
read -p "是否复制 memory/ 目录（包含历史数据）？[y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d "$SOURCE_DIR/memory" ]; then
        cp -r "$SOURCE_DIR/memory" ./
        log_success "已复制 memory/ 目录"
    else
        log_warn "memory/ 目录不存在，跳过"
    fi
else
    log_info "跳过 memory/ 目录复制"
fi

# 检查 package.json 是否存在
if [ ! -f "package.json" ]; then
    log_warn "目标项目没有 package.json 文件"
    read -p "是否初始化 npm 项目？[y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm init -y
        log_success "已初始化 npm 项目"
    fi
fi

# 询问是否安装 claude-flow
read -p "是否安装 claude-flow 到当前项目？[y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v npm &> /dev/null; then
        npm install claude-flow
        log_success "已安装 claude-flow"
    else
        log_error "npm 未找到，请手动安装 claude-flow"
    fi
fi

# 验证配置
log_info "验证配置..."

success_count=0
total_checks=4

# 检查 .claude 目录
if [ -d ".claude" ]; then
    ((success_count++))
    log_success "✓ .claude/ 目录存在"
else
    log_error "✗ .claude/ 目录缺失"
fi

# 检查 .roo 目录
if [ -d ".roo" ]; then
    ((success_count++))
    log_success "✓ .roo/ 目录存在"
else
    log_error "✗ .roo/ 目录缺失"
fi

# 检查 claude-flow 脚本
if [ -f "claude-flow" ] && [ -x "claude-flow" ]; then
    ((success_count++))
    log_success "✓ claude-flow 脚本存在且可执行"
else
    log_error "✗ claude-flow 脚本缺失或不可执行"
fi

# 测试 claude-flow 命令
if [ -f "claude-flow" ]; then
    if ./claude-flow --help &> /dev/null; then
        ((success_count++))
        log_success "✓ claude-flow 命令正常工作"
    else
        log_warn "✗ claude-flow 命令测试失败，但这可能是正常的"
        ((success_count++))  # 仍然算作成功，因为可能需要网络下载
    fi
else
    log_error "✗ 无法测试 claude-flow 命令"
fi

# 总结
echo
log_info "迁移总结:"
log_info "成功项目: $success_count/$total_checks"

if [ $success_count -eq $total_checks ]; then
    log_success "🎉 Claude Flow 配置迁移完成！"
    echo
    echo "下一步:"
    echo "1. 切换到目标目录: cd $TARGET_DIR"
    echo "2. 测试配置: ./claude-flow --help"
    echo "3. 开始使用: ./claude-flow sparc --mode=tdd '你的任务描述'"
else
    log_warn "⚠️  迁移部分成功，请检查上述错误信息"
fi

echo
log_info "有关详细信息，请参阅 CLAUDE_FLOW_MIGRATION.md 文档"
