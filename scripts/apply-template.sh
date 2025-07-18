#!/usr/bin/env bash
# 应用 Claude Flow 模板到目标项目的脚本

set -euo pipefail

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

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates/basic"

show_help() {
    cat << EOF
Claude Flow 模板应用脚本

用法: $0 [选项] <目标项目路径>

选项:
  -h, --help          显示此帮助信息
  -t, --template DIR  指定模板目录 (默认: templates/basic)
  -f, --force         强制覆盖已存在的文件
  --dry-run          仅显示将要执行的操作，不实际复制文件

示例:
  $0 /path/to/my/project                    # 应用基础模板
  $0 -t templates/advanced /path/to/project # 应用高级模板
  $0 --dry-run /path/to/project            # 预览操作
EOF
}

# 检查目标项目
check_target() {
    local target="$1"
    
    if [ ! -d "$target" ]; then
        log_error "目标目录不存在: $target"
        return 1
    fi
    
    if [ ! -w "$target" ]; then
        log_error "目标目录不可写: $target"
        return 1
    fi
    
    return 0
}

# 检查模板
check_template() {
    local template="$1"
    
    if [ ! -d "$template" ]; then
        log_error "模板目录不存在: $template"
        return 1
    fi
    
    # 检查必需文件
    local required_files=(".claude" ".roo" ".roomodes" "claude-flow" "CLAUDE.md")
    local optional_files=("coordination.md" "memory-bank.md" "memory")
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [ ! -e "$template/$file" ]; then
            log_warn "模板中缺少必需文件: $file"
            missing_files+=("$file")
        fi
    done
    
    for file in "${optional_files[@]}"; do
        if [ ! -e "$template/$file" ]; then
            log_info "模板中缺少可选文件: $file"
        fi
    done
    
    # 如果缺少关键文件，提醒用户
    if [ ${#missing_files[@]} -gt 0 ]; then
        log_warn "发现 ${#missing_files[@]} 个缺失的文件，但将继续执行"
    fi
    
    return 0
}

# 应用模板
apply_template() {
    local template_dir="$1"
    local target_dir="$2"
    local force="$3"
    local dry_run="$4"
    
    log_info "应用模板: $template_dir -> $target_dir"
    
    # 切换到目标目录
    cd "$target_dir"
    
    # 检查 CLAUDE.md 文件是否存在（最重要的检查）
    if [ -f "CLAUDE.md" ] && [ "$force" != "true" ]; then
        if [ "$dry_run" = "true" ]; then
            log_error "[DRY-RUN] 目标项目中已存在 CLAUDE.md 文件，需要先重命名或使用 --force"
            return 1
        else
            log_error "目标项目中已存在 CLAUDE.md 文件"
            log_error "请先重命名或备份现有的 CLAUDE.md 文件，然后重新运行脚本"
            log_error "建议操作: mv CLAUDE.md CLAUDE.md.backup"
            log_error "或者使用 --force 选项强制覆盖"
            return 1
        fi
    fi
    
    # 复制 .claude 目录
    if [ -d "$template_dir/.claude" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 .claude/ 目录"
        else
            if [ -d ".claude" ] && [ "$force" != "true" ]; then
                log_warn ".claude/ 目录已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp -r "$template_dir/.claude" ./; then
                    log_success "已复制 .claude/ 目录"
                else
                    log_error "复制 .claude/ 目录失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 .roo 目录
    if [ -d "$template_dir/.roo" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 .roo/ 目录"
        else
            if [ -d ".roo" ] && [ "$force" != "true" ]; then
                log_warn ".roo/ 目录已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp -r "$template_dir/.roo" ./; then
                    log_success "已复制 .roo/ 目录"
                else
                    log_error "复制 .roo/ 目录失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 .roomodes 文件
    if [ -f "$template_dir/.roomodes" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 .roomodes 文件"
        else
            if [ -f ".roomodes" ] && [ "$force" != "true" ]; then
                log_warn ".roomodes 文件已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp "$template_dir/.roomodes" ./; then
                    log_success "已复制 .roomodes 文件"
                else
                    log_error "复制 .roomodes 文件失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 claude-flow 脚本
    if [ -f "$template_dir/claude-flow" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 claude-flow 脚本"
        else
            if [ -f "claude-flow" ] && [ "$force" != "true" ]; then
                log_warn "claude-flow 脚本已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp "$template_dir/claude-flow" ./ && chmod +x ./claude-flow; then
                    log_success "已复制 claude-flow 脚本并设置执行权限"
                else
                    log_error "复制 claude-flow 脚本失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 CLAUDE.md 文件
    if [ -f "$template_dir/CLAUDE.md" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 CLAUDE.md 文件"
        else
            if [ -f "CLAUDE.md" ] && [ "$force" != "true" ]; then
                log_warn "CLAUDE.md 文件已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp "$template_dir/CLAUDE.md" ./; then
                    log_success "已复制 CLAUDE.md 文件"
                else
                    log_error "复制 CLAUDE.md 文件失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 coordination.md 文件
    if [ -f "$template_dir/coordination.md" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 coordination.md 文件"
        else
            if [ -f "coordination.md" ] && [ "$force" != "true" ]; then
                log_warn "coordination.md 文件已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp "$template_dir/coordination.md" ./; then
                    log_success "已复制 coordination.md 文件"
                else
                    log_error "复制 coordination.md 文件失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 memory-bank.md 文件
    if [ -f "$template_dir/memory-bank.md" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 memory-bank.md 文件"
        else
            if [ -f "memory-bank.md" ] && [ "$force" != "true" ]; then
                log_warn "memory-bank.md 文件已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp "$template_dir/memory-bank.md" ./; then
                    log_success "已复制 memory-bank.md 文件"
                else
                    log_error "复制 memory-bank.md 文件失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 复制 memory 目录
    if [ -d "$template_dir/memory" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将复制 memory/ 目录"
        else
            if [ -d "memory" ] && [ "$force" != "true" ]; then
                log_warn "memory/ 目录已存在，跳过复制 (使用 --force 覆盖)"
            else
                if cp -r "$template_dir/memory" ./; then
                    log_success "已复制 memory/ 目录"
                else
                    log_error "复制 memory/ 目录失败"
                    return 1
                fi
            fi
        fi
    fi
    
    # 检查 package.json
    if [ ! -f "package.json" ]; then
        if [ "$dry_run" = "true" ]; then
            log_info "[DRY-RUN] 将询问是否初始化 npm 项目"
        else
            log_warn "项目没有 package.json 文件"
            read -p "是否初始化 npm 项目？[y/N]: " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                npm init -y
                log_success "已初始化 npm 项目"
            fi
        fi
    fi
    
    if [ "$dry_run" != "true" ]; then
        # 创建使用说明
        cat > "CLAUDE_FLOW_SETUP.md" << 'EOF'
# Claude Flow 设置完成

## 已安装的文件
- `.claude/` - Claude Code 配置和斜杠命令
- `.roo/` - SPARC 方法论配置和工作流
- `.roomodes` - 开发模式定义文件
- `claude-flow` - 本地执行脚本
- `CLAUDE.md` - 项目指导文档 (如果存在)
- `coordination.md` - 多智能体协调说明 (如果存在)
- `memory-bank.md` - 内存系统配置 (如果存在)
- `memory/` - 内存数据存储目录 (如果存在)

## 验证安装
```bash
# 测试 claude-flow 是否正常工作
./claude-flow --help

# 检查配置文件
ls -la .claude .roo .roomodes
```

## 快速开始

### SPARC 方法论
```bash
# TDD 模式开发
./claude-flow sparc --mode=tdd "你的任务描述"

# 架构设计
./claude-flow sparc --mode=architect "设计系统架构"

# 代码实现
./claude-flow sparc --mode=coder "实现具体功能"

# 规范定义
./claude-flow sparc --mode=spec-pseudocode "定义功能需求"
```

### Swarm 多智能体协作
```bash
# 研究阶段
./claude-flow swarm --strategy=research "技术调研"

# 开发阶段
./claude-flow swarm --strategy=development "功能开发"

# 测试阶段
./claude-flow swarm --strategy=testing "测试优化"
```

### 内存管理
```bash
# 查询存储信息
./claude-flow memory query "搜索内容"

# 查看内存统计
./claude-flow memory stats

# 导出内存数据
./claude-flow memory export backup.json
```

## 下一步
1. 阅读 `CLAUDE.md` 了解项目架构和命令
2. 查看 `.roo/README.md` 了解 SPARC 方法论
3. 检查 `.roomodes` 文件了解可用的开发模式
4. 根据项目需要定制配置文件

## 问题排查
如果遇到问题，请检查：
- `claude-flow` 脚本是否有执行权限: `chmod +x claude-flow`
- 是否在项目根目录执行命令
- 网络连接是否正常（首次运行需要下载）
- 配置文件是否完整：`.claude/config.json`、`.roomodes`

## 相关文档
- `CLAUDE.md` - 完整的项目指导和架构说明
- `coordination.md` - 多智能体协调系统说明
- `memory-bank.md` - 内存系统配置详情
- `.roo/README.md` - SPARC 方法论详细说明
EOF
        log_success "已创建设置说明文件: CLAUDE_FLOW_SETUP.md"
    fi
}

# 主函数
main() {
    local template_dir="$TEMPLATE_DIR"
    local target_dir=""
    local force="false"
    local dry_run="false"
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--template)
                template_dir="$2"
                shift 2
                ;;
            -f|--force)
                force="true"
                shift
                ;;
            --dry-run)
                dry_run="true"
                shift
                ;;
            -*)
                log_error "未知选项: $1"
                show_help
                exit 1
                ;;
            *)
                if [ -z "$target_dir" ]; then
                    target_dir="$1"
                else
                    log_error "多个目标目录参数"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # 检查必需参数
    if [ -z "$target_dir" ]; then
        log_error "请指定目标项目路径"
        show_help
        exit 1
    fi
    
    # 转换为绝对路径
    target_dir="$(realpath "$target_dir")"
    
    # 如果模板路径是相对路径，转换为相对于脚本的路径
    if [[ "$template_dir" != /* ]]; then
        template_dir="$SCRIPT_DIR/../$template_dir"
    fi
    template_dir="$(realpath "$template_dir")"
    
    # 验证
    check_template "$template_dir" || exit 1
    check_target "$target_dir" || exit 1
    
    # 应用模板
    apply_template "$template_dir" "$target_dir" "$force" "$dry_run"
    
    if [ "$dry_run" = "true" ]; then
        log_info "这是预览模式，没有实际修改文件"
        log_info "要执行实际操作，请运行: $0 $target_dir"
    else
        log_success "🎉 Claude Flow 模板应用完成！"
        log_info "目标项目: $target_dir"
        log_info "使用的模板: $template_dir"
        echo
        log_info "下一步:"
        log_info "1. cd $target_dir"
        log_info "2. ./claude-flow --help"
        log_info "3. 阅读 CLAUDE_FLOW_SETUP.md 开始使用"
    fi
}

# 运行主函数
main "$@"
