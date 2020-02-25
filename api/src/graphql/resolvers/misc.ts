import { anyUpdatesSince } from '../../misc/hasUpdates';

interface HasAnyUpdatesArguments {
    since: Date;
}

export async function resolveHasAnyUpdates({since}: HasAnyUpdatesArguments): Promise<boolean> {
    return anyUpdatesSince(since);
}
