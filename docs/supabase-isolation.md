# Supabase 数据隔离策略

本文记录本项目在 Supabase 中的安全边界。目标是在同一个 Supabase 项目里保留其他项目数据，同时为 Quest Survey Platform 新开独立区域。

## 1. 隔离方式

本项目固定使用 PostgreSQL schema：

```text
ot_questplatform
```

可以把 Supabase 项目理解成一个数据库空间，schema 是数据库空间里的分区。本项目不使用默认 `public` schema 存业务表，而是把 `user`、`survey`、`question`、`option`、`answer` 五张表放到 `ot_questplatform` 中。

## 2. 应用如何进入这个 schema

后端通过环境变量指定 schema：

```text
DB_SCHEMA=ot_questplatform
```

`src/main/resources/application.yml` 会把该值传给 PostgreSQL JDBC 的 `currentSchema`。这样 MyBatis 里的 SQL 仍然写 `survey`、`question` 这类短表名，但数据库会优先在 `ot_questplatform` 里找表。

## 3. 初始化脚本的安全边界

`docs/database/quest-platform-postgres.sql` 是当前推荐的 Supabase 初始化脚本。

脚本只做这些事：

- `CREATE SCHEMA IF NOT EXISTS ot_questplatform`
- `CREATE TABLE IF NOT EXISTS ...`
- `CREATE INDEX IF NOT EXISTS ...`
- `INSERT ... ON CONFLICT DO NOTHING`
- 根据已有最大 ID 修正序列值

脚本不会做这些事：

- 不执行 `DROP SCHEMA`
- 不执行 `DROP TABLE`
- 不执行 `TRUNCATE`
- 不执行 `DELETE FROM`
- 不修改 `public` schema
- 不清空其他项目表

## 4. 线上推荐权限

线上后端推荐使用专用数据库角色，例如：

```text
quest_app
```

这个角色只应拥有 `ot_questplatform` schema 的使用权、表权限和序列权限，不授予它管理 `public` schema 或其他业务 schema 的权限。这样即使应用配置写错，也能降低误操作范围。

## 5. 操作前检查

在 Supabase SQL Editor 执行 SQL 前，先检查三点：

1. SQL 顶部是否明确创建或切换到 `ot_questplatform`。
2. SQL 中是否出现 `DROP`、`TRUNCATE`、不带 `WHERE` 的 `DELETE`。
3. SQL 是否引用了 `public.` 或其他项目 schema。

如果只是初始化本项目，应该只执行 `docs/database/quest-platform-postgres.sql`。旧版 `docs/database/quest-platform.sql` 是 MySQL 课程资料，不要在 Supabase 中执行。

## 6. 本项目的数据流位置

```text
Cloudflare Pages static pages
  -> CloudBase Run Spring Boot API
  -> PostgreSQL JDBC currentSchema=ot_questplatform
  -> Supabase schema ot_questplatform
  -> user / survey / question / option / answer
```

这条链路的关键点是：前端不直接连数据库，后端不使用默认 `public`，数据库用户不应拥有其他项目 schema 的写权限。
