# Deployment

本文记录 Quest Survey Platform 的部署策略。当前推荐形态是：Cloudflare Pages 发布静态前端，CloudBase Run 托管 Spring Boot API，Supabase PostgreSQL 保存业务数据。

## 1. Cloudflare Pages 静态预览

| 项目 | 值 |
|------|----|
| GitHub 仓库 | `Nemo-netone/ot-questplatform` |
| 发布分支 | `main` |
| Pages 项目名 | `ot-questplatform` |
| 生产分支 | `main` |
| 发布目录 | `src/main/resources/static` |
| 已发布地址 | `https://ot-questplatform.pages.dev` |
| 首次发布时间 | 2026-07-07 |

固定地址的关键是：后续不要创建新的 Pages 项目，继续部署到同一个 `ot-questplatform` Pages 项目。Cloudflare Pages 的默认域名由项目名决定，同一个项目重复部署后地址保持不变。

具体某一次部署的短 ID、快照地址和提交号以 Cloudflare Pages 控制台或 `wrangler pages deployment list --project-name ot-questplatform` 为准，不在文档中长期固化，避免记录过期。

## 2. 部署边界

Cloudflare Pages 发布后可以打开静态页面，例如：

- `https://ot-questplatform.pages.dev/index.html`
- `https://ot-questplatform.pages.dev/page/login.html`
- `https://ot-questplatform.pages.dev/page/answer.html`

静态页面通过 `src/main/resources/static/js/app-config.js` 中的 `QuestConfig.apiUrl()` 访问后端。线上 Pages 域名会自动使用当前 CloudBase API：

```text
https://meta-d5gh4ds014005aff1-1369167244.ap-shanghai.app.tcloudbase.com
```

本地开发未配置 API 基址时，请求会打到同域名；如需临时切换后端，可用 `QUEST_API_BASE_URL`、`localStorage.QUEST_API_BASE_URL` 或地址栏 `apiBase` 参数覆盖。

临时测试远程 API 可以在浏览器地址后追加：

```text
https://ot-questplatform.pages.dev/page/login.html?apiBase=https://<cloudbase-api-domain>
```

该地址会写入浏览器 `localStorage`，后续页面会继续使用这个 API 基址。

## 3. 平台控制台入口

这些地址只用于登录和授权，不在仓库中记录任何 token、数据库密码或云服务密钥。

| 平台 | 用途 | 登录地址 |
|------|------|----------|
| Cloudflare Pages | 查看 `ot-questplatform` 静态前端部署、绑定 GitHub 自动发布 | <https://dash.cloudflare.com> |
| CloudBase / 腾讯云开发 | 部署 Spring Boot 后端服务、配置环境变量、查看服务域名 | <https://console.cloud.tencent.com/tcb> |
| Supabase | 创建 PostgreSQL 项目、执行初始化 SQL、复制 JDBC 连接信息 | <https://supabase.com/dashboard> |

完整功能上线需要三件事：

1. Supabase 已执行 `docs/database/quest-platform-postgres.sql`，业务表位于独立 schema `ot_questplatform`，不与 `public` schema 或其他项目表混用。
2. CloudBase Run 已部署本仓库 Dockerfile 构建出的 Spring Boot API，并配置 `DB_*`、`APP_AUTH_SECRET`、`CORS_ALLOWED_ORIGINS`。
3. Cloudflare Pages 前端通过 `apiBase` 或 `QUEST_API_BASE_URL` 指向 CloudBase 后端公开域名。

## 4. CloudBase Run 后端部署

后端使用仓库根目录的 `Dockerfile` 构建 Spring Boot 容器。CloudBase Run 需要配置以下环境变量：

| 环境变量 | 说明 |
|----------|------|
| `DB_URL` | Supabase PostgreSQL JDBC 地址，不在这里拼接 query 参数 |
| `DB_USERNAME` | Supabase 数据库用户名 |
| `DB_PASSWORD` | Supabase 数据库密码 |
| `DB_SSLMODE` | Supabase 线上建议 `require` |
| `DB_SCHEMA` | 本项目固定使用 `ot_questplatform` |
| `APP_AUTH_SECRET` | token 签名密钥，必须使用长随机字符串 |
| `APP_AUTH_TOKEN_TTL_SECONDS` | 登录有效期，默认 `86400` |
| `CORS_ALLOWED_ORIGINS` | 允许访问 API 的前端域名，例如 `https://ot-questplatform.pages.dev` |

当前 CloudBase Run 服务：

| 项目 | 值 |
|------|----|
| 环境 ID | `meta-d5gh4ds014005aff1` |
| 服务名 | `ot-questplatform-api` |
| 容器端口 | `8080` |
| 公开 API 基址 | `https://meta-d5gh4ds014005aff1-1369167244.ap-shanghai.app.tcloudbase.com` |

当前版本状态（2026-07-07）：

| 版本 | 流量 | 状态 | 说明 |
|------|------|------|------|
| `ot-questplatform-api-001` | 100% | normal | 当前线上版本；未注入数据库环境变量，会回落到 `localhost:5432`，数据库接口会 500 |
| `ot-questplatform-api-002` | 0% | normal | 历史构建版本，保留作镜像来源/回溯 |
| `ot-questplatform-api-005` | 0% | normal | 已注入 Supabase/`ot_questplatform` 环境变量，目标切流版本 |

CloudBase CLI 在当前旧版 CloudBase Run 环境中可以创建版本，但 `run:deprecated version modify`、`run service:config` 和新 `cloudrun traffic promote` 对该服务的流量切换不稳定。当前需要在控制台把 `ot-questplatform-api-005` 切到 100% 流量：

```text
https://tcb.cloud.tencent.com/dev?envId=meta-d5gh4ds014005aff1#/platform-run/service/detail?serverName=ot-questplatform-api&tabId=deploy&envId=meta-d5gh4ds014005aff1
```

控制台操作建议：

1. 打开 CloudBase Run 服务 `ot-questplatform-api` 的版本/发布页面。
2. 将版本 `ot-questplatform-api-005` 发布为全量版本或调整到 100% 流量。
3. 保留 `ot-questplatform-api-001` 作为临时回滚点，确认验证通过后再清理旧版本。

已经配置的 HTTP 访问路由包括 `/user/login`、`/user/register`、`/user/logout`、`/survey/list`、`/survey/detail`、`/survey/updateStatus`、`/survey/remove`、`/survey/restore`、`/survey/edit`、`/answer/add`、`/answer/list`、`/api/qrcode`。保留旧的 `/api/ai/chat` 和 `/api/ai/chat-http` 云函数路由，不属于本项目后端。

Supabase 初始化脚本：

```text
docs/database/quest-platform-postgres.sql
```

该脚本会创建并使用独立 schema `ot_questplatform`，只在这个 schema 内创建缺失对象和补充缺失的示例数据。脚本不包含 `DROP TABLE`、`TRUNCATE` 或 `DROP SCHEMA`，不会清理 `public` schema、其他 schema 或其他项目表。更完整的数据隔离说明见 `docs/supabase-isolation.md`。

Supabase 平台 access token 只能管理项目，不能替代 PostgreSQL 数据库密码。完整上线前必须在 Supabase Dashboard 的数据库设置页复制或重置数据库密码，或创建专用数据库角色，并把该密码配置到 CloudBase Run 的 `DB_PASSWORD`。

推荐 CloudBase Run 部署命令：

```powershell
$env:DB_PASSWORD="<supabase-database-password>"
$env:APP_AUTH_SECRET="<long-random-secret>"

tcb run deploy `
  -e meta-d5gh4ds014005aff1 `
  --serviceName ot-questplatform-api `
  --path . `
  --containerPort 8080 `
  --override `
  --noConfirm `
  --envParams "DB_URL=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres&DB_USERNAME=quest_app&DB_PASSWORD=$env:DB_PASSWORD&DB_SSLMODE=require&DB_SCHEMA=ot_questplatform&APP_AUTH_SECRET=$env:APP_AUTH_SECRET&APP_AUTH_TOKEN_TTL_SECONDS=86400&CORS_ALLOWED_ORIGINS=https://ot-questplatform.pages.dev" `
  --remark "quest platform production api" `
  --json
```

如果通过控制台发布，也需要在 CloudBase Run 服务版本配置里设置同样的环境变量。

CloudBase 切流后用以下接口验证：

```powershell
Invoke-WebRequest -Uri 'https://meta-d5gh4ds014005aff1-1369167244.ap-shanghai.app.tcloudbase.com/api/qrcode?content=test' -UseBasicParsing
Invoke-WebRequest -Uri 'https://meta-d5gh4ds014005aff1-1369167244.ap-shanghai.app.tcloudbase.com/survey/list?isDelete=0&title=&page=1&pageSize=5' -UseBasicParsing
```

其中 `/api/qrcode` 只验证服务可访问；`/survey/list` 会真实访问 Supabase，是判断数据库环境变量是否生效的关键接口。

## 5. Wrangler 发布命令

凭据只放在本机环境变量或 Cloudflare 控制台，不写入仓库文件。

```powershell
$env:CLOUDFLARE_ACCOUNT_ID="<cloudflare-account-id>"
$env:CLOUDFLARE_API_TOKEN="<cloudflare-api-token>"

wrangler pages project create ot-questplatform --production-branch main
wrangler pages deploy src/main/resources/static `
  --project-name ot-questplatform `
  --branch main `
  --commit-hash $(git rev-parse HEAD) `
  --commit-message "deploy: static preview"
```

如果 Pages 项目已经存在，跳过 `project create`，只执行 `pages deploy`。

## 6. GitHub 连接式发布

也可以在 Cloudflare Dashboard 中连接 GitHub 仓库：

| 配置项 | 值 |
|--------|----|
| Repository | `Nemo-netone/ot-questplatform` |
| Production branch | `main` |
| Build command | 留空 |
| Build output directory | `src/main/resources/static` |
| Root directory | `/` |

这种方式适合长期维护：以后推送到 `main` 后，Cloudflare Pages 会自动重新发布，默认地址仍保持 `https://ot-questplatform.pages.dev`。

## 7. 发布前检查

- [ ] `git status --short --branch` 显示当前分支为 `main`。
- [ ] `git push` 已把最新提交推到 `origin/main`。
- [ ] Wrangler 当前凭据能访问目标 Cloudflare Account。
- [ ] Pages 项目名仍为 `ot-questplatform`。
- [ ] 发布目录仍为 `src/main/resources/static`。
- [ ] 仓库没有提交 `.env`、token、数据库密码或云服务密钥。
- [ ] Supabase 已执行 `docs/database/quest-platform-postgres.sql`，并确认表在 `ot_questplatform` schema 中。
- [ ] Supabase SQL Editor 中没有执行针对 `public` schema 或其他项目 schema 的删除、清空、重建操作。
- [ ] CloudBase Run 已配置 `DB_*`、`DB_SSLMODE`、`DB_SCHEMA`、`APP_AUTH_SECRET` 和 `CORS_ALLOWED_ORIGINS`。
