import { AppProvider } from '@shopify/polaris';
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { getParam } from './common/Params';
import './index.css';
import Octo from './lib/Octo';

Octo.setBranch('react');
Octo.setToken(getParam('token'));

ReactDOM.render(
    <AppProvider>
        <App />
    </AppProvider>,
    document.getElementById('root'),
);
