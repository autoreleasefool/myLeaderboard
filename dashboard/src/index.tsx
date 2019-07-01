import { AppProvider } from '@shopify/polaris';
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';
import Octo from './lib/utils/Octo';

Octo.setBranch('react');

ReactDOM.render(
    <AppProvider>
        <App />
    </AppProvider>,
    document.getElementById('root'),
);
