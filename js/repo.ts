import * as Octokat from "./octokat.js";

export class Repo {
    private static instance: Repo;

    private repo: any;

    private constructor() {
        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        let octo = new Octokat({token: "0c0e108b89e8cfbe1682eb0f030affc8a278cd63"});
        this.repo = octo.repos("josephroquedev", "myLeaderboard");
    }

    public static getInstance(): Repo {
        if (Repo.instance == null) {
            Repo.instance = new Repo();
        }

        return Repo.instance;
    }

    public static contents(path: string): Promise<string> {
        return Repo.getInstance().repo.contents(path).read();
    }
}
