export function base64decode(encoded: string): string {
    const buffer = Buffer.from(encoded, 'base64');
    return buffer.toString('utf8');
}

export function base64encode(raw: string): string {
    const buffer = Buffer.from(raw, 'utf8');
    return buffer.toString('base64');
}
