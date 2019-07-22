import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';

export default async function refresh() {
    await Games.getInstance().refreshData();
    await Players.getInstance().refreshData();
    await Plays.getInstance().refreshData();
}
