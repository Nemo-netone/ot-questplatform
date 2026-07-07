# Quest Survey Platform · 设计文档

本目录是项目的设计事实源，按“需求 -> 架构 -> 前端 -> 后端 -> 接口 -> 计划 -> 规范”的顺序组织。

## 系统能力与技术栈

| 模块 | 技术 | 职责 |
|------|------|------|
| 静态前端 | HTML, CSS, Layui, jQuery | 页面渲染、拖拽构建问卷、提交接口请求 |
| Web API | Spring MVC | 接收请求、参数绑定、登录态校验、统一返回 |
| 业务层 | Spring Service | 问卷、题目、选项、答卷和登录流程编排 |
| 数据访问 | MyBatis Mapper XML | 执行 SQL，映射实体对象 |
| 持久化 | PostgreSQL / Supabase | 保存用户、问卷、题目、选项、答卷 |
| 认证 | HMAC token | 保存前端登录态并校验后台写操作 |

## 架构边界

| 边界 | 规则 | 守护方式 |
|------|------|----------|
| Controller 不直接写 SQL | 只能调用 Service | Code review，后续可引入 ArchUnit |
| Service 不直接拼接动态 SQL | 通过 Mapper XML 访问数据库 | Mapper 文件审查 |
| 前端不直接连接数据库 | 只能调用 HTTP API | 目录结构与部署边界 |
| 真实凭据不入库 | 密码通过环境变量注入 | `.gitignore` + review |
| 数据库初始化脚本归档 | 脚本放入 `docs/database` | README 快速开始引用 |

## 文档索引

| 顺序 | 文档 | 作用 |
|------|------|------|
| 1 | [01-requirements.md](01-requirements.md) | 需求、范围、验收 |
| 2 | [02-architecture.md](02-architecture.md) | 分层架构、数据流、生命周期 |
| 3 | [03-frontend-spec.md](03-frontend-spec.md) | 页面职责、状态和交互 |
| 4 | [04-backend-spec.md](04-backend-spec.md) | 后端模块、业务编排、错误策略 |
| 5 | [05-interfaces.md](05-interfaces.md) | API、字段、示例、错误约定 |
| 6 | [conventions.md](conventions.md) | 可检查的编码和文档规范 |
| 7 | [mvp-plan.md](mvp-plan.md) | 里程碑、PR 映射、风险 |
| 8 | [database/quest-platform-postgres.sql](database/quest-platform-postgres.sql) | Supabase/PostgreSQL 初始化脚本 |
| 9 | [deployment.md](deployment.md) | Cloudflare Pages 静态预览部署策略 |
| 10 | [supabase-isolation.md](supabase-isolation.md) | Supabase 多项目数据隔离策略 |
| 11 | [operations-runbook.md](operations-runbook.md) | 线上运行、排障、切流和完整功能验收清单 |

## 关键术语

| 术语 | 含义 |
|------|------|
| Survey | 一份问卷，包含标题、状态、创建者和删除标记 |
| Question | 问卷中的一道题，类型包括 text、textarea、select、radio、checkbox |
| Option | select/radio/checkbox 题目的候选项 |
| Answer | 一次问卷提交，当前以 JSON 字符串保存整份答案 |
| Login state | 后台用户登录态，前端保存 token，后端通过 `Authorization: Bearer ...` 校验 |
| Soft delete | 问卷逻辑删除，设置 `is_delete=1`，不物理删除 |
