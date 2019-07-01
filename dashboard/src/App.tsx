import React from 'react';
import Dashboard from './dashboard/Dashboard';
import Octo, { Player } from './lib/utils/Octo';

interface State {
    players: Array<Player>;
}

class App extends React.Component<{}, State> {
    constructor(props: {}) {
        super(props);
        this.state = {
            players: [],
        };
    }

    public componentDidMount() {
        Octo.getInstance().players().then(players => {
            this.setState( { players });
        });
    }

    public render() {
        return (
            <div>
                <Dashboard players={this.state.players} />
            </div>
        );
    }
}

export default App;
