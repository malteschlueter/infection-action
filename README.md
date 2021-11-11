Run PHP Mutation Testing with Infection in your Github Actions.
==============================================

Infection is a mutation testing framework for PHP.

Usage
-----

Create your Github Workflow configuration in `.github/workflows/ci.yml` or similar.

```yaml
name: CI

on: [push]

jobs:
  build-test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - uses: php-actions/composer@v6 # or alternative dependency management
    - uses: malteschlueter/infection-action@v1
    # ... then your own project steps ...
```

### Version numbers

This action is released with semantic version numbers, but also tagged so the latest major release's tag always points to the latest release within the matching major version.

Please feel free to use `uses: malteschlueter/infection-action@v1` to always run the latest version of v3, or `uses: malteschlueter/infection-action@v1.0.0` to specify the exact release.

Inputs
------

The following configuration options are available:

+ `configuration` Path to the `infection.json` file (default: `test/infection/infection.json`)

The syntax for passing in a custom input is the following:

```yaml
...

jobs:
  infection-tests:

    ...

    - name: Infection tests
      uses: malteschlueter/infection-action@v1
      with:
        configuration: custom/path/to/infection.json
```

If you require other configurations of infection, please request them in the [Github issue tracker][issues]
