#!/usr/bin/env bash
# Claude Flow 上游同步脚本
# 用于从原始仓库同步最新的 claude-flow 初始化产物

set -euo pipefail

# 配置
UPSTREAM_REPO="https://github.com/ruvnet/claude-flow"
TEMP_DIR="/tmp/claude-flow-sync-$$"
TARGET_VERSION_DIR="./templates/versions"
CURRENT_TEMPLATE_DIR="./templates/basic"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 清理函数
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        log_info "已清理临时目录"
    fi
}
trap cleanup EXIT

# 获取 claude-flow 版本
get_claude_flow_version() {
    if command -v claude-flow &> /dev/null; then
        claude-flow --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown"
    else
        npx claude-flow@latest --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "latest"
    fi
}

# 创建新的模板版本
create_template_version() {
    local version="$1"
    local source_dir="$2"
    local target_dir="$TARGET_VERSION_DIR/v$version"
    
    log_info "创建模板版本: v$version"
    
    # 创建版本目录
    mkdir -p "$target_dir"
    
    # 复制核心文件
    if [ -d "$source_dir/.claude" ]; then
        cp -r "$source_dir/.claude" "$target_dir/"
        log_success "已复制 .claude/ 目录"
    fi
    
    if [ -d "$source_dir/.roo" ]; then
        cp -r "$source_dir/.roo" "$target_dir/"
        log_success "已复制 .roo/ 目录"
    fi
    
    if [ -f "$source_dir/.roomodes" ]; then
        cp "$source_dir/.roomodes" "$target_dir/"
        log_success "已复制 .roomodes 文件"
    fi
    
    # 创建版本信息文件
    cat > "$target_dir/VERSION.md" << EOF
# Claude Flow Template v$version

## 生成信息
- **生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
- **Claude Flow 版本**: $version
- **上游仓库**: $UPSTREAM_REPO
- **同步方式**: 自动同步脚本

## 包含内容
- .claude/ - Claude Flow 核心配置
- .roo/ - SPARC 开发环境
- .roomodes - 自定义模式定义

## 使用方法
\`\`\`bash
# 复制到你的项目
cp -r .claude .roo .roomodes /path/to/your/project/
\`\`\`
EOF
    
    log_success "已创建版本 v$version"
}

# 检查文件是否为已汉化文档
is_chinese_doc() {
    local file="$1"
    if [[ "$file" == *.md ]]; then
        # 检查是否包含中文字符
        if grep -q "[\u4e00-\u9fa5]" "$file" 2>/dev/null; then
            return 0  # 是中文文档
        fi
    fi
    return 1  # 不是中文文档
}

# 更新当前模板
update_current_template() {
    local source_dir="$1"
    
    log_info "更新当前基础模板..."
    
    # 备份当前模板
    if [ -d "$CURRENT_TEMPLATE_DIR" ]; then
        cp -r "$CURRENT_TEMPLATE_DIR" "${CURRENT_TEMPLATE_DIR}.backup.$(date +%s)"
        log_info "已备份当前模板"
    fi
    
    # 创建新的基础模板目录
    mkdir -p "$CURRENT_TEMPLATE_DIR"
    
    # 复制配置文件（总是更新）
    [ -d "$source_dir/.claude" ] && cp -r "$source_dir/.claude" "$CURRENT_TEMPLATE_DIR/"
    [ -d "$source_dir/.roo" ] && cp -r "$source_dir/.roo" "$CURRENT_TEMPLATE_DIR/"
    [ -f "$source_dir/.roomodes" ] && cp "$source_dir/.roomodes" "$CURRENT_TEMPLATE_DIR/"
    
    # 复制可执行文件
    [ -f "$source_dir/claude-flow" ] && cp "$source_dir/claude-flow" "$CURRENT_TEMPLATE_DIR/"
    
    # 保护已汉化的文档，只复制新的或英文文档
    if [ -d "$source_dir" ]; then
        find "$source_dir" -name "*.md" -type f | while read -r src_file; do
            local rel_path="${src_file#$source_dir/}"
            local dst_file="$CURRENT_TEMPLATE_DIR/$rel_path"
            
            # 如果目标文件存在且是中文文档，跳过复制
            if [ -f "$dst_file" ] && is_chinese_doc "$dst_file"; then
                log_info "跳过已汉化文档: $rel_path"
                continue
            fi
            
            # 创建目标目录
            mkdir -p "$(dirname "$dst_file")"
            
            # 复制文件
            cp "$src_file" "$dst_file"
            log_info "已更新文档: $rel_path"
        done
    fi
    
    # 只在 README.md 不存在或不是中文版本时创建
    if [ ! -f "$CURRENT_TEMPLATE_DIR/README.md" ] || ! is_chinese_doc "$CURRENT_TEMPLATE_DIR/README.md"; then
        cat > "$CURRENT_TEMPLATE_DIR/README.md" << EOF
# Claude Flow 基础模板

这是最新版本的 Claude Flow 模板，包含了所有必要的配置文件。

## 快速使用

\`\`\`bash
# 复制到你的项目
cp -r .claude .roo .roomodes /path/to/your/project/
chmod +x /path/to/your/project/claude-flow
\`\`\`

## 更新时间
$(date '+%Y-%m-%d %H:%M:%S')
EOF
    fi
    
    log_success "已更新基础模板（保护了已汉化文档）"
}

# 主函数
main() {
    log_info "开始同步 Claude Flow 上游模板..."
    
    # 创建临时目录
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # 创建临时项目进行初始化
    log_info "创建临时项目..."
    mkdir test-project
    cd test-project
    npm init -y > /dev/null 2>&1
    
    # 运行 claude-flow init
    log_info "执行 claude-flow init --sparc..."
    if npx claude-flow@latest init --sparc > /dev/null 2>&1; then
        log_success "claude-flow 初始化完成"
    else
        log_error "claude-flow 初始化失败"
        exit 1
    fi
    
    # 获取版本信息
    local version
    version=$(get_claude_flow_version)
    log_info "检测到 claude-flow 版本: $version"
    
    # 回到原目录
    cd - > /dev/null
    
    # 检查是否已存在该版本
    local version_dir="$TARGET_VERSION_DIR/v$version"
    if [ -d "$version_dir" ]; then
        log_warn "版本 v$version 已存在，跳过版本创建"
    else
        create_template_version "$version" "$TEMP_DIR/test-project"
    fi
    
    # 更新当前模板
    update_current_template "$TEMP_DIR/test-project"
    
    # 生成更新日志
    echo "## $(date '+%Y-%m-%d %H:%M:%S') - v$version" >> SYNC_LOG.md
    echo "- 同步了 claude-flow v$version 的模板" >> SYNC_LOG.md
    echo "- 更新了基础模板" >> SYNC_LOG.md
    echo "" >> SYNC_LOG.md
    
    log_success "🎉 同步完成！"
    log_info "新版本模板位于: $version_dir"
    log_info "基础模板已更新: $CURRENT_TEMPLATE_DIR"
}

# 显示帮助
show_help() {
    cat << EOF
Claude Flow 上游同步脚本

用法: $0 [选项]

选项:
  -h, --help     显示此帮助信息
  -v, --version  仅检查版本不执行同步

示例:
  $0                 # 执行完整同步
  $0 --version      # 仅检查版本
EOF
}

# 解析参数
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        version=$(get_claude_flow_version)
        echo "当前 claude-flow 版本: $version"
        exit 0
        ;;
    "")
        main
        ;;
    *)
        log_error "未知选项: $1"
        show_help
        exit 1
        ;;
esac
