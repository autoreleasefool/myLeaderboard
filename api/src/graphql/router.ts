import express from 'express';
import graphQLHTTP from 'express-graphql';
import schema from './schema';
import resolvers from './resolvers';

const router = graphQLHTTP({
    schema,
    graphiql: true,
    rootValue: resolvers,
});

export default function applyRouter(app: express.Express): void {
    app.use('/graphql', router);
}
