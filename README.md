# Quest Survey Platform

一个基于 Spring Boot、MyBatis、PostgreSQL/Supabase 和 Layui 的问卷管理平台，覆盖后台登录、问卷创建、问卷发布、链接/二维码分享、在线填写和答卷查看。前端可部署到 Cloudflare Pages，后端可部署到 CloudBase Run，数据库可使用 Supabase PostgreSQL。

## 系统总览

```text
Browser static pages
  -> Spring MVC Controller
  -> Service business orchestration
  -> MyBatis Mapper XML
  -> PostgreSQL / Supabase schema ot_questplatform

Auth flow:
Browser login form -> /user/login -> JWT-like token -> Authorization Bearer header
```

## 核心功能

| 功能 | 说明 | 主要入口 |
|------|------|----------|
| 用户登录/注册 | 后台用户登录、注册、退出 | `/user/login`, `/user/register`, `/user/logout` |
| 问卷管理 | 查询、创建、编辑、启停、删除、恢复问卷 | `/survey/list`, `/survey/detail`, `/survey/edit` |
| 问卷填写 | 公开填写已启用问卷，提交答卷 | `/page/answer.html`, `/answer/add` |
| 答卷查看 | 后台分页查看答卷和答题详情 | `/page/answer_table.html`, `/answer/list` |
| 二维码分享 | 根据问卷链接生成二维码图片 | `/api/qrcode` |

## 端到端数据流

1. 管理员打开 `/page/login.html`，提交用户名和密码到 `/user/login`。
2. 后端校验 `user` 表，登录成功后返回 token，前端后续请求通过 `Authorization: Bearer ...` 携带登录态。
3. 管理员在 `/index.html` 查看问卷列表，前端调用 `/survey/list`。
4. 创建问卷时，前端提交标题、题目和选项到 `/survey/edit`。
5. 后端写入 `survey`、`question`、`option` 三类表。
6. 受访者打开 `/page/answer.html?id={surveyId}`，读取问卷结构并提交答案。
7. 后端把整份答卷 JSON 保存到 `answer` 表。
8. 管理员打开答卷页面，分页读取 `answer` 表并查看详情。

## 技术栈

| 分类 | 技术 | 用途 |
|------|------|------|
| 后端 | Spring Boot 2.3.12 | Web API 与静态资源服务 |
| 数据访问 | MyBatis + XML Mapper | SQL 映射和数据库访问 |
| 数据库 | PostgreSQL / Supabase | 问卷、题目、选项、答卷、用户持久化 |
| 认证 | HMAC token | 后台写操作登录态校验 |
| 前端 | HTML + CSS + Layui + jQuery | 页面渲染、表单构建、接口调用 |
| 构建/部署 | Maven, Docker | 依赖管理、编译、打包、CloudBase 容器部署 |
| 工具库 | PageHelper, ZXing, FastJSON | 分页、二维码、JSON 处理 |

## 项目结构

```text
.
├── pom.xml
├── .env.example
├── src
│   ├── main
│   │   ├── java/com/wjh/quest
│   │   │   ├── controller     # HTTP API 入口
│   │   │   ├── service        # 业务编排
│   │   │   ├── dao            # MyBatis Mapper 接口
│   │   │   ├── entity         # 数据表实体
│   │   │   └── utils          # 统一返回结构
│   │   └── resources
│   │       ├── mapper         # MyBatis XML SQL
│   │       ├── static         # Layui 静态页面
│   │       └── application.yml
│   └── test
└── docs
    ├── 01-requirements.md
    ├── 02-architecture.md
    ├── 03-frontend-spec.md
    ├── 04-backend-spec.md
    ├── 05-interfaces.md
    ├── conventions.md
    ├── mvp-plan.md
    ├── database/quest-platform.sql
    └── database/quest-platform-postgres.sql
```

## 快速开始

### 1. 环境要求

| 依赖 | 建议版本 | 说明 |
|------|----------|------|
| JDK | 8 | 项目源码目标版本为 Java 8 |
| Maven | 3.6+ | 编译与运行 |
| PostgreSQL | 14+ | 本地库名建议 `quest_platform`，线上 Supabase 使用独立 schema `ot_questplatform` |

### 2. 初始化数据库

推荐使用 PostgreSQL/Supabase 脚本：

```bash
psql "<postgres-connection-string>" -f docs/database/quest-platform-postgres.sql
```

也可以在 Supabase Dashboard 的 SQL Editor 中直接执行：

```text
docs/database/quest-platform-postgres.sql
```

旧版 MySQL 脚本仍保留在 `docs/database/quest-platform.sql`，用于课程资料追溯。当前云部署推荐 PostgreSQL 脚本。脚本会创建并初始化 `user`、`survey`、`question`、`option`、`answer` 表。示例系统账号见 [docs/05-interfaces.md](docs/05-interfaces.md#4-默认示例账号)。

Supabase 中本项目使用独立 schema `ot_questplatform`。该脚本只会在这个 schema 内创建缺失对象和补充缺失的示例数据，不会删除、清空或覆盖已有表数据，也不会清理 `public` schema 或其他项目表。隔离策略见 [docs/supabase-isolation.md](docs/supabase-isolation.md)。

### 3. 配置本地环境变量

复制 `.env.example` 作为本地参考，但不要提交 `.env`。

PowerShell 示例：

```powershell
$env:DB_URL="jdbc:postgresql://localhost:5432/quest_platform"
$env:DB_USERNAME="postgres"
$env:DB_PASSWORD="<your-postgres-password>"
$env:DB_SCHEMA="ot_questplatform"
$env:DB_SSLMODE="prefer"
$env:APP_AUTH_SECRET="<long-random-secret>"
$env:CORS_ALLOWED_ORIGINS="http://localhost:8080,https://ot-questplatform.pages.dev"
```

Supabase JDBC 地址通常从 Supabase Dashboard 的数据库连接页面复制，形态类似：

```text
jdbc:postgresql://<host>:5432/postgres
```

线上 Supabase 的 SSL 和 schema 建议用独立环境变量配置：`DB_SSLMODE=require`、`DB_SCHEMA=ot_questplatform`。

### 4. 启动应用

开发启动：

```bash
mvn spring-boot:run
```

打包：

```bash
mvn clean package -DskipTests
```

运行 jar：

```bash
java -jar target/quest-0.0.1-SNAPSHOT.jar
```

访问入口：

```text
http://localhost:8080/index.html
```

## 常用命令

| 命令 | 作用 |
|------|------|
| `mvn test` | 运行测试 |
| `mvn -DskipTests compile` | 编译源码 |
| `mvn clean package -DskipTests` | 打包可执行 jar |
| `mvn spring-boot:run` | 本地启动服务 |

## Cloudflare Pages 静态预览

本项目可以把 `src/main/resources/static` 发布到 Cloudflare Pages，作为静态页面预览。固定发布目标如下：

| 项目 | 值 |
|------|----|
| Pages 项目名 | `ot-questplatform` |
| 生产分支 | `main` |
| 发布目录 | `src/main/resources/static` |
| 已发布地址 | `https://ot-questplatform.pages.dev` |

注意：Cloudflare Pages 只托管静态 HTML/CSS/JS，不运行 Spring Boot API。完整业务流程需要把 Java 后端部署到 CloudBase Run，并连接 Supabase PostgreSQL。部署细节见 [docs/deployment.md](docs/deployment.md)。

线上 Pages 域名 `https://ot-questplatform.pages.dev` 会在 `src/main/resources/static/js/app-config.js` 中自动使用 CloudBase API：

```text
https://meta-d5gh4ds014005aff1-1369167244.ap-shanghai.app.tcloudbase.com
```

本地开发仍默认使用同源 API；如需临时切换后端，可在页面地址追加 `?apiBase=<api-origin>`。

## 配置与密钥策略

`application.yml` 使用环境变量读取敏感配置：

| 环境变量 | 默认值 | 敏感 | 说明 |
|----------|--------|------|------|
| `DB_URL` | 本机 PostgreSQL JDBC | 否 | PostgreSQL/Supabase JDBC 地址 |
| `DB_USERNAME` | `postgres` | 否 | PostgreSQL/Supabase 用户名 |
| `DB_PASSWORD` | 空 | 是 | PostgreSQL/Supabase 密码 |
| `DB_SSLMODE` | `prefer` | 否 | PostgreSQL SSL 模式；Supabase 线上建议 `require` |
| `DB_SCHEMA` | `ot_questplatform` | 否 | PostgreSQL schema；线上隔离本项目数据 |
| `APP_AUTH_SECRET` | `change-me-in-production` | 是 | token 签名密钥，线上必须改成长随机值 |
| `APP_AUTH_TOKEN_TTL_SECONDS` | `86400` | 否 | 登录 token 有效期 |
| `CORS_ALLOWED_ORIGINS` | 本地和 Pages 地址 | 否 | 允许访问后端 API 的前端域名 |

不要把真实密码、token、Cookie 或线上连接串提交到仓库。

## 文档索引

建议按顺序阅读：

1. [docs/README.md](docs/README.md)
2. [docs/01-requirements.md](docs/01-requirements.md)
3. [docs/02-architecture.md](docs/02-architecture.md)
4. [docs/03-frontend-spec.md](docs/03-frontend-spec.md)
5. [docs/04-backend-spec.md](docs/04-backend-spec.md)
6. [docs/05-interfaces.md](docs/05-interfaces.md)
7. [docs/conventions.md](docs/conventions.md)
8. [docs/mvp-plan.md](docs/mvp-plan.md)
9. [docs/deployment.md](docs/deployment.md)
10. [docs/supabase-isolation.md](docs/supabase-isolation.md)

## 当前边界

- 这是学习型问卷平台，不是生产级认证系统。
- 当前登录态为 HMAC token，适合作品演示；生产系统仍建议接入成熟认证方案。
- 密码仍为明文存储，后续应引入 BCrypt 等不可逆哈希。
- 答卷内容以 JSON 字符串保存在 `answer.answer`，适合演示，复杂统计场景应拆成答题明细表。

## SSR 文档化说明

本仓库文档借鉴了 ZSSreference 的组织方法：README 使用“项目定位、系统总览、数据流、架构、项目结构、快速开始、配置、命令、文档索引”；`docs/README.md` 使用“技术栈表、阅读顺序、术语表”；`01-05` 文档分别沉淀需求、架构、前端、后端、接口契约；`mvp-plan.md` 记录里程碑到 PR 的推进方式；`conventions.md` 记录可检查规则。
