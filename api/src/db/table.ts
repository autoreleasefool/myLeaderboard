import Octo, { Blob } from '../common/Octo';
import { Identifiable } from '../lib/types';

export interface ListArguments<Row extends Identifiable> {
    first: number;
    offset: number;
    reverse?: boolean;
    filter?: (row: Row) => void;
}

class Table<Row extends Identifiable> {
    private tableName: string;
    private path: string;
    private blob: Blob | undefined;
    private blobOutdated = true;
    private latestUpdate = new Date();
    private rows: Array<Row> = [];
    private rowsById: { [key: number]: Row } = {};

    constructor(tableName: string) {
        this.tableName = tableName;
        this.path = `db/${tableName}.json`;
    }

    public async refreshData(): Promise<void> {
        this.blob = await Octo.getInstance().blob(this.path);
        this.blobOutdated = false;

        const unsortedRows: Array<Row> = JSON.parse(this.blob.content);
        this.rows = unsortedRows.sort((first, second) => first.id - second.id);
        for (const row of this.rows) {
            this.rowsById[row.id] = row;
        }
        this.latestUpdate = new Date();
    }

    public getTableName(): string {
        return this.tableName;
    }

    public getNextId(): number {
        if (this.rows.length === 0) {
            return 0;
        }

        return this.rows[this.rows.length - 1].id + 1;
    }

    public all({first, offset, reverse, filter}: ListArguments<Row>): Array<Row> {
        let rows = reverse ? [...this.rows].reverse() : this.rows;
        rows = filter ? rows.filter(filter) : rows;
        if (first < 0) {
            return rows.slice(offset);
        }
        return rows.slice(offset, offset + first);
    }

    public allIds(args: ListArguments<Row>): Array<number> {
        return this.all(args).map(row => row.id);
    }

    public anyUpdatesSince(date: Date): boolean {
        return date < this.latestUpdate;
    }

    public findById(id: number): Row | undefined {
        return this.rowsById[id];
    }

    public allByIds(ids: readonly number[]): Array<Row> {
        const result: Array<Row> = [];
        for (const id of ids) {
            result.push(this.rowsById[id]);
        }
        return result;
    }

    public async add(row: Row, message?: string): Promise<void> {
        this.rows.push(row);
        this.rowsById[row.id] = row;

        if (message == null) {
            message = `Adding row ${row.id}`;
        }

        if (this.blobOutdated) {
            await this.refreshData();
        }

        this.latestUpdate = new Date();

        return Octo.getInstance().write([{
            content: this.stringifyRows(),
            message,
            path: this.path,
            sha: (this.blob != null) ? this.blob.sha : undefined,
        }]).then(() => {
            this.blobOutdated = true;
        });
    }

    private stringifyRows(): string {
        const stringifiedRows: Array<string> = [];
        for (const row of this.rows) {
            stringifiedRows.push(`    ${JSON.stringify(row)}`);
        }

        let output = '[\n';
        output += stringifiedRows.join(',\n');
        output += '\n]';
        return output;
    }
}

export default Table;
