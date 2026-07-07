package com.wjh.quest.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Answer {
    private long id;
    private long surveyId;
    private int sourceType;
    private String sourceIp;
    private String answer;
    private Date createTime; // 注意要导入java.util.Date
}