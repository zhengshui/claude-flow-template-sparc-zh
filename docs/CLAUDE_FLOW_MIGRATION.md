# Claude Flow 配置迁移指南

## 概述
本指南帮助你将 Claude Flow 配置迁移到其他项目。Claude Flow 使用 SPARC 方法论（Specification, Pseudocode, Architecture, Refinement, Completion）来管理开发工作流。

## 需要迁移的文件和目录

### 必需文件
```bash
# 核心配置目录
.claude/                    # Claude Flow 主配置目录
├── config.json            # 主配置文件
├── settings.local.json     # 本地设置
└── commands/               # 命令定义目录
    ├── sparc/             # SPARC 模式命令
    └── swarm/             # Swarm 策略命令

# SPARC 环境配置
.roo/                      # SPARC 开发环境
├── README.md              # 文档说明
└── workflows/             # 预定义工作流
    └── basic-tdd.json     # 基础 TDD 工作流

# 自定义模式
.roomodes                  # 自定义模式定义文件

# 执行脚本
claude-flow                # 本地包装器脚本

# 数据存储（可选）
memory/                    # Claude Flow 数据目录
├── claude-flow-data.json  # 主数据文件
├── agents/                # 代理存储
└── sessions/              # 会话存储
```

## 迁移步骤

### 1. 准备目标项目
```bash
# 进入目标项目目录
cd /path/to/target/project

# 确保项目已初始化（如果是新项目）
npm init -y  # 或其他包管理器
```

### 2. 复制配置文件
```bash
# 从源项目复制配置
cp -r /Users/shui/WebstormProjects/agent_hub/.claude ./
cp -r /Users/shui/WebstormProjects/agent_hub/.roo ./
cp /Users/shui/WebstormProjects/agent_hub/.roomodes ./
cp /Users/shui/WebstormProjects/agent_hub/claude-flow ./

# 设置执行权限
chmod +x ./claude-flow
```

### 3. 可选：复制数据目录
```bash
# 如果需要保留历史数据
cp -r /Users/shui/WebstormProjects/agent_hub/memory ./
```

### 4. 安装 Claude Flow（可选）
```bash
# 本地安装
npm install claude-flow

# 或全局安装
npm install -g claude-flow
```

### 5. 验证配置
```bash
# 测试 claude-flow 是否正常工作
./claude-flow --help

# 或使用 npx
npx claude-flow@latest --help
```

## 配置说明

### .claude/config.json
主配置文件定义了可用的模式和策略：
- **SPARC 模式**: orchestrator, coder, researcher, tdd, etc.
- **Swarm 策略**: research, development, analysis, testing, etc.

### .roomodes
定义自定义开发模式，包括：
- 架构师模式 (architect)
- 各种专业化角色定义

### claude-flow 脚本
本地包装器脚本，自动处理：
- 查找本地安装的 claude-flow
- 设置正确的工作目录
- 使用 npx 作为备选方案

## 项目特定配置

### 根据项目类型调整
不同类型的项目可能需要调整配置：

#### Web 项目
```bash
# 可能需要添加前端特定的工作流
# 在 .roo/workflows/ 中添加相应配置
```

#### API 项目
```bash
# 可能需要 API 设计和文档工作流
# 调整 .claude/config.json 中的模式
```

#### 库项目
```bash
# 可能需要专注于测试和文档
# 在 .roomodes 中定义库特定模式
```

## 使用示例

### 初始化新的 SPARC 工作流
```bash
./claude-flow sparc init --mode=tdd
```

### 使用特定模式
```bash
./claude-flow sparc --mode=architect "设计用户认证系统"
./claude-flow sparc --mode=coder "实现登录功能"
```

### 运行 Swarm 策略
```bash
./claude-flow swarm --strategy=development "开发新功能"
```

## 注意事项

1. **环境变量**: 确保目标项目有必要的环境变量设置
2. **依赖项**: 检查 package.json 是否包含必要的依赖
3. **工作目录**: claude-flow 脚本会自动设置正确的工作目录
4. **版本兼容**: 确保使用兼容的 claude-flow 版本

## 故障排除

### 常见问题
1. **权限问题**: 确保 claude-flow 脚本有执行权限
2. **路径问题**: 使用绝对路径或确保在项目根目录执行
3. **依赖缺失**: 运行 `npm install` 安装缺失的依赖

### 验证清单
- [ ] .claude 目录已复制
- [ ] .roo 目录已复制  
- [ ] .roomodes 文件已复制
- [ ] claude-flow 脚本已复制并有执行权限
- [ ] 可以成功运行 `./claude-flow --help`
- [ ] 配置文件中的路径正确

## 进一步定制

### 添加项目特定模式
编辑 `.roomodes` 文件添加新的自定义模式。

### 创建项目工作流
在 `.roo/workflows/` 目录下创建项目特定的工作流配置。

### 调整 SPARC 配置
修改 `.claude/config.json` 以启用/禁用特定模式。
