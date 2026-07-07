package com.wjh.quest.dao;

import com.wjh.quest.entity.Option;
import com.wjh.quest.entity.Question;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OptionMapper {
    List<Option> getOptions(@Param("surveyId") Long surveyId,
                            @Param("questionId") long questionId);

    int insert(Option option);

    int deleteBySurveyId(Long surveyId);
}
