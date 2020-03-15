# myLeaderboard
iLeaderboard, meet myLeaderboard

## Getting Started

### API

1. `cd api`
2. `yarn`
3. `yarn start`
4. The console will start an ngrok instance and provide a URL which tunnels to your local instance. You should be able to hit the various endpoints from here.
5. You'll probably want to update `api/.env` with a [GitHub API Token](https://github.com/settings/tokens) so you aren't rate limited while testing.
6. Check out the [API Reference](/api/README.md)
7. GraphQL endpoints are also available. With the server running, you can use [GraphiQL](http://localhost:3001/graphql)

### Dashboard

1. Follow steps to set up a local instance of the API. This will update `dashboard/src/api/LeaderboardAPI.ts` with the URL for your ngrok instance automatically.
2. `cd dashboard`
3. `yarn`
4. `yarn start`
5. The dashboard will be available at `localhost:3000`

### iOS

1. Follow the steps to set up a local instance of the API. This will update `ios/MyLeaderboard/MyLeaderboard/Source/API/MyLeaderboardAPI.swift` with the URL for your ngrok instance automatically.
2. `cd ios`
3. If you are modifying queries, use `./generate_api` to run [Syrup](https://github.com/Shopify/Syrup) and regenerate the models.

## Requirements

### API

* node 10.15+
* yarn 1.16+
* ngrok

### Dashboard

* yarn 1.16+

### iOS

* Swift 5.0+
* swiftLint

## Contributing

Clone the repo and follow the steps below for the component you're interested in contributing to:

### API


1. Make your changes and run `yarn lint` to ensure there are no lint issues.
2. Open a PR with your changes (don't include ngrok URLs) 🎉

### Dashboard


1. Make your changes and run `yarn lint` to ensure there are no lint issues.
2. `yarn build`
3. Open a PR with your changes (include all `site` changes) 🎉

### iOS


1. Make your changes and run `swiftlint` to ensure there are no lint issues.
2. Open a PR with your changes 🎉
