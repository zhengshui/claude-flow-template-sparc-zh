# Claude Flow 快速迁移指南

## 概述
这个项目已配置了完整的 Claude Flow 工作流，包括 SPARC 方法论和 Swarm 策略。

## 🚀 快速迁移到其他项目

### 方法 1: 使用自动迁移脚本（推荐）
```bash
# 在当前目录运行迁移脚本
./migrate-claude-flow.sh /path/to/your/new/project

# 脚本会自动复制所有必要的配置文件
```

### 方法 2: 手动迁移
```bash
# 复制核心配置
cp -r .claude /path/to/your/project/
cp -r .roo /path/to/your/project/
cp .roomodes /path/to/your/project/
cp claude-flow /path/to/your/project/

# 设置执行权限
chmod +x /path/to/your/project/claude-flow
```

## 📁 关键文件说明

### 必需文件
- **`.claude/`** - Claude Flow 核心配置目录
  - `config.json` - 主配置（SPARC 模式 + Swarm 策略）
  - `commands/` - 所有可用命令的定义
- **`.roo/`** - SPARC 开发环境配置
- **`.roomodes`** - 自定义开发模式定义
- **`claude-flow`** - 本地执行脚本

### 可选文件
- **`memory/`** - 历史数据和会话存储

## ⚡ 使用示例

### SPARC 模式
```bash
# TDD 模式开发
./claude-flow sparc --mode=tdd "实现用户登录功能"

# 架构设计
./claude-flow sparc --mode=architect "设计微服务架构"

# 代码实现
./claude-flow sparc --mode=coder "优化数据库查询性能"
```

### Swarm 策略
```bash
# 研究阶段
./claude-flow swarm --strategy=research "调研前端框架选型"

# 开发阶段
./claude-flow swarm --strategy=development "开发用户管理模块"

# 测试优化
./claude-flow swarm --strategy=testing "完善单元测试覆盖率"
```

## 🔧 配置定制

### 添加自定义模式
编辑 `.roomodes` 文件添加项目特定的开发模式。

### 创建工作流模板
在 `.roo/workflows/` 目录下创建你的工作流配置。

### 调整 SPARC 设置
修改 `.claude/config.json` 来启用/禁用特定功能。

## 📚 详细文档
- [完整迁移指南](./CLAUDE_FLOW_MIGRATION.md)
- [SPARC 方法论文档](./.roo/README.md)

## 🆘 故障排除

### 常见问题
1. **权限问题**: `chmod +x claude-flow`
2. **命令未找到**: 确保在项目根目录执行
3. **配置缺失**: 检查 `.claude/config.json` 是否存在

### 验证安装
```bash
# 测试 claude-flow 是否正常
./claude-flow --help

# 检查配置
./claude-flow config
```
