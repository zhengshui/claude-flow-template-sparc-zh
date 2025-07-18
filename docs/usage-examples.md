# Claude Flow 使用示例集合

## 概述

本文档提供了 Claude Flow 在各种开发场景中的详细使用示例，涵盖 SPARC 方法论的完整工作流程。每个示例都包含具体的命令、期望的输出以及最佳实践。

## 快速入门示例

### 1. 基础项目设置

```bash
# 应用模板到新项目
./scripts/apply-template.sh /path/to/new-project
cd /path/to/new-project

# 验证安装
./claude-flow --help
./claude-flow sparc modes
```

**预期输出**:
```
Available SPARC modes:
- architect: 🏗️ 架构设计
- code: 🧠 自动编码
- tdd: 🧪 测试驱动开发
- spec-pseudocode: 📋 规范编写
- integration: 🔗 系统集成
- debug: 🪲 调试
- security-review: 🛡️ 安全审查
- docs-writer: 📚 文档编写
- swarm: 🐝 群体协调
```

### 2. 内存系统初始化

```bash
# 查看内存状态
./claude-flow memory stats

# 创建项目命名空间
./claude-flow memory store project_init "项目初始化完成"
```

## SPARC 完整工作流示例

### 示例 1: 用户认证系统开发

#### 第一阶段：规范定义 (Specification)

```bash
# 启动规范编写模式
./claude-flow sparc run spec-pseudocode "设计用户认证系统"
```

**任务描述**:
```
需求：创建一个安全的用户认证系统，支持：
- 用户注册和登录
- 密码加密存储
- JWT 令牌管理
- 会话管理
- 密码重置功能
```

**预期输出**:
- 详细的功能需求文档
- 用户故事和验收标准
- 边缘情况和约束条件
- 非功能性需求

#### 第二阶段：架构设计 (Architecture)

```bash
# 存储规范结果
./claude-flow memory store auth_spec "用户认证需求和约束条件已定义"

# 启动架构设计模式
./claude-flow sparc run architect "基于规范设计认证服务架构"
```

**架构要点**:
- 分层架构设计
- 数据库模式设计
- API 接口定义
- 安全策略制定

**预期输出**:
```
系统架构：
┌─────────────────────────────────────┐
│         认证 API 层                 │
├─────────────────────────────────────┤
│         业务逻辑层                  │
├─────────────────────────────────────┤
│         数据访问层                  │
├─────────────────────────────────────┤
│         数据库层                    │
└─────────────────────────────────────┘
```

#### 第三阶段：TDD 实现 (Refinement)

```bash
# 存储架构决策
./claude-flow memory store auth_arch "认证服务架构设计完成"

# 启动 TDD 模式
./claude-flow sparc tdd "实现用户认证功能"
```

**TDD 周期示例**:

1. **红灯阶段**:
```javascript
// 用户注册测试
describe('用户注册', () => {
  it('应该成功注册新用户', async () => {
    const userData = {
      username: 'testuser',
      email: 'test@example.com',
      password: 'SecurePass123!'
    };
    
    const result = await authService.register(userData);
    
    expect(result.success).toBe(true);
    expect(result.user.id).toBeDefined();
  });
});
```

2. **绿灯阶段**:
```javascript
// 最小实现
class AuthService {
  async register(userData) {
    // 基本实现使测试通过
    return {
      success: true,
      user: { id: 1 }
    };
  }
}
```

3. **重构阶段**:
```javascript
// 完整实现
class AuthService {
  async register(userData) {
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    const user = await this.userRepository.create({
      ...userData,
      password: hashedPassword
    });
    
    return {
      success: true,
      user: { id: user.id }
    };
  }
}
```

#### 第四阶段：安全审查

```bash
# 启动安全审查模式
./claude-flow sparc run security-review "审查认证系统安全性"
```

**审查清单**:
- 密码存储安全性
- SQL 注入防护
- JWT 令牌安全
- 会话管理
- 输入验证

#### 第五阶段：集成测试

```bash
# 启动集成模式
./claude-flow sparc run integration "认证系统集成测试"
```

### 示例 2: 电商产品管理系统

#### 规范阶段

```bash
./claude-flow sparc run spec-pseudocode "电商产品管理系统"
```

**功能需求**:
- 产品增删改查
- 分类管理
- 库存管理
- 价格管理
- 图片管理

#### 架构阶段

```bash
./claude-flow sparc run architect "产品管理微服务架构"
```

**微服务架构**:
```
产品服务 ←→ 分类服务
    ↓
库存服务 ←→ 价格服务
    ↓
图片服务 ←→ 搜索服务
```

#### TDD 实现

```bash
./claude-flow sparc tdd "产品管理核心功能"
```

**测试示例**:
```javascript
describe('产品管理', () => {
  it('应该能够创建新产品', async () => {
    const productData = {
      name: '智能手机',
      description: '高性能智能手机',
      price: 2999,
      category: '电子产品',
      stock: 100
    };
    
    const result = await productService.createProduct(productData);
    
    expect(result.id).toBeDefined();
    expect(result.name).toBe(productData.name);
  });
});
```

## 专业模式使用示例

### 调试模式示例

```bash
# 遇到性能问题时
./claude-flow sparc run debug "API 响应时间过长"
```

**调试步骤**:
1. 分析日志文件
2. 检查数据库查询
3. 监控内存使用
4. 识别性能瓶颈

### 文档编写模式

```bash
# 为 API 创建文档
./claude-flow sparc run docs-writer "用户认证 API 文档"
```

**文档示例**:
```markdown
# 用户认证 API

## 注册接口

**POST** `/api/auth/register`

### 请求参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | string | 是 | 用户名 |
| email | string | 是 | 邮箱地址 |
| password | string | 是 | 密码 |

### 响应示例

```json
{
  "success": true,
  "user": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com"
  }
}
```
```

## 多智能体协作示例

### Swarm 模式：大型项目开发

```bash
# 启动多智能体协作
./claude-flow swarm --strategy=development "电商平台完整开发"
```

**智能体分工**:
- **研究员**: 技术调研和需求分析
- **架构师**: 系统架构和技术选型
- **编程员**: 核心功能实现
- **测试员**: 测试用例和质量保证
- **文档员**: 技术文档和用户手册

### 智能体协调示例

```bash
# 研究阶段
./claude-flow swarm --strategy=research "前端框架技术选型"

# 开发阶段
./claude-flow swarm --strategy=development "用户管理模块开发"

# 测试阶段
./claude-flow swarm --strategy=testing "端到端测试覆盖"
```

## 内存管理示例

### 项目状态跟踪

```bash
# 存储项目里程碑
./claude-flow memory store milestone_auth "用户认证模块完成"
./claude-flow memory store milestone_product "产品管理模块完成"

# 查询项目进度
./claude-flow memory query milestone

# 导出项目历史
./claude-flow memory export project_history.json
```

### 跨会话状态保持

```bash
# 工作会话开始
./claude-flow memory store session_start "开始开发支付模块"

# 工作中断时存储状态
./claude-flow memory store current_task "支付接口实现中，完成了基础架构"

# 恢复工作时查询状态
./claude-flow memory query current_task
```

## 项目类型特定示例

### Web 应用项目

```bash
# 前端组件开发
./claude-flow sparc run code "React 用户仪表盘组件"

# 状态管理
./claude-flow sparc run architect "Redux 状态管理架构"

# 组件测试
./claude-flow sparc run tdd "用户仪表盘组件测试"
```

### API 项目

```bash
# API 设计
./claude-flow sparc run spec-pseudocode "RESTful API 规范"

# 接口实现
./claude-flow sparc run tdd "用户管理 API 端点"

# API 文档
./claude-flow sparc run docs-writer "API 接口文档"
```

### 数据库项目

```bash
# 数据库设计
./claude-flow sparc run architect "电商数据库架构"

# 迁移脚本
./claude-flow sparc run code "数据库迁移脚本"

# 性能优化
./claude-flow sparc run debug "数据库查询性能优化"
```

## 高级工作流示例

### 持续集成工作流

```bash
# 代码提交前检查
./claude-flow sparc run security-review "代码安全审查"
./claude-flow sparc run tdd "运行所有测试"

# 部署准备
./claude-flow sparc run integration "部署前集成测试"
./claude-flow sparc run docs-writer "部署文档更新"
```

### 维护工作流

```bash
# 性能监控
./claude-flow sparc run debug "系统性能分析"

# 安全更新
./claude-flow sparc run security-review "安全漏洞扫描"

# 文档维护
./claude-flow sparc run docs-writer "更新技术文档"
```

## 最佳实践示例

### 1. 模式选择策略

```bash
# 新功能开发
spec-pseudocode → architect → tdd → integration → docs-writer

# 问题修复
debug → tdd → security-review → integration

# 性能优化
debug → architect → code → tdd → integration

# 文档更新
docs-writer → security-review（对于敏感文档）
```

### 2. 内存使用模式

```bash
# 项目级别
./claude-flow memory store project_config "项目配置信息"

# 模块级别
./claude-flow memory store module_auth "认证模块设计决策"

# 会话级别
./claude-flow memory store session_progress "当前会话进度"
```

### 3. 错误处理示例

```bash
# 当 SPARC 模式失败时
./claude-flow sparc run debug "分析模式执行失败原因"

# 当内存查询失败时
./claude-flow memory stats  # 检查内存系统状态
./claude-flow memory query --debug "启用调试模式查询"
```

## 性能优化示例

### 并发执行策略

```bash
# 同时运行多个任务（推荐）
./claude-flow sparc run architect "系统架构" & \
./claude-flow sparc run security-review "安全审查" & \
./claude-flow sparc run docs-writer "文档更新"
```

### 内存优化

```bash
# 定期清理内存
./claude-flow memory cleanup --older-than "30d"

# 导出并备份重要数据
./claude-flow memory export backup_$(date +%Y%m%d).json
```

## 团队协作示例

### 多人协作工作流

```bash
# 团队成员 A：架构设计
./claude-flow sparc run architect "用户管理架构"
./claude-flow memory store arch_decisions "架构决策记录"

# 团队成员 B：功能实现
./claude-flow memory query arch_decisions
./claude-flow sparc run tdd "基于架构实现功能"

# 团队成员 C：测试和文档
./claude-flow sparc run integration "集成测试"
./claude-flow sparc run docs-writer "用户手册"
```

### 代码审查工作流

```bash
# 提交前自动检查
./claude-flow sparc run security-review "安全漏洞检查"
./claude-flow sparc run tdd "运行所有测试"

# 代码质量评估
./claude-flow sparc run code "代码质量分析和改进建议"
```

## 故障排除示例

### 常见问题解决

```bash
# 权限问题
chmod +x claude-flow
sudo chown -R $USER:$USER memory/

# 配置问题
./claude-flow sparc modes  # 验证模式配置
cat .roomodes  # 检查模式定义

# 内存问题
./claude-flow memory stats --verbose
./claude-flow memory query --debug "系统状态"
```

### 诊断命令

```bash
# 系统健康检查
./claude-flow status --all

# 详细诊断
./claude-flow debug --verbose --log-level debug

# 性能监控
./claude-flow monitor --interval 5000
```

## 总结

这些示例展示了 Claude Flow 在不同开发场景中的应用，从简单的功能开发到复杂的系统架构设计。通过遵循 SPARC 方法论和利用多智能体协作，开发团队可以显著提高开发效率和代码质量。

记住以下关键点：
1. **始终从规范开始**，明确需求和约束
2. **使用内存系统**保持项目状态和决策记录
3. **遵循 TDD 原则**确保代码质量
4. **定期进行安全审查**保证系统安全
5. **及时更新文档**便于团队协作

通过这些实践，您可以充分发挥 Claude Flow 的潜力，构建高质量的软件系统。