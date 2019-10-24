# Sample app catalog

**Warning:** this documentation is obsolete and staying here for historic and backward compatibility reasons. Please [read here](https://github.com/giantswarm/giantswarm/blob/master/processes/appcatalog.md) for current info about how to setup an app catalog.

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

# Setting up a new App-Catalog
1. Create a new Repo on Github
2. Run `helm repo index .` in the root directory and commit the resulting `index.yaml`.
3. Enable GitHub Pages for the master branch.
4. Add Taylor Bot with `write` permissions to the repository.
5. Set up project on circleci.com and copy Environment Variables from
   `giantswarm/sample-catalog`.
5. Commit the `.circleci/config.yml` and `ci-scripts/package.sh` files from
   `giantswarm/sample-catalog` and adjust to your needs.

# Release process
## Pull-based

The app-catalog defines the managed apps that it contains.
The app-catalog queries the GitHub releases of the managed apps on regular bases
and pulls newly released chart-archives into the app-catalog.

**Pros:**
- Centralized information, which managed app currently pushes into which catalog.

**Cons:**
- Need for a CI cron-job that queries available new releases of
  managed apps.
- Delays between releasing a managed app and making it available in
  the app-catalog.
