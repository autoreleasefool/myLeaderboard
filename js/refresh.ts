import { Octo } from "./octo";

const REFRESH_TIME = 20 * 1000;
let startTime: Date;

export function startRefreshLoop() {
    startTime = new Date();
    setInterval(refreshLoop, REFRESH_TIME);
}

async function refreshLoop() {
    try {
        let commits = await Octo.commits(startTime);
        if (commits.length > 0) {
            location.reload();
        }
    } catch(error) {
        console.log(error);
    }
}
