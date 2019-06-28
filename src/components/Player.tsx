import React from 'react';
import Octo, { User } from '../utils/Octo';

interface Props {
    username: string;
}

interface State {
    user: User | undefined;
}

class Player extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            user: undefined,
        };
    }

    componentDidMount() {
        Octo.getInstance().user(this.props.username).then(user => {
                this.setState({ user });
            });
    }

    render() {
        const { user } = this.state;
        if (user == null) {
            return <p className={"player-username"}>{this.props.username}</p>;
        }

        return <img src={user.avatar} alt={user.displayName} />;
    }
}