import { Request } from "express";
import Boards from "../db/boards";
import { Board } from "../lib/types";

export default async function add(req: Request): Promise<Board> {
    const boardName: string = req.body.name;
    return addBoard(boardName);
}

export async function addBoard(boardName: string): Promise<Board> {
    // Input validation
    if (boardName == null || boardName.length === 0) {
        throw new Error('Missing "name".');
    }

    const newBoard = createBoard(boardName);
    Boards.getInstance().add(newBoard, `Adding board "${boardName}`);

    return newBoard;
}

function createBoard(boardName: string): Board {
    if (Boards.getInstance().isNameTaken(boardName)) {
        throw new Error(`A board with the name "${boardName}" already exists.`);
    }

    return {
        id: Boards.getInstance().getNextId(),
        boardName,
    };
}
