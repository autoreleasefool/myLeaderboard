import { Board } from "../lib/types";
import Table from "./table";

class Boards extends Table<Board> {
    public static getInstance(): Boards {
        if (Boards.instance == null) {
            Boards.instance = new Boards();
        }

        return Boards.instance;
    }

    private static instance: Boards | null;

    private constructor() {
        super('boards');
    }

    public isNameTaken(name: string): boolean {
        for (const board of this.all({first: -1, offset: 0})) {
            if (board.boardName === name) {
                return true;
            }
        }

        return false;
    }
}

export default Boards;
