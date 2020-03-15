import React from 'react';

const majorVersion = 5;
const minorVersion = 0;
const patchVersion = 4;

function Version(): React.ReactElement {
    return <p>{`v${majorVersion}.${minorVersion}.${patchVersion}`}</p>;
}

export default Version;
