import express from 'express';
import { graphql, getIntrospectionQuery } from 'graphql';
import graphQLHTTP from 'express-graphql';
import schema from './schema';
import resolvers from './resolvers';
import Loader from './dataloader';

const graphQL = graphQLHTTP(_ => ({
    schema,
    graphiql: true,
    context: { loader: Loader() },
}));

const router = express.Router();

router.get('/graphql/introspection', (_, res, next) => {
    const query = getIntrospectionQuery();
    graphql(schema, query, resolvers).then(introspection => {
        res.json(introspection);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: express.Express): void {
    app.use(router);
    app.use('/graphql', graphQL);
}
