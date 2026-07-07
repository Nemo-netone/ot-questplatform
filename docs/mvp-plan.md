# MVP 执行计划

## 0. 进度看板

**整体进度：2 / 4 里程碑 · 0 / 6 PR**

| 里程碑 | 状态 | PR 进度 |
|--------|------|---------|
| M0 仓库整理 | 完成 | 0 / 1 |
| M1 配置安全化 | 完成 | 0 / 1 |
| M2 基础质量修复 | 进行中 | 0 / 2 |
| M3 展示增强 | 进行中 | 0 / 2 |

## 1. MVP 目标

把教学型问卷系统整理为一个可运行、可解释、可提交 GitHub 的后端作品项目。

## 2. MVP 范围

In：

- README 快速开始。
- SSR 设计文档。
- 数据库脚本归档。
- 配置环境变量化。
- 编译和打包通过。

Out：

- 前后端分离。
- Docker Compose。
- 生产级认证授权。
- 大规模重构 UI。

## 3. 里程碑

### M0 · 仓库整理

- [x] 明确提交主体为 `quest/quest`。
- [x] 新增根 README。
- [x] 新增 docs 文档索引。
- [x] **验收**：新人能从 README 看到项目定位、结构和启动路径。

### M1 · 配置安全化

- [x] `application.yml` 改为环境变量读取数据库和 Redis 配置。
- [x] 新增 `.env.example`。
- [x] `.gitignore` 忽略本地 `.env`。
- [x] **验收**：仓库不包含本机真实数据库密码。

### M2 · 基础质量修复

- [x] 修复 Redis 过期时间方法写死 key。
- [x] 登录接口不返回明文密码。
- [x] 问卷更新保留原问卷 ID。
- [ ] 增加最小 MockMvc 或 Service 测试。
- [ ] **验收**：compile/package 已通过，关键流程待本地 MySQL/Redis 启动后手动验证。

### M3 · 展示增强

- [x] 增加 Cloudflare Pages 静态预览部署说明。
- [ ] 增加项目截图。
- [ ] 增加 Docker Compose 或更完整本地启动说明。
- [ ] 增加架构图导出图片。
- [ ] 完成 Cloudflare Pages 发布并记录生产 URL。
- [ ] **验收**：GitHub 首页能作为简历项目入口。

## 4. 里程碑到 PR 映射

| PR | 标题建议 | 范围 |
|----|----------|------|
| PR-1 | `docs: 初始化项目 README 与 SSR 文档栈` | README、docs |
| PR-2 | `chore: 环境变量化数据库和 Redis 配置` | application.yml、.env.example |
| PR-3 | `fix: 修复 Redis 过期时间和登录密码返回` | RedisService、UserController |
| PR-4 | `fix: 保留问卷更新时的主键和历史答卷` | SurveyService、SurveyMapper |
| PR-5 | `test: 增加核心接口或服务测试` | test |
| PR-6 | `docs: 增加截图和部署说明` | docs、README |

## 5. 关键技术决策

| 决策点 | 选择 | 理由 |
|--------|------|------|
| 仓库主体 | `quest/quest` | 外层 day1-day9 是课程资料，不适合简历仓库主体 |
| 数据库脚本位置 | `docs/database` | README 可直接引用，仓库独立可运行 |
| 凭据管理 | 环境变量 | 避免提交本机密码 |
| 文档组织 | SSR 01-05 | 让需求、架构、接口和规范可追溯 |

## 6. 风险与对策

| 风险 | 影响 | 对策 |
|------|------|------|
| MySQL 密码写入仓库 | 泄露本机配置习惯 | 使用环境变量和 `.env.example` |
| Redis 未启动导致登录校验失败 | 后台操作不可用 | README 明确 Redis 依赖 |
| 初始化 SQL 含 DROP TABLE | 误删已有数据 | 文档注明仅用于本地演示 |
| 密码明文存储 | 不适合生产 | docs 标为技术债，后续引入 BCrypt |

## 7. 验收清单

- [x] `mvn -DskipTests compile`
- [x] `mvn clean package -DskipTests`
- [x] `mvn test`
- [ ] 本地导入数据库脚本成功。
- [ ] 设置环境变量后应用能启动。
- [ ] 后台登录、创建问卷、提交答卷、查看答卷通过。
