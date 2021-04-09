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
        const lowerName = name.toLowerCase()
        for (const board of this.all({first: -1, offset: 0})) {
            if (board.boardName.toLowerCase() === lowerName) {
                return true;
            }
        }

        return false;
    }

    public findByName(name: string): Board | undefined {
        const lowerName = name.toLowerCase()
        for (const board of this.all({first: -1, offset: 0})) {
            if (board.boardName.toLowerCase() === lowerName) {
                return board;
            }
        }

        return undefined;
    }
}

export default Boards;
