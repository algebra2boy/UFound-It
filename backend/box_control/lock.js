// async functions that controlls the lock and unlock of the box
// sample usage:
// const lock = require('./lock');
// result = await lock.lock("dropbox_number_one");
// result = await lock.unlock("dropbox_number_one");

async function unlock(boxId="dropbox_number_one") {
    try {
        const response = await fetch(`https://ubox.zhiyang.duckdns.org/api/control/unlock?clientId=${boxId}`, {
            method: 'POST',
        });
        if (response.status === 200) {
            return "ok";
        } else if (response.status === 400) {
            return "bad request";
        } else if (response.status === 404) {
            return "client not found";
        }
    }catch (error) {
        console.error('Error:', error.message);
    }
}

async function lock(boxId="dropbox_number_one") {
    try {
        const response = await fetch(`https://ubox.zhiyang.duckdns.org/api/control/lock?clientId=${boxId}`, {
            method: 'POST',
        });
        if (response.status === 200) {
            return "ok";
        } else if (response.status === 400) {
            return "bad request";
        } else if (response.status === 404) {
            return "client not found";
        }
    }catch (error) {
        console.error('Error:', error.message);
    }
}

module.exports = {
    lock,
    unlock
}