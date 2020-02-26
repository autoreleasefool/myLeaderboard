import express from 'express';
import {graphql, getIntrospectionQuery} from 'graphql';
import graphQLHTTP from 'express-graphql';
import schema from './schema';
import resolvers from './resolvers';

const graphQL = graphQLHTTP({
    schema,
    graphiql: true,
    rootValue: resolvers,
});

const router = express.Router();

router.get('/graphql/introspection', (_, res, next) => {
    let query = getIntrospectionQuery();
    graphql(schema, query, resolvers).then(introspection => {
        res.json(introspection);
    }).catch(error => {
        next(error);
    });
})

export default function applyRouter(app: express.Express): void {
    app.use(router);
    app.use('/graphql', graphQL);
}
