# Template

Use this as a template to get started with Flood.

## Initialization 

Here are the steps to use this as a baseline for your project:

1. Come up with a name for the project. It will be represented as {{NAME}} in the file examples
   below.
2. Rename the `template` directory to {{NAME}} and `template_core` to {{NAME}}_core.
3. In pubspec.yaml, replace `template` with {{NAME}}.
4. In {{NAME}}/pubspec.yaml, replace `template` with {{NAME}}.
5. In {{NAME}}_core/pubspec.yaml, replace `template` with {{NAME}}.
6. In melos.yaml, replace all `template`s with {{NAME}} and set the `repository` to the url of your Github repository.
7. Replace every instance of `package:template_core/` with `package:{{NAME}}_core/`.
8. In {{NAME}}_core/tool/automate.dart, replace `Directory.current.parent / 'template'`
   with `Directory.current.parent / '{{NAME}}'` and `coreDirectory.parent / 'template'`
   with `coreDirectory.parent / '{{NAME}}'.
9. Replace every instance of `com.example.template` with your app identifier.
10. Search for `TODO` across the project to find what steps you should take to customize the project.

## Workflow

### Setup

[Melos](https://melos.invertase.dev/) is a tool designed to manage Dart and Flutter projects with multiple packages, especially suited for big projects or projects which share common code across multiple apps.

To install Melos:
```
flutter pub global activate melos
```
Ensure your global pub cache is in your path, so you can run the `melos` command anywhere.

### Packaging

Bootstrapping in Melos is analogous to running flutter pub get for a regular Flutter project. While flutter pub get fetches and installs all the dependencies for a single Flutter project, Melos' bootstrapping process does something similar but on a larger scale for multi-package projects. It sets up your development environment by interlinking local package dependencies and populating them with their respective dependencies. This is especially useful for developing multiple interdependent packages within the same repository, ensuring they work seamlessly together.

To bootstrap your project with Melos, simply run:
```
melos bs
```

### Testing

Testing your multi-package projects is simplified using Melos. Instead of running tests for each package individually, Melos can run them all at once.

To test your packages using Melos:
```
melos test
```

It will execute tests for all the packages in your project. Make sure you've bootstrapped your project before testing.