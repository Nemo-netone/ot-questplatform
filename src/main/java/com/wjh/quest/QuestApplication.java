package com.wjh.quest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.wjh.quest.dao")
public class QuestApplication {

    public static void main(String[] args) {
        SpringApplication.run(QuestApplication.class, args);
    }

}
