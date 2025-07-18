# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 Claude Flow 中文模板仓库，基于 SPARC 方法论提供完整的开发工作流模板。该项目旨在让开发者能够快速启动带有 Claude Flow 工作流的项目，支持 TDD、架构设计、多智能体协作等功能。

## 核心命令

### 模板应用命令
```bash
# 应用基础模板到目标项目
npm run apply                    # 使用 scripts/apply-template.sh
./scripts/apply-template.sh /path/to/target/project

# 迁移现有项目到 Claude Flow
npm run migrate                  # 使用 scripts/migrate-claude-flow.sh
./scripts/migrate-claude-flow.sh /path/to/target/project

# 同步上游更新
npm run sync                     # 使用 scripts/sync-upstream.sh
./scripts/sync-upstream.sh
```

### Claude Flow 工作流命令
```bash
# SPARC 方法论命令
./claude-flow sparc --mode=tdd "任务描述"           # TDD 模式开发
./claude-flow sparc --mode=architect "架构设计"    # 架构设计
./claude-flow sparc --mode=coder "代码实现"        # 代码实现
./claude-flow sparc --mode=spec-pseudocode "规范"  # 规范定义

# Swarm 多智能体协作
./claude-flow swarm --strategy=research "研究任务"     # 研究阶段
./claude-flow swarm --strategy=development "开发任务"  # 开发阶段
./claude-flow swarm --strategy=testing "测试任务"      # 测试阶段

# 内存管理
./claude-flow memory query "搜索内容"               # 搜索存储信息
./claude-flow memory stats                          # 显示内存统计
./claude-flow memory export backup.json             # 导出内存数据
./claude-flow memory import backup.json             # 导入内存数据
```

## 代码架构

### 目录结构
```
claude-flow-template-zh/
├── templates/basic/          # 基础模板（核心文件）
│   ├── .claude/             # Claude Code 配置
│   ├── .roo/               # SPARC 环境配置
│   ├── .roomodes           # 开发模式定义
│   ├── claude-flow         # 本地执行脚本
│   ├── CLAUDE.md           # 项目指导文档
│   ├── coordination.md     # 多智能体协调说明
│   ├── memory-bank.md      # 内存系统配置
│   └── memory/             # 内存数据存储
├── scripts/                 # 自动化脚本
│   ├── apply-template.sh   # 模板应用脚本
│   ├── migrate-claude-flow.sh # 迁移脚本
│   └── sync-upstream.sh    # 同步脚本
└── docs/                   # 项目文档
    ├── CLAUDE_FLOW_README.md
    └── CLAUDE_FLOW_MIGRATION.md
```

### 关键组件

#### 1. 模板系统
- **基础模板** (`templates/basic/`): 包含完整的 Claude Flow 配置
- **应用脚本** (`scripts/apply-template.sh`): 自动化模板应用过程
- **迁移脚本** (`scripts/migrate-claude-flow.sh`): 将现有项目迁移到 Claude Flow

#### 2. SPARC 工作流
- **S**pecification - 规格定义阶段
- **P**seudocode - 伪代码设计阶段  
- **A**rchitecture - 架构设计阶段
- **R**efinement - 精细化实现阶段（TDD）
- **C**ompletion - 完成和优化阶段

#### 3. 多智能体协调
- **智能体类型**: 研究员、编程员、分析师、协调员、通用型
- **任务管理**: 优先级分配、依赖关系处理、并行执行
- **通信机制**: 直接消息、事件广播、共享内存、任务移交

#### 4. 内存系统
- **存储后端**: JSON 数据库和基于文件的会话存储
- **内存组织**: 命名空间、会话、自动索引
- **内存类型**: 情景记忆、语义记忆、过程记忆、元记忆

## 开发工作流

### 1. 设置新项目
```bash
# 方法1: 使用GitHub模板
# 点击 "Use this template" 创建新仓库

# 方法2: 应用到现有项目
./scripts/apply-template.sh /path/to/your/project
cd /path/to/your/project
./claude-flow --help  # 验证安装
```

### 2. SPARC 开发流程
```bash
# 1. 规范定义
./claude-flow sparc --mode=spec-pseudocode "用户认证功能需求"

# 2. 架构设计
./claude-flow sparc --mode=architect "认证服务架构设计"

# 3. TDD 实现
./claude-flow sparc --mode=tdd "用户登录功能实现"

# 4. 集成测试
./claude-flow sparc --mode=integration "认证模块集成测试"
```

### 3. 多智能体协作
```bash
# 复杂任务分解
./claude-flow swarm --strategy=research "前端框架技术选型研究"
./claude-flow swarm --strategy=development "用户管理模块开发"
./claude-flow swarm --strategy=testing "端到端测试覆盖"
```

## 脚本说明

### apply-template.sh
- **功能**: 将基础模板应用到目标项目
- **参数**: 目标项目路径
- **选项**: `-f` 强制覆盖, `--dry-run` 预览模式, `-t` 指定模板目录

### migrate-claude-flow.sh  
- **功能**: 将现有项目迁移到 Claude Flow 工作流
- **特点**: 交互式选择, 配置验证, 自动权限设置

### sync-upstream.sh
- **功能**: 同步上游 claude-flow 项目更新
- **特点**: 版本检查, 自动备份, 冲突处理

## 配置文件

### .roomodes
定义可用的开发模式，包括:
- TDD 模式: 测试驱动开发流程
- 架构师模式: 系统设计和架构规划
- 编码者模式: 代码实现和优化
- 调试模式: 问题分析和解决

### .claude/config.json
Claude Code 集成配置，包含:
- SPARC 模式定义
- 斜杠命令配置
- 工作流编排设置

### memory/ 目录
- `claude-flow-data.json`: 主要数据存储
- `sessions/`: 会话历史记录
- `agents/`: 智能体配置和状态

## 最佳实践

### 项目初始化
1. 使用 `apply-template.sh` 而非手动复制文件
2. 验证 `claude-flow --help` 命令正常工作
3. 检查所有必需文件的权限设置

### SPARC 开发流程
1. 始终从规范定义开始
2. 使用 TDD 模式进行实际代码实现
3. 利用内存系统保存架构决策和进度
4. 定期进行安全审查和性能优化

### 多智能体协作
1. 为复杂任务使用研究智能体进行前期调研
2. 通过协调员智能体管理任务分发
3. 监控系统资源使用情况
4. 定期清理完成的任务和非活跃智能体

### 内存管理
1. 使用描述性命名空间组织数据
2. 定期导出内存数据进行备份
3. 监控内存使用统计
4. 根据保留策略清理过期数据

## 故障排除

### 常见问题
1. **权限错误**: 运行 `chmod +x claude-flow` 设置执行权限
2. **命令未找到**: 确保在项目根目录执行命令
3. **配置缺失**: 验证 `.claude/config.json` 和 `.roomodes` 文件存在
4. **内存访问失败**: 检查 `memory/` 目录权限

### 验证安装
```bash
# 测试基本功能
./claude-flow --help
./claude-flow sparc modes
./claude-flow memory stats

# 检查配置完整性
ls -la .claude .roo .roomodes
```

### 调试命令
```bash
# 系统状态检查
./claude-flow status --verbose

# 内存系统诊断
./claude-flow memory query --debug

# 智能体监控
./claude-flow monitor --interval 5000
```

## 版本管理

### 同步策略
- `templates/basic/` 始终包含最新稳定版本
- `templates/versions/` 保存历史版本以便回滚
- 使用 `sync-upstream.sh` 自动同步上游更新

### 更新流程
1. 运行 `./scripts/sync-upstream.sh --version` 检查更新
2. 备份现有配置
3. 执行同步操作
4. 验证更新后的配置完整性

## 扩展开发

### 添加自定义模式
1. 编辑 `.roomodes` 文件添加新模式定义
2. 在 `.roo/workflows/` 创建对应的工作流配置
3. 测试新模式的功能完整性

### 创建项目特定模板
1. 基于 `templates/basic/` 创建新模板目录
2. 修改 `apply-template.sh` 支持新模板
3. 更新文档说明新模板的用途和配置

这个项目通过系统化的 SPARC 方法论和智能化的多智能体协作，为 Claude Code 用户提供了一个强大的开发工作流模板系统。