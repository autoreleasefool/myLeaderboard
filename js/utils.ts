export function getParam(key: string): string {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(key);
}

export function getCurrentPage(): string {
    const fullPath = window.location.pathname;
    const components = fullPath.split("/");
    return components[components.length - 1];
}

export function nameSort(first: string, second: string): number {
    return first.toLowerCase().localeCompare(second.toLowerCase());
}
