# Claude Flow 模板仓库 (中文版)

[English](./README.en.md) | 中文

一个用于快速启动 Claude Flow SPARC 工作流的中文模板仓库。基于 [ruvnet/claude-flow](https://github.com/ruvnet/claude-flow) 项目，提供完整的中文化配置和文档。

## 🚀 快速开始

### 方法 1: 使用模板（推荐）
1. 点击右上角的 "Use this template" 按钮
2. 创建你的新仓库
3. 克隆到本地开始使用

### 方法 2: 直接复制
```bash
# 克隆模板仓库
git clone https://github.com/yourusername/claude-flow-template-zh.git
cd claude-flow-template-zh

# 复制基础模板到你的项目
./scripts/apply-template.sh /path/to/your/project
```

### 方法 3: 手动安装
```bash
# 复制到你的项目目录
cp -r templates/basic/.claude /path/to/your/project/
cp -r templates/basic/.roo /path/to/your/project/
cp templates/basic/.roomodes /path/to/your/project/
cp templates/basic/claude-flow /path/to/your/project/
chmod +x /path/to/your/project/claude-flow
```

## 📁 仓库结构

```
claude-flow-template-zh/
├── README.md                    # 本文档
├── README.en.md                 # 英文说明
├── docs/                        # 中文文档
│   ├── sparc-methodology.md     # SPARC 方法论说明
│   ├── usage-examples.md        # 使用示例
│   └── customization.md         # 定制指南
├── templates/                   # 模板文件
│   ├── basic/                  # 基础模板（推荐）
│   │   ├── .claude/           # Claude Flow 配置
│   │   ├── .roo/              # SPARC 环境
│   │   ├── .roomodes          # 自定义模式
│   │   └── claude-flow        # 执行脚本
│   ├── advanced/              # 高级模板
│   └── versions/              # 历史版本
│       ├── v1.0/             # 对应 claude-flow v1.0
│       └── v1.1/             # 对应 claude-flow v1.1
├── scripts/                    # 工具脚本
│   ├── apply-template.sh      # 应用模板脚本
│   ├── sync-upstream.sh       # 同步上游脚本
│   └── migrate-project.sh     # 项目迁移脚本
└── examples/                   # 使用示例
    ├── web-project/           # Web 项目示例
    ├── api-project/           # API 项目示例
    └── library-project/       # 库项目示例
```

## 🎯 主要特性

### ✨ 完整的 SPARC 工作流
- **S**pecification - 规格定义
- **P**seudocode - 伪代码设计  
- **A**rchitecture - 架构设计
- **R**efinement - 精细化实现
- **C**ompletion - 完成和优化

### 🔧 预配置模式
- **开发模式**: TDD、架构师、编码者、审查者
- **团队协作**: Swarm 策略、工作流管理
- **专业角色**: 测试者、优化者、文档工程师

### 🌏 中文化支持
- 所有配置文件中文注释
- 详细的中文使用文档
- 本土化的开发实践

## 📖 使用文档

### 基础用法
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
```

## 🔄 版本同步

### 自动同步上游更新
```bash
# 检查是否有新版本
./scripts/sync-upstream.sh --version

# 同步最新版本
./scripts/sync-upstream.sh
```

### 版本管理策略
- `templates/basic/` - 始终包含最新版本
- `templates/versions/` - 保存历史版本以便回滚
- 自动备份现有配置避免数据丢失

## 🛠️ 定制指南

### 添加项目特定模式
```bash
# 编辑自定义模式文件
vim templates/basic/.roomodes
```

### 创建工作流模板
```bash
# 在 .roo/workflows/ 目录下添加配置
vim templates/basic/.roo/workflows/my-workflow.json
```

### 项目类型适配
- **Web 项目**: 前端组件开发工作流
- **API 项目**: 接口设计和文档工作流  
- **库项目**: 测试和文档优先工作流

## 📚 相关资源

- [Claude Flow 官方仓库](https://github.com/ruvnet/claude-flow)
- [SPARC 方法论详解](./docs/sparc-methodology.md)
- [使用示例集合](./docs/usage-examples.md)
- [问题排查指南](./docs/troubleshooting.md)

## 🤝 贡献指南

### 贡献类型
- 🐛 问题修复
- 📚 文档改进
- ✨ 新功能模板
- 🌍 本地化改进

### 提交流程
1. Fork 本仓库
2. 创建特性分支: `git checkout -b feature/amazing-feature`
3. 提交更改: `git commit -m 'Add amazing feature'`
4. 推送分支: `git push origin feature/amazing-feature`
5. 提交 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [ruvnet/claude-flow](https://github.com/ruvnet/claude-flow) - 原始项目
- Claude AI - 工作流程支持
- 开源社区的贡献者们

---

**注意**: 本仓库独立维护，不是官方 claude-flow 项目的分支。我们会定期同步上游更新，但可能存在延迟。

## 📞 联系方式

- 问题反馈: [GitHub Issues](https://github.com/yourusername/claude-flow-template-zh/issues)
- 功能建议: [GitHub Discussions](https://github.com/yourusername/claude-flow-template-zh/discussions)

让我们一起构建更好的中文开发工具生态！🚀
