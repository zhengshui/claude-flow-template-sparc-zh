# SPARC 模式概览

SPARC (Specification, Planning, Architecture, Review, Code) 是一个包含 17 个专业化模式的综合开发方法论。

## 可用模式

### 核心编排模式
- **orchestrator**: 多智能体任务编排
- **swarm-coordinator**: 专业化群体管理
- **workflow-manager**: 流程自动化
- **batch-executor**: 并行任务执行

### 开发模式  
- **coder**: 自主代码生成
- **architect**: 系统设计
- **reviewer**: 代码审查
- **tdd**: 测试驱动开发

### 分析和研究模式
- **researcher**: 深度研究能力
- **analyzer**: 代码和数据分析
- **optimizer**: 性能优化

### 创意和支持模式
- **designer**: UI/UX 设计
- **innovator**: 创意问题解决
- **documenter**: 文档生成
- **debugger**: 系统化调试
- **tester**: 全面测试
- **memory-manager**: 知识管理

## 用法
```bash
# 运行特定模式
./claude-flow sparc run <mode> "任务描述"

# 列出所有模式
./claude-flow sparc modes

# 获取模式帮助
./claude-flow sparc help <mode>
```
