# Memory Bank Configuration

## 概述
Claude-Flow 内存系统提供跨智能体会话的持久存储和智能信息检索。它采用混合方法，结合 SQL 数据库和语义搜索功能。

## 存储后端
- **主要存储**: JSON 数据库（`./memory/claude-flow-data.json`）
- **会话存储**: 基于文件的存储（`./memory/sessions/`）
- **缓存**: 频繁访问数据的内存缓存

## 内存组织
- **Namespaces**: 相关信息的逻辑分组
- **Sessions**: 有时间界限的对话上下文
- **Indexing**: 自动内容索引，快速检索
- **Replication**: 可选的分布式存储支持

## 命令
- `npx claude-flow memory query <search>`: 搜索存储的信息
- `npx claude-flow memory stats`: 显示内存使用统计
- `npx claude-flow memory export <file>`: 将内存导出到文件
- `npx claude-flow memory import <file>`: 从文件导入内存

## 配置
内存设置在 `claude-flow.config.json` 中配置：
```json
{
  "memory": {
    "backend": "json",
    "path": "./memory/claude-flow-data.json",
    "cacheSize": 1000,
    "indexing": true,
    "namespaces": ["default", "agents", "tasks", "sessions"],
    "retentionPolicy": {
      "sessions": "30d",
      "tasks": "90d",
      "agents": "permanent"
    }
  }
}
```

## 最佳实践
- 为不同数据类型使用描述性命名空间
- 定期导出内存以备份
- 使用 stats 命令监控内存使用情况
- 定期清理旧会话

## 内存类型
- **情景记忆 (Episodic)**: 对话和交互历史
- **语义记忆 (Semantic)**: 事实知识和关系
- **过程记忆 (Procedural)**: 任务模式和工作流
- **元记忆 (Meta)**: 系统配置和偏好

## 集成说明
- 内存在智能体间自动同步
- 搜索支持精确匹配和语义相似性
- 内存内容仅限于您的本地实例
- 除非明确命令，否则不会将数据发送到外部服务
