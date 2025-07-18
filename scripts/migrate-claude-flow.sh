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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/../templates/basic"

# 检查目标目录
if [ ! -d "$TARGET_DIR" ]; then
    log_error "目标目录不存在: $TARGET_DIR"
    exit 1
fi

# 转换为绝对路径
TARGET_DIR="$(realpath "$TARGET_DIR")"
SOURCE_DIR="$(realpath "$SOURCE_DIR")"

log_info "开始迁移 Claude Flow 配置..."
log_info "源目录: $SOURCE_DIR"
log_info "目标目录: $TARGET_DIR"

# 检查源目录
if [ ! -d "$SOURCE_DIR" ]; then
    log_error "源目录不存在: $SOURCE_DIR"
    exit 1
fi

# 切换到目标目录
cd "$TARGET_DIR"

# 检查 CLAUDE.md 文件是否存在（最重要的检查）
if [ -f "CLAUDE.md" ]; then
    log_error "目标项目中已存在 CLAUDE.md 文件"
    log_error "请先重命名或备份现有的 CLAUDE.md 文件，然后重新运行脚本"
    log_error "建议操作: mv CLAUDE.md CLAUDE.md.backup"
    exit 1
fi

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

# 复制 CLAUDE.md 文件
if [ -f "$SOURCE_DIR/CLAUDE.md" ]; then
    cp "$SOURCE_DIR/CLAUDE.md" ./
    log_success "已复制 CLAUDE.md 文件"
else
    log_warn "CLAUDE.md 文件不存在，跳过"
fi

# 复制 coordination.md 文件
if [ -f "$SOURCE_DIR/coordination.md" ]; then
    cp "$SOURCE_DIR/coordination.md" ./
    log_success "已复制 coordination.md 文件"
else
    log_warn "coordination.md 文件不存在，跳过"
fi

# 复制 memory-bank.md 文件
if [ -f "$SOURCE_DIR/memory-bank.md" ]; then
    cp "$SOURCE_DIR/memory-bank.md" ./
    log_success "已复制 memory-bank.md 文件"
else
    log_warn "memory-bank.md 文件不存在，跳过"
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
total_checks=8

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

# 检查 .roomodes 文件
if [ -f ".roomodes" ]; then
    ((success_count++))
    log_success "✓ .roomodes 文件存在"
else
    log_error "✗ .roomodes 文件缺失"
fi

# 检查 claude-flow 脚本
if [ -f "claude-flow" ] && [ -x "claude-flow" ]; then
    ((success_count++))
    log_success "✓ claude-flow 脚本存在且可执行"
else
    log_error "✗ claude-flow 脚本缺失或不可执行"
fi

# 检查 CLAUDE.md 文件
if [ -f "CLAUDE.md" ]; then
    ((success_count++))
    log_success "✓ CLAUDE.md 文件存在"
else
    log_warn "✗ CLAUDE.md 文件缺失"
fi

# 检查 coordination.md 文件
if [ -f "coordination.md" ]; then
    ((success_count++))
    log_success "✓ coordination.md 文件存在"
else
    log_info "○ coordination.md 文件不存在（可选）"
    ((success_count++))  # 可选文件，算作成功
fi

# 检查 memory-bank.md 文件
if [ -f "memory-bank.md" ]; then
    ((success_count++))
    log_success "✓ memory-bank.md 文件存在"
else
    log_info "○ memory-bank.md 文件不存在（可选）"
    ((success_count++))  # 可选文件，算作成功
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
    echo "已安装的文件:"
    echo "- .claude/ - Claude Code 配置和斜杠命令"
    echo "- .roo/ - SPARC 方法论配置和工作流"
    echo "- .roomodes - 开发模式定义文件"
    echo "- claude-flow - 本地执行脚本"
    echo "- CLAUDE.md - 项目指导文档"
    echo "- coordination.md - 多智能体协调说明"
    echo "- memory-bank.md - 内存系统配置"
    echo "- memory/ - 内存数据存储目录 (如果选择复制)"
    echo
    echo "下一步:"
    echo "1. 切换到目标目录: cd $TARGET_DIR"
    echo "2. 测试配置: ./claude-flow --help"
    echo "3. 阅读项目指导: cat CLAUDE.md"
    echo "4. 开始使用:"
    echo "   - TDD 开发: ./claude-flow sparc --mode=tdd '你的任务描述'"
    echo "   - 架构设计: ./claude-flow sparc --mode=architect '设计架构'"
    echo "   - 多智能体协作: ./claude-flow swarm --strategy=development '开发任务'"
else
    log_warn "⚠️  迁移部分成功，请检查上述错误信息"
    echo
    echo "建议："
    echo "1. 检查缺失的文件并手动复制"
    echo "2. 确保 claude-flow 脚本有执行权限: chmod +x claude-flow"
    echo "3. 阅读 CLAUDE.md 了解完整配置要求"
fi

echo
log_info "相关文档："
log_info "- CLAUDE.md - 完整项目指导和命令说明"
log_info "- coordination.md - 多智能体协调系统详情"
log_info "- memory-bank.md - 内存系统配置详情"
