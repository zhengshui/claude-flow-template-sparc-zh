# Claude Flow 问题排查指南

## 概述

本文档提供了使用 Claude Flow 过程中可能遇到的常见问题及其解决方案。内容涵盖安装、配置、运行时错误和性能问题等各个方面。

## 快速诊断

### 基础健康检查

```bash
# 检查 claude-flow 是否可执行
./claude-flow --help

# 验证 SPARC 模式配置
./claude-flow sparc modes

# 检查内存系统状态
./claude-flow memory stats

# 验证项目配置
ls -la .claude .roo .roomodes memory/
```

### 系统环境检查

```bash
# 检查 Node.js 版本（如果需要）
node --version

# 检查 Python 版本（如果需要）
python --version

# 检查文件权限
ls -la claude-flow
```

## 安装问题

### 问题 1: 权限拒绝错误

**错误信息**:
```
Permission denied: ./claude-flow
```

**解决方案**:
```bash
# 设置执行权限
chmod +x claude-flow

# 检查文件所有权
ls -la claude-flow

# 如果需要，更改所有权
sudo chown $USER:$USER claude-flow
```

### 问题 2: 模板应用失败

**错误信息**:
```
Error: Template directory not found
```

**解决方案**:
```bash
# 检查模板目录是否存在
ls -la templates/basic/

# 使用完整路径
./scripts/apply-template.sh -t $(pwd)/templates/basic /path/to/target

# 检查脚本权限
chmod +x scripts/apply-template.sh
```

### 问题 3: 依赖项缺失

**错误信息**:
```
Command not found: node/python/git
```

**解决方案**:
```bash
# 安装 Node.js (如果需要)
# macOS
brew install node

# Ubuntu/Debian
sudo apt-get install nodejs npm

# 安装 Python (如果需要)
# macOS
brew install python

# Ubuntu/Debian
sudo apt-get install python3 python3-pip

# 检查并安装 git
git --version || sudo apt-get install git
```

## 配置问题

### 问题 1: .roomodes 文件损坏

**错误信息**:
```
Error: Invalid JSON in .roomodes
```

**解决方案**:
```bash
# 验证 JSON 格式
cat .roomodes | python -m json.tool

# 从模板恢复
cp templates/basic/.roomodes .roomodes

# 手动检查语法
vim .roomodes
```

### 问题 2: Claude Code 集成失败

**错误信息**:
```
Error: .claude directory not found
```

**解决方案**:
```bash
# 检查 .claude 目录结构
ls -la .claude/

# 从模板恢复
cp -r templates/basic/.claude .

# 验证配置文件
cat .claude/config.json | python -m json.tool
```

### 问题 3: 内存目录权限错误

**错误信息**:
```
Error: Cannot write to memory directory
```

**解决方案**:
```bash
# 检查内存目录权限
ls -la memory/

# 设置正确权限
chmod 755 memory/
chmod 644 memory/*.json

# 创建缺失目录
mkdir -p memory/sessions memory/agents
```

## 运行时错误

### 问题 1: SPARC 模式未找到

**错误信息**:
```
Error: Mode 'tdd' not found
```

**解决方案**:
```bash
# 列出可用模式
./claude-flow sparc modes

# 检查模式定义
cat .roomodes | grep -A 10 -B 2 "tdd"

# 重新应用模板
./scripts/apply-template.sh -f .
```

### 问题 2: 内存查询失败

**错误信息**:
```
Error: Memory query failed
```

**解决方案**:
```bash
# 检查内存系统状态
./claude-flow memory stats

# 使用调试模式
./claude-flow memory query --debug "your_query"

# 重建内存索引
./claude-flow memory rebuild-index

# 清理损坏的内存文件
rm -f memory/claude-flow-data.json
./claude-flow memory stats  # 重新初始化
```

### 问题 3: 智能体协调失败

**错误信息**:
```
Error: Agent coordination timeout
```

**解决方案**:
```bash
# 检查系统资源
top
df -h

# 减少并发智能体数量
./claude-flow swarm --max-agents 3

# 增加超时时间
./claude-flow swarm --timeout 300000

# 检查网络连接
ping google.com
```

## 性能问题

### 问题 1: 响应时间过长

**症状**: 命令执行时间超过预期

**诊断步骤**:
```bash
# 监控系统资源
./claude-flow monitor --interval 5000

# 检查内存使用
./claude-flow memory stats --verbose

# 分析性能瓶颈
./claude-flow profile --mode tdd
```

**解决方案**:
```bash
# 清理内存缓存
./claude-flow memory cleanup --older-than "7d"

# 优化内存存储
./claude-flow memory optimize

# 使用更快的模式
./claude-flow sparc run code  # 而不是 tdd
```

### 问题 2: 内存使用过高

**症状**: 系统内存占用过高

**诊断步骤**:
```bash
# 检查内存文件大小
du -sh memory/

# 分析内存使用模式
./claude-flow memory analyze --usage
```

**解决方案**:
```bash
# 导出重要数据
./claude-flow memory export backup.json

# 清理旧数据
./claude-flow memory cleanup --keep-recent 100

# 压缩内存文件
./claude-flow memory compress
```

### 问题 3: 网络连接问题

**症状**: 智能体通信失败

**诊断步骤**:
```bash
# 检查网络连接
curl -I https://api.anthropic.com
ping -c 3 google.com

# 检查防火墙设置
sudo ufw status
```

**解决方案**:
```bash
# 配置代理（如果需要）
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080

# 调整超时设置
./claude-flow config set timeout 60000

# 使用本地模式
./claude-flow sparc run code --local
```

## 模式特定问题

### TDD 模式问题

**问题**: 测试框架未找到

**解决方案**:
```bash
# 检查项目是否有测试配置
ls package.json jest.config.js

# 安装测试依赖
npm install --save-dev jest
npm install --save-dev @testing-library/react

# 配置测试脚本
./claude-flow sparc run tdd --setup-tests
```

### 架构模式问题

**问题**: 无法生成架构图

**解决方案**:
```bash
# 安装图表生成工具
npm install --save-dev mermaid-cli

# 检查输出目录权限
mkdir -p docs/architecture
chmod 755 docs/architecture

# 使用替代格式
./claude-flow sparc run architect --format text
```

### 文档模式问题

**问题**: 无法生成文档

**解决方案**:
```bash
# 检查文档目录
mkdir -p docs
chmod 755 docs

# 安装文档生成工具
npm install --save-dev typedoc

# 检查 Markdown 处理器
which markdown || npm install -g markdown
```

## 集成问题

### Git 集成问题

**问题**: Git 提交失败

**解决方案**:
```bash
# 检查 Git 配置
git config --list

# 设置用户信息
git config user.name "Your Name"
git config user.email "your@email.com"

# 检查分支状态
git status
git branch -v
```

### IDE 集成问题

**问题**: Claude Code 不识别项目

**解决方案**:
```bash
# 检查 .claude 目录
ls -la .claude/

# 重新启动 Claude Code
# 在 IDE 中重新打开项目

# 检查配置文件
cat .claude/config.json
```

### CI/CD 集成问题

**问题**: 自动化流程失败

**解决方案**:
```bash
# 检查环境变量
env | grep CLAUDE

# 设置必要的环境变量
export CLAUDE_FLOW_MODE=production
export CLAUDE_FLOW_TIMEOUT=300000

# 在 CI 中使用非交互模式
./claude-flow sparc run tdd --non-interactive
```

## 数据恢复

### 内存数据丢失

**恢复步骤**:
```bash
# 检查备份文件
ls -la *.json memory/backups/

# 从备份恢复
./claude-flow memory import backup.json

# 重建索引
./claude-flow memory rebuild-index

# 验证恢复
./claude-flow memory stats
```

### 配置文件损坏

**恢复步骤**:
```bash
# 备份当前配置
cp .roomodes .roomodes.backup

# 从模板恢复
cp templates/basic/.roomodes .roomodes

# 手动合并自定义配置
vim .roomodes
```

## 环境特定问题

### macOS 问题

**问题**: Gatekeeper 阻止执行

**解决方案**:
```bash
# 移除隔离标志
xattr -d com.apple.quarantine claude-flow

# 或者在系统偏好设置中允许
# 系统偏好设置 -> 安全性与隐私 -> 通用 -> 仍要打开
```

### Linux 问题

**问题**: 缺少共享库

**解决方案**:
```bash
# 检查依赖
ldd claude-flow

# 安装缺失的库
sudo apt-get install libc6-dev
sudo apt-get install build-essential
```

### Windows 问题

**问题**: 路径分隔符问题

**解决方案**:
```bash
# 使用正斜杠
./claude-flow sparc run tdd "test"

# 或者使用 WSL
wsl ./claude-flow sparc run tdd "test"
```

## 调试技巧

### 启用详细日志

```bash
# 设置调试级别
export CLAUDE_FLOW_DEBUG=true
export CLAUDE_FLOW_LOG_LEVEL=debug

# 运行带调试的命令
./claude-flow sparc run tdd --debug --verbose
```

### 使用调试模式

```bash
# 进入调试模式
./claude-flow debug --interactive

# 逐步执行
./claude-flow sparc run tdd --step-by-step

# 检查中间状态
./claude-flow status --all
```

### 日志分析

```bash
# 查看最新日志
tail -f .claude/logs/claude-flow.log

# 搜索错误
grep -i error .claude/logs/claude-flow.log

# 分析性能
grep -i "duration\|time" .claude/logs/claude-flow.log
```

## 预防性维护

### 定期检查

```bash
# 每周运行健康检查
./claude-flow health-check --comprehensive

# 每月清理内存
./claude-flow memory cleanup --older-than "30d"

# 每季度备份配置
cp -r .claude .roo .roomodes backups/$(date +%Y%m%d)/
```

### 自动化监控

```bash
# 设置监控脚本
cat > monitor.sh << 'EOF'
#!/bin/bash
while true; do
    ./claude-flow status --quiet || echo "Alert: System unhealthy"
    sleep 300
done
EOF

chmod +x monitor.sh
nohup ./monitor.sh &
```

## 获取帮助

### 内置帮助

```bash
# 获取一般帮助
./claude-flow --help

# 获取特定模式帮助
./claude-flow sparc help tdd

# 获取内存系统帮助
./claude-flow memory --help
```

### 社区资源

- **官方文档**: https://github.com/ruvnet/claude-flow
- **问题报告**: https://github.com/zhengshui/claude-flow-template-zh/issues
- **讨论论坛**: https://github.com/zhengshui/claude-flow-template-zh/discussions

### 诊断信息收集

当需要报告问题时，收集以下信息：

```bash
# 系统信息
uname -a
./claude-flow --version

# 配置信息
./claude-flow config show

# 状态信息
./claude-flow status --all

# 最新日志
tail -100 .claude/logs/claude-flow.log
```

## 常见错误代码

| 错误代码 | 含义 | 解决方案 |
|----------|------|----------|
| CF001 | 配置文件缺失 | 重新应用模板 |
| CF002 | 权限不足 | 检查文件权限 |
| CF003 | 内存系统错误 | 重建内存索引 |
| CF004 | 网络连接失败 | 检查网络设置 |
| CF005 | 模式未找到 | 检查 .roomodes 文件 |
| CF006 | 智能体超时 | 增加超时时间 |
| CF007 | 资源不足 | 清理系统资源 |
| CF008 | 版本不兼容 | 更新到最新版本 |

## 性能优化建议

### 系统层面

1. **内存管理**:
   - 定期清理旧数据
   - 使用内存压缩
   - 监控内存使用

2. **网络优化**:
   - 使用本地缓存
   - 配置适当的超时
   - 减少并发请求

3. **文件系统**:
   - 使用 SSD 存储
   - 定期碎片整理
   - 监控磁盘使用

### 应用层面

1. **模式选择**:
   - 根据任务选择合适的模式
   - 避免过度使用重型模式
   - 使用模式链组合

2. **智能体配置**:
   - 合理设置智能体数量
   - 配置适当的超时
   - 使用智能体池

3. **数据管理**:
   - 使用有效的查询策略
   - 实施数据分片
   - 定期优化索引

通过遵循这些排查指南和最佳实践，您应该能够解决大多数 Claude Flow 使用中遇到的问题。如果问题持续存在，请不要犹豫，向社区寻求帮助。