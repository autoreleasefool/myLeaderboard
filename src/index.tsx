import React from 'react';
import ReactDOM from 'react-dom';
import { AppProvider } from '@shopify/polaris';
import Dashboard from './dashboard/Dashboard';
import './index.css';

ReactDOM.render(
    <AppProvider>
        <Dashboard />
    </AppProvider>,
    document.getElementById('root')
);
