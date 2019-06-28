import { getParam } from './Params';
import * as Octokat from '../_deps/octokat';

export interface User {
    username: string;
    displayName: string;
    avatar: string;
}

interface GitHubUser {
    login: string;
    avatarUrl: string;
    name: string;
}

class Octo {
    private static instance: Octo;

    private octo: any;
    private repo: any;

    private constructor() {
        const token = getParam('token');

        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        this.octo = new Octokat({ token });
        this.repo = this.octo.repos("josephroquedev", "myLeaderboard");
    }

    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo();
        }

        return Octo.instance;
    }

    // Users

    async user(name: string): Promise<User> {
        if (name.charAt(0) === "@") {
            name = name.substr(1);
        }

        let user: GitHubUser = await this.octo.users(name).fetch();
        return {
            username: user.login,
            avatar: user.avatarUrl,
            displayName: user.name,
        };
    }
}

export default Octo;
