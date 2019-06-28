import React from 'react';
import Octo, { Player } from './utils/Octo';
import Dashboard from './dashboard/Dashboard';

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

    componentDidMount() {
        Octo.getInstance().players().then(players => {
            this.setState( { players });
        })
    }

    render() {
        return (
            <div>
                <Dashboard players={this.state.players} />
            </div>
        );
    }
}

export default App;
