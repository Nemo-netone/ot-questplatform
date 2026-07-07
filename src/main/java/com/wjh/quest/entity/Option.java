package com.wjh.quest.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Option {
    private long id;
    private long questionId;
    private long surveyId;
    private long optionId;
    private String content;
    private Date createTime; // 注意要导入java.util.Date
}
