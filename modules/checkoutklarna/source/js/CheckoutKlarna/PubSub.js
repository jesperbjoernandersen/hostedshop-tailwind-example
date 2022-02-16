let topics = {}, subUid = -1;
function subscribe(topic, func) {
    if (!topics[topic]) {
        topics[topic] = [];
    }
    const token = (++subUid).toString();
    topics[topic].push({
        token: token,
        func: func
    });
    return token;
}

function publish(topic, args) {
    if (!topics[topic]) {
        return false;
    }
    setTimeout(function() {
        let subscribers = topics[topic],
            len = subscribers ? subscribers.length : 0;

        while (len--) {
            subscribers[len].func(topic, args);
        }
    }, 0);
    return true;

}

function unsubscribe(token) {
    for (let m in topics) {
        if (topics[m]) {
            let i = 0, j = topics[m].length;
            for (; i < j; i++) {
                if (topics[m][i].token === token) {
                    topics[m].splice(i, 1);
                    return token;
                }
            }
        }
    }
    return false;
}

export {
    subscribe,
    publish,
    unsubscribe
}