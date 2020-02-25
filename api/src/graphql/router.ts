import express from 'express';
import graphQLHTTP from 'express-graphql'
import schema from './schema'
import root from './graphql'

const router = graphQLHTTP({
    schema,
    graphiql: true,
    rootValue: root,
});

export default function applyRouter(app: express.Express): void {
    // app.use('/plays', router);
    app.use('/graphql', router);
}
