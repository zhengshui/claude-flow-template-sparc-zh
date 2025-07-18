# Claude Code - SPARC 开发环境

## 🚨 关键原则：所有操作必须并发执行

**绝对规则**：所有操作必须在单个消息中并发/并行执行：

### 🔴 强制并发模式：
1. **TodoWrite**: 始终在一次调用中批量处理所有待办事项（最少5-10个待办事项）
2. **Task 工具**: 始终在一条消息中生成所有智能体并提供完整指令
3. **文件操作**: 始终在一条消息中批量处理所有读取/写入/编辑操作
4. **Bash 命令**: 始终在一条消息中批量处理所有终端操作
5. **内存操作**: 始终在一条消息中批量处理所有内存存储/检索操作

### ⚡ 黄金法则："1条消息 = 所有相关操作"

**正确并发执行的示例：**
```javascript
// ✅ 正确：所有内容在一条消息中
[单条消息]:
  - TodoWrite { todos: [10+个待办事项，包含所有状态/优先级] }
  - Task("智能体1，包含完整指令和钩子")
  - Task("智能体2，包含完整指令和钩子")  
  - Task("智能体3，包含完整指令和钩子")
  - Read("file1.js")
  - Read("file2.js")
  - Write("output1.js", content)
  - Write("output2.js", content)
  - Bash("npm install")
  - Bash("npm test")
  - Bash("npm run build")
```

**错误的顺序执行示例：**
```javascript
// ❌ 错误：多条消息（永远不要这样做）
消息1: TodoWrite { todos: [单个待办事项] }
消息2: Task("智能体1")
消息3: Task("智能体2")
消息4: Read("file1.js")
消息5: Write("output1.js")
消息6: Bash("npm install")
// 这样做慢6倍且破坏协调机制！
```

### 🎯 并发执行检查清单：

发送任何消息前，请自问：
- ✅ 所有相关的 TodoWrite 操作是否已批量处理？
- ✅ 所有 Task 生成操作是否在一条消息中？
- ✅ 所有文件操作（读取/写入/编辑）是否已批量处理？
- ✅ 所有 bash 命令是否在一条消息中分组？
- ✅ 所有内存操作是否并发？

如果任何答案是"否"，您必须将操作合并到单条消息中！

## 项目概述
本项目使用 SPARC（规范、伪代码、架构、精炼、完成）方法论，通过 Claude-Flow 编排进行系统化测试驱动开发和 AI 辅助。

## SPARC 开发命令

### 核心 SPARC 命令
- `./claude-flow sparc modes`: 列出所有可用的 SPARC 开发模式
- `./claude-flow sparc run <mode> "<task>"`: 为特定任务执行指定的 SPARC 模式
- `./claude-flow sparc tdd "<feature>"`: 使用 SPARC 方法论运行完整的 TDD 工作流
- `./claude-flow sparc info <mode>`: 获取特定模式的详细信息

### 标准构建命令
- `npm run build`: 构建项目
- `npm run test`: 运行测试套件
- `npm run lint`: 运行代码检查和格式化检查
- `npm run typecheck`: 运行 TypeScript 类型检查

## SPARC 方法论工作流

### 1. 规范阶段 (Specification Phase)
```bash
# 创建详细规范和需求
./claude-flow sparc run spec-pseudocode "定义用户认证需求"
```
- 定义清晰的功能需求
- 记录边缘情况和约束条件
- 创建用户故事和验收标准
- 建立非功能性需求

### 2. 伪代码阶段 (Pseudocode Phase)
```bash
# 开发算法逻辑和数据流
./claude-flow sparc run spec-pseudocode "创建认证流程伪代码"
```
- 将复杂逻辑分解为步骤
- 定义数据结构和接口
- 规划错误处理和边缘情况
- 创建模块化、可测试的组件

### 3. 架构阶段 (Architecture Phase)
```bash
# 设计系统架构和组件结构
./claude-flow sparc run architect "设计认证服务架构"
```
- 创建系统图和组件关系
- 定义 API 契约和接口
- 规划数据库模式和数据流
- 建立安全性和可扩展性模式

### 4. 精炼阶段 (Refinement Phase) - TDD 实现
```bash
# 执行测试驱动开发周期
./claude-flow sparc tdd "实现用户认证系统"
```

**TDD 周期：**
1. **红灯 (Red)**: 首先编写失败测试
2. **绿灯 (Green)**: 实现最小代码使测试通过
3. **重构 (Refactor)**: 优化和清理代码
4. **重复 (Repeat)**: 继续直到功能完成

### 5. 完成阶段 (Completion Phase)
```bash
# 集成、文档和验证
./claude-flow sparc run integration "将认证与用户管理集成"
```
- 集成所有组件
- 进行端到端测试
- 创建全面文档
- 根据原始需求进行验证

## SPARC 模式参考

### 开发模式
- **`architect`**: 系统设计和架构规划
- **`code`**: 清洁、模块化代码实现
- **`tdd`**: 测试驱动开发和测试
- **`spec-pseudocode`**: 需求和算法规划
- **`integration`**: 系统集成和协调

### 质量保证模式
- **`debug`**: 故障排除和错误解决
- **`security-review`**: 安全分析和漏洞评估
- **`refinement-optimization-mode`**: 性能优化和重构

### 支持模式
- **`docs-writer`**: 文档创建和维护
- **`devops`**: 部署和基础设施管理
- **`mcp`**: 外部服务集成
- **`swarm`**: 复杂任务的多智能体协调

## Claude Code 斜杠命令

Claude Code 斜杠命令位于 `.claude/commands/` 目录中：

### 项目命令
- `/sparc`: 执行 SPARC 方法论工作流
- `/sparc-<mode>`: 运行特定 SPARC 模式（如 /sparc-architect）
- `/claude-flow-help`: 显示所有 Claude-Flow 命令
- `/claude-flow-memory`: 与内存系统交互
- `/claude-flow-swarm`: 协调多智能体群

### 使用斜杠命令
1. 在 Claude Code 中输入 `/` 查看可用命令
2. 选择命令或输入其名称
3. 命令具有上下文感知能力和项目特定性
4. 可以将自定义命令添加到 `.claude/commands/` 目录

## 代码风格和最佳实践

### SPARC 开发原则
- **模块化设计**: 保持文件在500行以下，拆分为逻辑组件
- **环境安全**: 永远不要硬编码机密或环境特定值
- **测试优先**: 始终在实现前编写测试（红-绿-重构）
- **清洁架构**: 分离关注点，使用依赖注入
- **文档**: 维护清晰、最新的文档

### 编码标准
- 使用 TypeScript 确保类型安全和更好的工具支持
- 遵循一致的命名约定（变量用 camelCase，类用 PascalCase）
- 实现适当的错误处理和日志记录
- 对异步操作使用 async/await
- 优先选择组合而非继承

### 内存和状态管理
- 使用 claude-flow 内存系统跨会话保持持久状态
- 使用命名空间键存储进度和发现
- 在开始新任务前查询以前的工作
- 导出/导入内存用于备份和分享

## SPARC 内存集成

### SPARC 开发的内存命令
```bash
# 存储项目规范
./claude-flow memory store spec_auth "用户认证需求和约束条件"

# 存储架构决策
./claude-flow memory store arch_decisions "数据库模式和API设计选择"

# 存储测试结果和覆盖率
./claude-flow memory store test_coverage "认证模块：95%覆盖率，所有测试通过"

# 查询以前的工作
./claude-flow memory query auth_implementation

# 导出项目内存
./claude-flow memory export project_backup.json
```

### 内存命名空间
- **`spec`**: 需求和规范
- **`arch`**: 架构和设计决策
- **`impl`**: 实现说明和代码模式
- **`test`**: 测试结果和覆盖率报告
- **`debug`**: 错误报告和解决说明

## 工作流示例

### 功能开发工作流
```bash
# 1. 从规范开始
./claude-flow sparc run spec-pseudocode "用户档案管理功能"

# 2. 设计架构
./claude-flow sparc run architect "带数据验证的档案服务架构"

# 3. 使用 TDD 实现
./claude-flow sparc tdd "用户档案 CRUD 操作"

# 4. 安全审查
./claude-flow sparc run security-review "档案数据访问和验证"

# 5. 集成测试
./claude-flow sparc run integration "档案服务与认证系统"

# 6. 文档
./claude-flow sparc run docs-writer "档案服务 API 文档"
```

### 错误修复工作流
```bash
# 1. 调试和分析
./claude-flow sparc run debug "认证令牌过期问题"

# 2. 编写回归测试
./claude-flow sparc run tdd "令牌刷新机制测试"

# 3. 实现修复
./claude-flow sparc run code "修复认证服务中的令牌刷新"

# 4. 安全审查
./claude-flow sparc run security-review "令牌处理安全影响"
```

## 配置文件

### Claude Code 集成
- **`.claude/commands/`**: 所有 SPARC 模式的 Claude Code 斜杠命令
- **`.claude/logs/`**: 对话和会话日志

### SPARC 配置
- **`.roomodes`**: SPARC 模式定义和配置（自动生成）
- **`.roo/`**: SPARC 模板和工作流（自动生成）

### Claude-Flow 配置
- **`memory/`**: 持久内存和会话数据
- **`coordination/`**: 多智能体协调设置
- **`CLAUDE.md`**: Claude Code 的项目指令

## Git 工作流集成

### SPARC 提交策略
- **规范提交**: 完成需求分析后
- **架构提交**: 设计阶段完成后
- **TDD 提交**: 每个红-绿-重构周期后
- **集成提交**: 成功组件集成后
- **文档提交**: 完成文档更新后

### 分支策略
- **`feature/sparc-<feature-name>`**: 使用 SPARC 方法论的功能开发
- **`hotfix/sparc-<issue>`**: 使用 SPARC 调试工作流的错误修复
- **`refactor/sparc-<component>`**: 使用优化模式的重构

## 故障排除

### 常见 SPARC 问题
- **找不到模式**: 检查 `.roomodes` 文件是否存在且为有效 JSON
- **内存持久性**: 确保 `memory/` 目录具有写权限
- **工具访问**: 验证所选模式所需工具是否可用
- **命名空间冲突**: 为不同功能使用唯一的内存命名空间

### 调试命令
```bash
# 检查 SPARC 配置
./claude-flow sparc modes

# 验证内存系统
./claude-flow memory stats

# 检查系统状态
./claude-flow status

# 查看详细模式信息
./claude-flow sparc info <mode-name>
```

## 项目架构

这个启用 SPARC 的项目遵循系统性开发方法：
- **通过模块化设计明确分离关注点**
- **测试驱动开发**确保可靠性和可维护性
- **迭代精炼**持续改进
- **全面文档**促进团队协作
- **通过专业 SPARC 模式进行 AI 辅助开发**

## 重要说明

- 提交前始终运行测试（`npm run test`）
- 使用 SPARC 内存系统跨会话维护上下文
- 在 TDD 阶段遵循红-绿-重构周期
- 在内存中记录架构决策以供将来参考
- 对任何认证或数据处理代码进行定期安全审查
- Claude Code 斜杠命令提供快速访问 SPARC 模式

有关 SPARC 方法论的更多信息，请参阅：https://github.com/ruvnet/claude-code-flow/docs/sparc.md
