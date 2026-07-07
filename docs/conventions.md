# 项目规范

本文档记录可检查的编码、配置、文档和提交规则。

## 1. 命名

| 类型 | 规则 | 示例 |
|------|------|------|
| Java 类 | PascalCase | `SurveyController` |
| Java 方法 | lowerCamelCase，动词开头 | `updateStatus` |
| Mapper XML id | 与 Mapper 接口方法一致 | `getById` |
| 数据库字段 | snake_case | `create_time` |
| HTTP 路径 | 模块名前缀 + 动词/资源 | `/survey/edit` |

## 2. 分层依赖

| 规则 | 是否允许 | 说明 |
|------|----------|------|
| Controller 调 Service | 允许 | 控制层只做参数、鉴权、响应 |
| Controller 调 Mapper | 禁止 | 避免业务绕过 Service |
| Service 调 Mapper | 允许 | 业务层拥有事务和编排 |
| Mapper 调 Service | 禁止 | 数据访问层不能反向依赖业务 |
| 前端访问数据库 | 禁止 | 只能通过 HTTP API |

## 3. 配置和密钥

| 规则 | 检查方式 |
|------|----------|
| 真实密码不得写入 `application.yml` | 搜索 `password:` 和本机密码 |
| 本地配置放环境变量或 `.env` | `.env` 已被 `.gitignore` 忽略 |
| `.env.example` 只能放占位值 | review |
| README 命令不得包含真实密码 | review |

## 4. 数据库

| 规则 | 说明 |
|------|------|
| 推荐初始化脚本放 `docs/database/quest-platform-postgres.sql` | 便于 Supabase/CloudBase 云部署 |
| 旧版 MySQL 脚本只作课程资料追溯 | 不作为当前云部署事实源 |
| SQL 文件使用 UTF-8 | 避免中文乱码 |
| 答卷整段 JSON 使用 `TEXT` | 避免 255 字符截断 |
| 生产迁移不使用 `DROP TABLE` 初始化脚本 | 当前脚本仅适合本地演示 |

## 5. 前端

| 规则 | 当前状态 | 后续建议 |
|------|----------|----------|
| 后台页面必须检查登录态 | 已在关键页面使用 `user.checkLogin()` | 抽统一路由守卫 |
| Ajax 错误必须提示用户 | 已有基础提示 | 统一错误处理 |
| 用户输入进入 HTML 前应转义 | 当前不足 | 增加 escape helper |
| 不保留 `debugger` | 已清理 | 提交前搜索 |

## 6. 后端

| 规则 | 检查方式 |
|------|----------|
| 新增写操作应标注事务边界 | 查 `@Transactional` |
| 登录接口不得返回明文密码 | 查 `UserController.login` |
| token 签名密钥不得写入仓库 | 搜索 `APP_AUTH_SECRET` 和真实密钥 |
| 重复登录校验后续抽拦截器 | 技术债记录 |

## 7. 测试和验证

提交前至少运行：

```bash
mvn -DskipTests compile
mvn clean package -DskipTests
```

有 Supabase/PostgreSQL 和后端环境变量时，补充手动验收：

1. 登录后台。
2. 创建问卷。
3. 启用问卷。
4. 打开填写链接提交答卷。
5. 查看答卷详情。

## 8. PR 规则

| 规则 | 说明 |
|------|------|
| 单 PR 单功能 | 不把文档、重构、大功能混在一起 |
| PR 描述必须写测试 | 包含命令或手动验收 |
| 主分支保持可编译 | 至少 compile 通过 |
| 文档随行为更新 | 接口、配置、数据表变更必须改 docs |
