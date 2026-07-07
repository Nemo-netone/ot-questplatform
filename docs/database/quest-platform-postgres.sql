-- Quest Survey Platform PostgreSQL schema for Supabase.
-- Safe initializer: creates this project's own schema and missing objects only.
-- It does not drop tables, truncate data, or touch the public schema.
-- Existing sample rows are updated only when their text is already corrupted
-- into '?' or replacement characters, so normal data is preserved.

CREATE SCHEMA IF NOT EXISTS ot_questplatform;
SET search_path TO ot_questplatform;

CREATE TABLE IF NOT EXISTS "user" (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  password VARCHAR(64),
  phone VARCHAR(20),
  status SMALLINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS survey (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  status SMALLINT NOT NULL DEFAULT 0,
  create_time TIMESTAMPTZ DEFAULT now(),
  creator VARCHAR(64),
  is_delete SMALLINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS question (
  id BIGSERIAL PRIMARY KEY,
  survey_id BIGINT REFERENCES survey(id) ON DELETE CASCADE,
  title VARCHAR(1024),
  create_time TIMESTAMPTZ DEFAULT now(),
  "type" VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS "option" (
  id BIGSERIAL PRIMARY KEY,
  question_id BIGINT REFERENCES question(id) ON DELETE CASCADE,
  survey_id BIGINT REFERENCES survey(id) ON DELETE CASCADE,
  content VARCHAR(256),
  create_time TIMESTAMPTZ DEFAULT now(),
  option_id BIGINT
);

CREATE TABLE IF NOT EXISTS answer (
  id BIGSERIAL PRIMARY KEY,
  source_type SMALLINT,
  source_ip VARCHAR(64),
  answer TEXT,
  survey_id BIGINT REFERENCES survey(id) ON DELETE SET NULL,
  create_time TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_survey_is_delete ON survey(is_delete);
CREATE INDEX IF NOT EXISTS idx_survey_status ON survey(status);
CREATE INDEX IF NOT EXISTS idx_question_survey_id ON question(survey_id);
CREATE INDEX IF NOT EXISTS idx_option_question_id ON "option"(question_id);
CREATE INDEX IF NOT EXISTS idx_option_survey_id ON "option"(survey_id);
CREATE INDEX IF NOT EXISTS idx_answer_survey_id ON answer(survey_id);

INSERT INTO "user" (id, username, password, phone, status)
VALUES (1, 'admin', '123456', '123456', 0)
ON CONFLICT DO NOTHING;

INSERT INTO survey (id, title, status, create_time, creator, is_delete)
VALUES
  (2, '客户满意度调查', 0, '2025-08-19 10:00:00+08', 'admin', 0),
  (3, '2025年员工满意度调查', 1, '2025-08-20 09:15:00+08', 'hr_admin', 0),
  (4, '智能手机使用习惯调查', 1, '2025-08-21 13:00:00+08', 'marketing', 0)
ON CONFLICT (id) DO UPDATE
SET title = EXCLUDED.title
WHERE survey.title LIKE '%?%' OR survey.title LIKE '%�%';

INSERT INTO question (id, survey_id, title, create_time, "type")
VALUES
  (6, 2, '您对我们的产品整体满意度如何？', '2025-08-19 10:00:00+08', 'radio'),
  (7, 2, '您最常使用我们产品的哪些功能？', '2025-08-19 10:00:00+08', 'checkbox'),
  (8, 2, '您认为我们的产品在哪些方面需要改进？', '2025-08-19 10:00:00+08', 'textarea'),
  (9, 2, '您是通过什么渠道了解到我们产品的？', '2025-08-19 10:00:00+08', 'select'),
  (10, 2, '您的年龄范围是？', '2025-08-19 10:00:00+08', 'radio'),
  (11, 3, '您对目前的工作环境满意吗？', '2025-08-20 09:15:00+08', 'radio'),
  (12, 3, '您认为公司哪些福利最有价值？（可多选）', '2025-08-20 09:15:00+08', 'checkbox'),
  (13, 3, '您对公司管理有什么建议？', '2025-08-20 09:15:00+08', 'textarea'),
  (14, 3, '您所在的部门是？', '2025-08-20 09:15:00+08', 'select'),
  (15, 3, '您的工作年限是？', '2025-08-20 09:15:00+08', 'radio'),
  (16, 4, '您目前使用的手机品牌是？', '2025-08-21 13:00:00+08', 'text'),
  (17, 4, '您每天使用手机的时间大约是？', '2025-08-21 13:00:00+08', 'radio'),
  (18, 4, '您最常使用的手机功能有哪些？（可多选）', '2025-08-21 13:00:00+08', 'checkbox'),
  (19, 4, '您购买手机时最看重的因素是？', '2025-08-21 13:00:00+08', 'select'),
  (20, 4, '您对目前使用的手机有什么不满意的地方？', '2025-08-21 13:00:00+08', 'textarea')
ON CONFLICT (id) DO UPDATE
SET title = EXCLUDED.title
WHERE question.title LIKE '%?%' OR question.title LIKE '%�%';

INSERT INTO "option" (id, question_id, survey_id, content, create_time, option_id)
VALUES
  (7, 6, 2, '非常满意', '2025-08-19 10:00:00+08', 0),
  (8, 6, 2, '满意', '2025-08-19 10:00:00+08', 1),
  (9, 6, 2, '一般', '2025-08-19 10:00:00+08', 2),
  (10, 6, 2, '不满意', '2025-08-19 10:00:00+08', 3),
  (11, 6, 2, '非常不满意', '2025-08-19 10:00:00+08', 4),
  (12, 7, 2, '功能A', '2025-08-19 10:00:00+08', 0),
  (13, 7, 2, '功能B', '2025-08-19 10:00:00+08', 1),
  (14, 7, 2, '功能C', '2025-08-19 10:00:00+08', 2),
  (15, 7, 2, '功能D', '2025-08-19 10:00:00+08', 3),
  (16, 9, 2, '朋友推荐', '2025-08-19 10:00:00+08', 0),
  (17, 9, 2, '社交媒体', '2025-08-19 10:00:00+08', 1),
  (18, 9, 2, '搜索引擎', '2025-08-19 10:00:00+08', 2),
  (19, 9, 2, '广告', '2025-08-19 10:00:00+08', 3),
  (20, 10, 2, '18岁以下', '2025-08-19 10:00:00+08', 0),
  (21, 10, 2, '18-25岁', '2025-08-19 10:00:00+08', 1),
  (22, 10, 2, '26-35岁', '2025-08-19 10:00:00+08', 2),
  (23, 10, 2, '36-45岁', '2025-08-19 10:00:00+08', 3),
  (24, 10, 2, '46岁及以上', '2025-08-19 10:00:00+08', 4),
  (25, 11, 3, '非常满意', '2025-08-20 09:15:00+08', 0),
  (26, 11, 3, '满意', '2025-08-20 09:15:00+08', 1),
  (27, 11, 3, '一般', '2025-08-20 09:15:00+08', 2),
  (28, 11, 3, '不满意', '2025-08-20 09:15:00+08', 3),
  (29, 11, 3, '非常不满意', '2025-08-20 09:15:00+08', 4),
  (30, 12, 3, '医疗保险', '2025-08-20 09:15:00+08', 0),
  (31, 12, 3, '年假', '2025-08-20 09:15:00+08', 1),
  (32, 12, 3, '培训机会', '2025-08-20 09:15:00+08', 2),
  (33, 12, 3, '弹性工作制', '2025-08-20 09:15:00+08', 3),
  (34, 12, 3, '年终奖金', '2025-08-20 09:15:00+08', 4),
  (35, 14, 3, '技术部', '2025-08-20 09:15:00+08', 0),
  (36, 14, 3, '市场部', '2025-08-20 09:15:00+08', 1),
  (37, 14, 3, '人力资源部', '2025-08-20 09:15:00+08', 2),
  (38, 14, 3, '财务部', '2025-08-20 09:15:00+08', 3),
  (39, 14, 3, '销售部', '2025-08-20 09:15:00+08', 4),
  (40, 15, 3, '1年以下', '2025-08-20 09:15:00+08', 0),
  (41, 15, 3, '1-3年', '2025-08-20 09:15:00+08', 1),
  (42, 15, 3, '3-5年', '2025-08-20 09:15:00+08', 2),
  (43, 15, 3, '5年以上', '2025-08-20 09:15:00+08', 3),
  (44, 17, 4, '1小时以下', '2025-08-21 13:00:00+08', 0),
  (45, 17, 4, '1-3小时', '2025-08-21 13:00:00+08', 1),
  (46, 17, 4, '3-5小时', '2025-08-21 13:00:00+08', 2),
  (47, 17, 4, '5小时以上', '2025-08-21 13:00:00+08', 3),
  (48, 18, 4, '社交媒体', '2025-08-21 13:00:00+08', 0),
  (49, 18, 4, '游戏', '2025-08-21 13:00:00+08', 1),
  (50, 18, 4, '视频/音乐', '2025-08-21 13:00:00+08', 2),
  (51, 18, 4, '工作/学习', '2025-08-21 13:00:00+08', 3),
  (52, 18, 4, '购物', '2025-08-21 13:00:00+08', 4),
  (53, 19, 4, '价格', '2025-08-21 13:00:00+08', 0),
  (54, 19, 4, '品牌', '2025-08-21 13:00:00+08', 1),
  (55, 19, 4, '性能', '2025-08-21 13:00:00+08', 2),
  (56, 19, 4, '外观设计', '2025-08-21 13:00:00+08', 3),
  (57, 19, 4, '摄像头质量', '2025-08-21 13:00:00+08', 4)
ON CONFLICT (id) DO UPDATE
SET content = EXCLUDED.content
WHERE "option".content LIKE '%?%' OR "option".content LIKE '%�%';

INSERT INTO answer (id, source_type, source_ip, answer, survey_id, create_time)
VALUES
  (2, 1, '192.168.1.100', '[{"question":"您对我们的产品整体满意度如何？","answer":"满意"},{"question":"您最常使用我们产品的哪些功能？","answer":"功能A,功能C"},{"question":"您认为我们的产品在哪些方面需要改进？","answer":"希望增加更多的自定义选项，界面可以更简洁一些"},{"question":"您是通过什么渠道了解到我们产品的？","answer":"朋友推荐"},{"question":"您的年龄范围是？","answer":"26-35岁"}]', 2, '2025-08-19 11:30:45+08'),
  (3, 2, '203.156.34.12', '[{"question":"您对我们的产品整体满意度如何？","answer":"非常满意"},{"question":"您最常使用我们产品的哪些功能？","answer":"功能B,功能D"},{"question":"您认为我们的产品在哪些方面需要改进？","answer":"暂无"},{"question":"您是通过什么渠道了解到我们产品的？","answer":"社交媒体"},{"question":"您的年龄范围是？","answer":"18-25岁"}]', 2, '2025-08-19 14:22:18+08'),
  (4, 2, '10.0.0.45', '[{"question":"您对目前的工作环境满意吗？","answer":"满意"},{"question":"您认为公司哪些福利最有价值？（可多选）","answer":"医疗保险,年假,培训机会"},{"question":"您对公司管理有什么建议？","answer":"希望能有更多的团队建设活动"},{"question":"您所在的部门是？","answer":"技术部"},{"question":"您的工作年限是？","answer":"1-3年"}]', 3, '2025-08-20 10:30:22+08'),
  (5, 2, '10.0.0.78', '[{"question":"您对目前的工作环境满意吗？","answer":"非常满意"},{"question":"您认为公司哪些福利最有价值？（可多选）","answer":"弹性工作制,年终奖金"},{"question":"您对公司管理有什么建议？","answer":"无"},{"question":"您所在的部门是？","answer":"市场部"},{"question":"您的工作年限是？","answer":"3-5年"}]', 3, '2025-08-20 11:45:10+08'),
  (6, 2, '10.0.0.112', '[{"question":"您对目前的工作环境满意吗？","answer":"一般"},{"question":"您认为公司哪些福利最有价值？（可多选）","answer":"培训机会,弹性工作制"},{"question":"您对公司管理有什么建议？","answer":"希望能有更清晰的晋升路径"},{"question":"您所在的部门是？","answer":"人力资源部"},{"question":"您的工作年限是？","answer":"5年以上"}]', 3, '2025-08-20 15:20:33+08'),
  (7, 1, '172.56.23.89', '[{"question":"您目前使用的手机品牌是？","answer":"Apple"},{"question":"您每天使用手机的时间大约是？","answer":"3-5小时"},{"question":"您最常使用的手机功能有哪些？（可多选）","answer":"社交媒体,视频/音乐,购物"},{"question":"您购买手机时最看重的因素是？","answer":"性能"},{"question":"您对目前使用的手机有什么不满意的地方？","answer":"电池续航时间不够长"}]', 4, '2025-08-21 14:30:45+08'),
  (8, 1, '172.56.24.12', '[{"question":"您目前使用的手机品牌是？","answer":"Samsung"},{"question":"您每天使用手机的时间大约是？","answer":"5小时以上"},{"question":"您最常使用的手机功能有哪些？（可多选）","answer":"游戏,视频/音乐"},{"question":"您购买手机时最看重的因素是？","answer":"摄像头质量"},{"question":"您对目前使用的手机有什么不满意的地方？","answer":"偶尔会卡顿"}]', 4, '2025-08-21 16:45:22+08'),
  (9, 2, '203.45.67.89', '[{"question":"您目前使用的手机品牌是？","answer":"Huawei"},{"question":"您每天使用手机的时间大约是？","answer":"1-3小时"},{"question":"您最常使用的手机功能有哪些？（可多选）","answer":"工作/学习"},{"question":"您购买手机时最看重的因素是？","answer":"价格"},{"question":"您对目前使用的手机有什么不满意的地方？","answer":"应用商店可选应用较少"}]', 4, '2025-08-21 18:20:33+08')
ON CONFLICT (id) DO UPDATE
SET answer = EXCLUDED.answer
WHERE answer.answer LIKE '%?%' OR answer.answer LIKE '%�%';

SELECT setval(pg_get_serial_sequence('ot_questplatform."user"', 'id'), COALESCE((SELECT MAX(id) FROM "user"), 1), true);
SELECT setval(pg_get_serial_sequence('ot_questplatform.survey', 'id'), COALESCE((SELECT MAX(id) FROM survey), 1), true);
SELECT setval(pg_get_serial_sequence('ot_questplatform.question', 'id'), COALESCE((SELECT MAX(id) FROM question), 1), true);
SELECT setval(pg_get_serial_sequence('ot_questplatform."option"', 'id'), COALESCE((SELECT MAX(id) FROM "option"), 1), true);
SELECT setval(pg_get_serial_sequence('ot_questplatform.answer', 'id'), COALESCE((SELECT MAX(id) FROM answer), 1), true);
