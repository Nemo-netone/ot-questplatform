package com.wjh.quest.service;

import com.wjh.quest.dao.OptionMapper;
import com.wjh.quest.dao.QuestionMapper;
import com.wjh.quest.entity.Option;
import com.wjh.quest.entity.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class QuestionService {
    @Autowired
    private QuestionMapper questionMapper;

    @Autowired
    private OptionMapper optionMapper;

    public List<Question> getQuestion(Long surveyId) {
        List<String> list = Arrays.asList("text", "textarea");
        // 获取问题
        List<Question> questions = questionMapper.getBySurveyId(surveyId);
        questions.forEach(question -> {
            // 当问题不为text,textarea时 获取问题选项
            if (!list.contains(question.getType())) {
                List<Option> options = optionMapper.getOptions(surveyId, question.getId());
                question.setOptions(options);
            }
        });
        return questions;
    }
}
