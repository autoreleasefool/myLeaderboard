import Octo, { Blob } from '../common/Octo';
import { Identifiable } from '../lib/types';

class Table<Row extends Identifiable> {
    private tableName: string;
    private path: string;
    private blob: Blob | undefined;
    private blobOutdated: boolean = true;
    private latestUpdate: Date = new Date();
    private rows: Array<Row> = [];

    constructor(tableName: string) {
        this.tableName = tableName;
        this.path = `db/${tableName}.json`;
    }

    public async refreshData() {
        this.blob = await Octo.getInstance().blob(this.path);
        this.blobOutdated = false;

        const unsortedRows: Array<Row> = JSON.parse(this.blob.content);
        this.rows = unsortedRows.sort((first, second) => first.id - second.id);
        this.latestUpdate = new Date();
    }

    public getTableName(): string {
        return this.tableName;
    }

    public all(): Array<Row> {
        return this.rows;
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

    public async add(row: Row, message?: string) {
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
        }]).then(() => this.blobOutdated = true);
    }

    private stringifyRows(): string {
        let output = '[\n';
        for (const row of this.rows) {
            output += JSON.stringify(row);
            output += '\n';
        }
        output += ']';
        return output;
    }
}

export default Table;
