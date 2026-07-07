package com.wjh.quest.service;

import com.wjh.quest.dao.UserMapper;
import com.wjh.quest.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;

    public User login(User user) {
        return userMapper.login(user);
    }

    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Transactional(rollbackFor = Exception.class)
    public int register(User user) {
        return userMapper.register(user);
    }
}
