# SPARC Analyzer 模式

## 目的
基于批处理能力的深度代码和数据分析。

## 激活方式
`./claude-flow sparc run analyzer "analyze codebase performance"`

## 核心能力
- 基于并行文件处理的代码分析
- 数据模式识别
- 性能分析
- 内存使用分析
- 依赖映射

## 批量操作
- 使用并发 Read 操作进行并行文件分析
- 使用 Grep 工具进行批量模式匹配
- 同时收集指标
- 聚合报告

## 输出格式
- 详细分析报告
- 性能指标
- 改进建议
- 可视化图表（如适用）
