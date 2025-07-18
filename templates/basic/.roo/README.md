# .roo 目录 - SPARC 开发环境

此目录包含 SPARC (Specification, Pseudocode, Architecture, Refinement, Completion) 开发环境配置和模板。

## 目录结构

```
.roo/
├── README.md           # 此文件
├── templates/          # 通用模式模板文件
├── workflows/          # 预定义 SPARC 工作流
│   └── basic-tdd.json  # 基础 TDD 工作流
├── modes/              # 自定义模式定义（可选）
└── configs/            # 配置文件
```

## SPARC 方法论

SPARC 是一种系统化的软件开发方法：

1. **Specification（规范）**: 定义清晰的需求和约束
2. **Pseudocode（伪代码）**: 创建详细的逻辑流程和算法
3. **Architecture（架构）**: 设计系统结构和组件
4. **Refinement（精炼）**: 使用 TDD 实现、测试和优化
5. **Completion（完成）**: 集成、文档化和验证

## 与 Claude-Flow 的使用

使用 claude-flow SPARC 命令来利用此环境：

```bash
# 列出可用模式
claude-flow sparc modes

# 运行特定模式
claude-flow sparc run code "implement user authentication"

# 执行完整 TDD 工作流
claude-flow sparc tdd "payment processing system"

# 使用自定义工作流
claude-flow sparc workflow .roo/workflows/basic-tdd.json
```

## 配置

主要配置位于项目根目录的 `.roomodes` 文件中。此目录提供额外的模板和工作流来支持 SPARC 开发过程。

## 自定义

您可以通过以下方式自定义此环境：
- 在 `workflows/` 中添加新的工作流模板
- 在 `templates/` 中创建模式特定的模板
- 在 `configs/` 中添加项目特定的配置

更多信息请参考：https://github.com/ruvnet/claude-code-flow/docs/sparc.md