import { User } from "./types";
import * as Octokat from "./octokat.js";

export class Octo {
    private static instance: Octo;

    private octo: any;
    private repo: any;

    private constructor() {
        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        this.octo = new Octokat({token: "0c0e108b89e8cfbe1682eb0f030affc8a278cd63"});
        this.repo = this.octo.repos("josephroquedev", "myLeaderboard");
    }

    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo();
        }

        return Octo.instance;
    }

    public static user(name: string): Promise<User> {
        return Octo.getInstance().octo.users(name).fetch();
    }

    public static contents(path: string): Promise<string> {
        return Octo.getInstance().repo.contents(path).read();
    }
}
