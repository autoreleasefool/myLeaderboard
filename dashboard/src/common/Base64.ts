export function base64decode(encoded: string): string {
    return atob(encoded);
}

export function base64encode(raw: string): string {
    return btoa(raw);
}
