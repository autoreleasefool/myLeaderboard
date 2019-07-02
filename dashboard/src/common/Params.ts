export function getParam(key: string): string | undefined {
    if (window.URLSearchParams == null) {
        return undefined;
    }

    const urlParams = new window.URLSearchParams(window.location.search);
    const value = urlParams.get(key);
    return (value != null) ? value : undefined;
}
