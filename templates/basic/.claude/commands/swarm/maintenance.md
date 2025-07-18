# Maintenance Swarm 策略

## 目的
通过协调智能体进行系统维护和更新。

## 激活方式
`./claude-flow swarm "update dependencies" --strategy maintenance`

## 智能体角色
- Dependency Analyzer: 检查更新
- Security Scanner: 识别漏洞
- Test Runner: 验证变更
- Documentation Updater: 维护文档

## 安全特性
- 自动备份
- 回滚能力
- 增量更新
