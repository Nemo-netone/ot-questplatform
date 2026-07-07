# 项目工作规范

## 前置阅读规则

动手修改前，按任务类型读取对应事实源：

| 任务类型 | 必读文件 |
|----------|----------|
| 改需求或范围 | `docs/01-requirements.md` |
| 改架构或分层 | `docs/02-architecture.md` |
| 改页面、交互、样式 | `docs/03-frontend-spec.md` |
| 改后端业务 | `docs/04-backend-spec.md` |
| 改接口字段或路径 | `docs/05-interfaces.md` |
| 改数据库脚本 | `docs/database/quest-platform-postgres.sql`, `docs/supabase-isolation.md` |
| 改提交规范或流程 | `docs/conventions.md`, `docs/mvp-plan.md` |

## PR 提交规范

1. 每个 PR 只做一件事。
2. 主分支必须保持可编译。
3. 真实密码、token、Cookie、线上连接串不得提交。
4. 接口、配置、数据表或业务行为变更时，同步更新 docs。
5. 提交前至少运行 `mvn -DskipTests compile`。

## 默认 PR 描述模板

```markdown
## 背景

## 变更

## 数据流/调用链

## 验证

## 风险
```

## 本地运行提醒

本项目当前运行依赖 PostgreSQL/Supabase，不再依赖 Redis 登录态。数据库密码、CloudBase 环境变量、Supabase token、Cloudflare token 等敏感配置只能放在本机环境变量、平台控制台或用户级工具配置里，不写入仓库文件。

旧版 `docs/database/quest-platform.sql` 是 MySQL 课程资料，包含 `DROP TABLE`，只用于历史追溯；线上和 Supabase 初始化必须使用 `docs/database/quest-platform-postgres.sql`。
