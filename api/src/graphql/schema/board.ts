import {
    GraphQLID,
    GraphQLNonNull,
    GraphQLObjectType,
    GraphQLString,
} from 'graphql';
import { Board } from "../../lib/types";

export default new GraphQLObjectType<Board, void, {}>({
    name: 'Board',
    description: 'Board from the MyLeaderboard API.',
    // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
            description: 'Unique ID.',
        },
        boardName: {
            type: GraphQLNonNull(GraphQLString),
            description: 'Name of the board.',
        },
    }),
});
