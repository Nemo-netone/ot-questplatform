package com.wjh.quest.service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wjh.quest.dao.AnswerMapper;
import com.wjh.quest.entity.Answer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AnswerService {
    @Autowired
    private AnswerMapper answerMapper;

    @Transactional(rollbackFor = Exception.class)
    public void insert(JSONObject param) {
        Answer answer = new Answer();
        answer.setSurveyId(param.getLong("surveyId"));
        answer.setSourceIp(param.getString("sourceIp"));
        answer.setSourceType(param.getInteger("sourceType"));
        answer.setAnswer(param.getString("answers"));
        answerMapper.insert(answer);
    }

    public PageInfo<Answer> list(JSONObject param) {
        // 分页
        PageHelper.startPage(param.getIntValue("pageNum"), param.getIntValue("pageSize"));
        // 获取分页问卷
        List<Answer> answers = answerMapper.list(param.getLong("surveyId"));
        return new PageInfo<>(answers);
    }
}
