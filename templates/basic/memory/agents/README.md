# Agent 内存存储

## 目的
此目录存储 Agent 特定的内存数据、配置和持久状态信息，用于编排系统中的各个 Claude Agent。

## 结构
每个 Agent 都有自己的子目录用于隔离内存存储：

```
memory/agents/
├── agent_001/
│   ├── state.json           # Agent 状态和配置
│   ├── knowledge.md         # Agent 专用知识库
│   ├── tasks.json          # 已完成和活动任务
│   └── calibration.json    # Agent 专用校准
├── agent_002/
│   └── ...
└── shared/
    ├── common_knowledge.md  # Agent 间共享知识
    └── global_config.json  # 全局 Agent 配置
```

## 使用指南
1. **Agent 隔离**: 每个 Agent 只能读写自己的目录
2. **共享资源**: 使用 `shared/` 目录存储跨 Agent 信息
3. **状态持久化**: 当 Agent 状态改变时更新 state.json
4. **知识共享**: 在 knowledge.md 文件中记录发现
5. **清理**: 定期删除已终止 Agent 的目录

## 最后更新
2025-07-18T06:48:18.265Z