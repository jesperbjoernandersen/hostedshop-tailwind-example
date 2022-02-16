import { subscribe, unsubscribe, publish } from "./PubSub";

/*
 * Transition from one state and event to another
 */
function transition(machine) {
    return function (state, event) {
        const nextStateNode = machine
                .states[state.status]
                .on?.[event.type]
            ?? { target: state.status };

        const nextState = {
            ...nextStateNode,
            status: nextStateNode.target
        };

        publish('transition', nextState);
        jQuery(platform.checkout).trigger('transition', nextState);
    }
}


/*
 * runs the state actions to handle events
 */
function runActions(obj = {}) {
    return function (actions = []) {
        actions.forEach(action => {
            if (action.type && typeof obj[action.type] === 'function') {
                obj[action.type].call(obj, action.action ?? undefined);
            }
        });
    }
}

export {
    transition,
    runActions
};