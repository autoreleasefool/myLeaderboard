import Octo, { Blob } from '../common/Octo';
import { Identifiable } from '../lib/types';

export interface ListArguments {
    first?: number;
    offset?: number;
}

class Table<Row extends Identifiable> {
    private tableName: string;
    private path: string;
    private blob: Blob | undefined;
    private blobOutdated = true;
    private latestUpdate = new Date();
    private rows: Array<Row> = [];

    constructor(tableName: string) {
        this.tableName = tableName;
        this.path = `db/${tableName}.json`;
    }

    public async refreshData(): Promise<void> {
        this.blob = await Octo.getInstance().blob(this.path);
        this.blobOutdated = false;

        const unsortedRows: Array<Row> = JSON.parse(this.blob.content);
        this.rows = unsortedRows.sort((first, second) => first.id - second.id);
        this.latestUpdate = new Date();
    }

    public getTableName(): string {
        return this.tableName;
    }

    public all({first = 25, offset = 0}: ListArguments): Array<Row> {
        return this.rows.slice(offset, offset + first);
    }

    public anyUpdatesSince(date: Date): boolean {
        return date < this.latestUpdate;
    }

    public findById(id: number): Row | undefined {
        let low = 0;
        let high = this.rows.length - 1;

        while (low <= high) {
            const mid = Math.floor((low + high) / 2);
            const currentId = this.rows[mid].id;
            if (currentId === id) {
                return this.rows[mid];
            } else if (currentId < id) {
                low = mid + 1;
            } else if (currentId > id) {
                high = mid - 1;
            }
        }

        return undefined;
    }

    public allByIds(ids: Array<number>): Array<Row> {
        const idSet = new Set(ids);
        return this.rows.filter(row => idSet.has(row.id));
    }

    public async add(row: Row, message?: string): Promise<void> {
        this.rows.push(row);

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
