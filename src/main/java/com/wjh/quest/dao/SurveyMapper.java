package com.wjh.quest.dao;

import com.wjh.quest.entity.Survey;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SurveyMapper {
    List<Survey> get(@Param("isDelete") int isDelete, @Param("title") String title);

    int updateStatus(@Param("id") Long id, @Param("status") int status);

    int updateTitle(@Param("id") Long id, @Param("title") String title);

    int removeById(long id);

    int getStatus(Long id);

    int restoreById(long id);

    Survey getById(Long id);

    int insert(Survey survey);

    int deleteById(Long id);
}
