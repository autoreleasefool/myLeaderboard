export function getParam(key: string): string {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(key);
}

export function getCurrentPage(): string {
    const fullPath = window.location.pathname;
    const components = fullPath.split("/");
    return components[components.length - 1];
}
