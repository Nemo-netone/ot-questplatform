package com.wjh.quest.dao;

import com.wjh.quest.entity.Answer;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AnswerMapper {
    int getCountBySurveyId(long surveyId);

    int insert(Answer answer);

    List<Answer> list(Long surveyId);
}
