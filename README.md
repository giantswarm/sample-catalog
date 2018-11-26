# Sample app catalog

Sample app-catalog for internal GS Test Purposes.

Serves a helm repository using GitHub Pages.

For further info about helm chart repositories see: https://github.com/helm/helm/blob/master/docs/chart_repository.md.

The app-catalog is hosted at the URL: https://giantswarm.github.com/sample-catalog.

It can be added to your helm repositories like this:

``` sh
> helm repo add sample-catalog https://giantswarm.github.com/sample-catalog
"sample-catalog" has been added to your repositories
```

Install an app from the sample-catalog:

``` sh
> helm install sample-catalog/kubernetes-test-app-chart
```

# Release process

There are two possibilites to release apps within the app-catalog.

## Push-based

Each managed app defines the catalogs it pushes to. That results in a
developer creating a GitHub release of the managed app and also pushing the
chart archive to each app-catalog repository.

**Pros:**
- Fast release flow. Pushing to the charts to app-catalogs gets directly
  triggered by an release of the managed app.

**Cons:**
- GitHub write permissions to the app-catalog repos needed for every managed app.
- Decrentralized information, which managed app currently pushes to which catalog.


## Pull-based

Each app-catalog defines the managed apps that it contains.
The app-catalog queries the GitHub releases of the managed apps on regular bases
and pulls newly released chart-archives into the app-catalog.

**Pros:**
- Centralized information, which managed app currently pushes into which catalog.

**Cons:**
- Need for some kind of CI cron-job that queries available new releases of
  managed apps.
- Delays between releasing a managed app and making it available in
  the app-catalog.
