layui.define(['jquery', 'layer'], function(exports) {
    var $ = layui.$;
    var layer = layui.layer;

    var userModule = {
        // 初始化用户显示
        initUserDisplay: function() {
            const username = localStorage.getItem('username');
            if (username) {
                $('#username-display').text('欢迎，' + username);
                $('#auth-btn').html('<i class="layui-icon">&#xe65a;</i> 退出');
            } else {
                $('#username-display').text('');
                $('#auth-btn').html('<i class="layui-icon">&#xe66f;</i> 登录');
            }
        },

        // 处理登录/退出
        setupAuthButton: function() {
            $('#auth-btn').on('click', function() {
                const username = localStorage.getItem('username');

                if (username) {
                    userModule.logoutUser(username);
                } else {
                    window.location.href = '../page/login.html';
                }
            });
        },

        // 用户退出
        logoutUser: function(username) {
            layer.confirm('确定要退出登录吗？', {
                icon: 3,
                title: '提示'
            }, function(index) {
                $.ajax({
                    url: QuestConfig.apiUrl('/user/logout'),
                    type: 'POST',
                    headers: QuestConfig.authHeaders(),
                    contentType: 'application/json',
                    data: JSON.stringify({}),
                    success: function(res) {
                        layer.close(index);
                        if (res.code === 200) {
                            layer.msg('退出登录成功', {icon: 1});
                            localStorage.removeItem('username');
                            localStorage.removeItem('authToken');
                            window.location.reload();
                        } else {
                            layer.msg(res.msg || '退出登录失败', {icon: 2});
                        }
                    },
                    error: function() {
                        layer.close(index);
                        layer.msg('网络错误，请稍后再试', {icon: 2});
                    }
                });
            });
        },

        // 检查用户登录状态
        checkLogin: function() {
            if (!localStorage.getItem('username') || !localStorage.getItem('authToken')) {
                window.location.href = '../page/login.html';
                return false;
            }
            return true;
        }
    };

    // 导出模块
    exports('user', userModule);
});
