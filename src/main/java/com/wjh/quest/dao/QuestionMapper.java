package com.wjh.quest.dao;

import com.wjh.quest.entity.Question;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface QuestionMapper {
    List<Question> getBySurveyId(Long surveyId);

    int insert(Question question);

    int deleteBySurveyId(Long surveyId);
}
