import { Banner, Card, Page } from '@shopify/polaris';
import React from 'react';
import Octo from '../utils/Octo';

interface Props {
    refreshTime: number;
}

interface State {
    errorMessage: string | undefined;
}

class RefreshView extends React.Component<Props, State> {
    private refreshInterval: number | undefined = undefined;
    private startTime: Date;

    constructor(props: Props) {
        super(props);
        this.startTime = new Date();
        this.state = {
            errorMessage: 'This is an error',
        };
    }

    public componentDidMount() {
        this._startRefreshLoop();
    }

    public render() {
        const { errorMessage } = this.state;
        if (errorMessage == null) {
            return null;
        }

        return (
            <Page title=''>
                <Card>
                    <Banner title={'Failed to refresh'} onDismiss={() => this._startRefreshLoop()} status={'critical'}>
                        <p>{errorMessage}</p>
                    </Banner>
                </Card>
            </Page>
        );
    }

    private _startRefreshLoop() {
        if (this.state.errorMessage != null) {
            this.setState({ errorMessage: undefined });
        }

        if (this.refreshInterval != null) {
            window.clearInterval(this.refreshInterval);
        }

        this.refreshInterval = window.setInterval(() => this._refreshLoop(), this.props.refreshTime);
    }

    private async _refreshLoop() {
        try {
            const commits = await Octo.getInstance().commits(this.startTime);
            if (commits.length > 0) {
                window.location.reload();
            }
        } catch (error) {
            this.setState({ errorMessage: `${error}` });

        }
    }
}

export default RefreshView;
