# Quest Survey Platform

一个基于 Spring Boot、MyBatis、MySQL、Redis 和 Layui 的问卷管理平台，覆盖后台登录、问卷创建、问卷发布、链接/二维码分享、在线填写和答卷查看。

## 系统总览

```text
Browser static pages
  -> Spring MVC Controller
  -> Service business orchestration
  -> MyBatis Mapper XML
  -> MySQL quest-platform

Login session cache:
Browser username marker -> Controller login check -> Redis user:login{username}
```

## 核心功能

| 功能 | 说明 | 主要入口 |
|------|------|----------|
| 用户登录/注册 | 后台用户登录、注册、退出 | `/user/login`, `/user/register`, `/user/logout` |
| 问卷管理 | 查询、创建、编辑、启停、删除、恢复问卷 | `/survey/*` |
| 问卷填写 | 公开填写已启用问卷，提交答卷 | `/page/answer.html`, `/answer/add` |
| 答卷查看 | 后台分页查看答卷和答题详情 | `/page/answer_table.html`, `/answer/list` |
| 二维码分享 | 根据问卷链接生成二维码图片 | `/api/qrcode` |

## 端到端数据流

1. 管理员打开 `/page/login.html`，提交用户名和密码到 `/user/login`。
2. 后端校验 `user` 表，登录成功后把用户登录态缓存到 Redis。
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
| 数据库 | MySQL 8 | 问卷、题目、选项、答卷、用户持久化 |
| 缓存 | Redis | 登录态缓存 |
| 前端 | HTML + CSS + Layui + jQuery | 页面渲染、表单构建、接口调用 |
| 构建 | Maven | 依赖管理、编译、打包 |
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
    └── database/quest-platform.sql
```

## 快速开始

### 1. 环境要求

| 依赖 | 建议版本 | 说明 |
|------|----------|------|
| JDK | 8 | 项目源码目标版本为 Java 8 |
| Maven | 3.6+ | 编译与运行 |
| MySQL | 8.x | 默认库名 `quest-platform` |
| Redis | 5+ | 默认端口 `16379`，可通过环境变量调整 |

### 2. 初始化数据库

先创建数据库：

```sql
CREATE DATABASE `quest-platform` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

再导入脚本：

```bash
mysql -u root -p quest-platform < docs/database/quest-platform.sql
```

脚本会创建并初始化 `user`、`survey`、`question`、`option`、`answer` 表。示例系统账号见 [docs/05-interfaces.md](docs/05-interfaces.md#4-默认示例账号)。

### 3. 配置本地环境变量

复制 `.env.example` 作为本地参考，但不要提交 `.env`。

PowerShell 示例：

```powershell
$env:DB_USERNAME="root"
$env:DB_PASSWORD="<your-local-mysql-password>"
$env:REDIS_HOST="localhost"
$env:REDIS_PORT="16379"
```

如需覆盖 JDBC 地址：

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/quest-platform?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&serverTimezone=Asia/Shanghai"
```

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

## 配置与密钥策略

`application.yml` 使用环境变量读取敏感配置：

| 环境变量 | 默认值 | 敏感 | 说明 |
|----------|--------|------|------|
| `DB_URL` | 本机 `quest-platform` JDBC | 否 | MySQL 连接地址 |
| `DB_USERNAME` | `root` | 否 | MySQL 用户名 |
| `DB_PASSWORD` | 空 | 是 | MySQL 密码，必须本地配置 |
| `REDIS_HOST` | `localhost` | 否 | Redis 主机 |
| `REDIS_PORT` | `16379` | 否 | Redis 端口 |
| `REDIS_PASSWORD` | 空 | 是 | Redis 密码 |
| `REDIS_DATABASE` | `0` | 否 | Redis database index |

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

## 当前边界

- 这是学习型问卷平台，不是生产级认证系统。
- 当前登录态依赖 Redis 与前端用户名标记，后续应升级为服务端会话或 JWT。
- 密码仍为明文存储，后续应引入 BCrypt 等不可逆哈希。
- 答卷内容以 JSON 字符串保存在 `answer.answer`，适合演示，复杂统计场景应拆成答题明细表。

## SSR 文档化说明

本仓库文档借鉴了 ZSSreference 的组织方法：README 使用“项目定位、系统总览、数据流、架构、项目结构、快速开始、配置、命令、文档索引”；`docs/README.md` 使用“技术栈表、阅读顺序、术语表”；`01-05` 文档分别沉淀需求、架构、前端、后端、接口契约；`mvp-plan.md` 记录里程碑到 PR 的推进方式；`conventions.md` 记录可检查规则。
