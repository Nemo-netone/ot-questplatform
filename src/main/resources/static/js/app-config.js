(function(window) {
    var query = new URLSearchParams(window.location.search);
    var queryApiBase = query.get('apiBase');
    var configuredApiBase = window.QUEST_API_BASE_URL || localStorage.getItem('QUEST_API_BASE_URL') || '';

    if (queryApiBase !== null) {
        configuredApiBase = queryApiBase;
        if (queryApiBase) {
            localStorage.setItem('QUEST_API_BASE_URL', queryApiBase);
        } else {
            localStorage.removeItem('QUEST_API_BASE_URL');
        }
    }

    function trimTrailingSlash(value) {
        return value ? value.replace(/\/+$/, '') : '';
    }

    function apiUrl(path) {
        if (/^https?:\/\//.test(path)) {
            return path;
        }
        var base = trimTrailingSlash(configuredApiBase);
        return base + (path.charAt(0) === '/' ? path : '/' + path);
    }

    function getToken() {
        return localStorage.getItem('authToken') || '';
    }

    function authHeaders() {
        var token = getToken();
        return token ? { Authorization: 'Bearer ' + token } : {};
    }

    window.QuestConfig = {
        apiBaseUrl: trimTrailingSlash(configuredApiBase),
        apiUrl: apiUrl,
        getToken: getToken,
        authHeaders: authHeaders
    };
})(window);
