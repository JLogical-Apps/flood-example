# Flood Example - Flood

This is a sample Flutter project built with Flood, which incorporates authentication and database access.

## Key Features

### [Path](https://www.flooddev.com#path)

All routes are type-safe. By defining a `Route` and `AppPage`, you can grab the required properties from a url, ensure they are in the expected type, and provide fallbacks if one is not provided. Take a look at [LoginPage](todo/lib/presentation/pages/auth/login_page.dart) for a simple example. [SignupPage](todo/lib/presentation/pages/auth/signup_page.dart) shows off how you can pass hidden state through routes. [HomePage](todo/lib/presentation/pages/home_page.dart) demonstrates how you can easily add redirects from pages in a composable manner.

### [Environment](https://www.flooddev.com#environment)

Configuration can be overridden by adding a `todo/assets/config.overrides.yaml`. This is primarily useful if you want to override the environment you are running when testing the app.

- `environment: testing`: All data and authentication is handled in-memory. If `testingLoggedIn` in `todo/main.dart` is `true`, a sample user and data will be created when you start the app.
- `environment: device`: All data and authentication is handled in the file-system of the device. That way, data is persisted through sessions. Navigate to `/_debug/device_files` (by long-pressing on the bottom-left of the screen) to view the files on the current device.
- `environment: qa`: All data and authentication is handled through Firebase emulators that must be running on your machine.
- `environment: production`: All data and authentication is handled through Firebase.

### [Port](https://www.flooddev.com#port)

The login and signup forms are are handled entirely through Port. By simply defining the Port models, Flood can generate the UI for those forms automatically.

- **Login**: The `loginPort` at [LoginPage](todo/lib/presentation/pages/auth/login_page.dart) is a form that contains an email and password. `.withDisplayName()` indicates what the field's name should be when the form's UI is auto-generated. `.isNotBlank()` adds validation to ensure users don't submit empty text. `.isEmail()` adds email validation, and adds email auto-complete for that text-field. `.isPassword()` obscures the text. The port's auto-generated UI is used in the `StyledObjectPortBuilder()` widget. The login button submits the port, which ensures all the fields are valid before returning. You can use the return value to get the port's field data.
- **Signup**: The `signupPort` at [SignupPage](todo/lib/presentation/pages/auth/signup_page.dart)
  shows how you can create a Port with initial values. `.isConfirmPassword()` obscures text and also ensures that the value in that field matches the `password` field.

### [Drop](https://www.flooddev.com#drop)

Using Domain-Driven-Design (DDD), all ValueObjects, Entities, and Repositories are stored in the [todo_core/lib/features](todo_core/lib/features) folder.

- `ValueObject` is an immutable object that stores the data of a model. For example, [Todo](todo_core/lib/features/todo/todo.dart) contains a required name, an optional multi-line description, a completed boolean property that defaults to `false` if no value is found in the database (or if a `Todo` is created without explicitly setting `completedProperty`), and a required user property that is a reference to a `UserEntity`. Because `ValueObject`s can be converted to `Port`s to have their create & edit dialogs auto-generated, some additional helpers are attached to some of these properties to help with that process. `.withDisplayName()` indicates the display name of the field. `.multiline()` indicates the text-field should be multiline. `.nullIfBlank()` indicates that if an empty string is received, it should set the property's value to `null`. This helps clean the UI so that you don't need to check for both `null` and `.isEmpty`. `.hidden()` indicates that the field should not be
  visible in the create/edit form. `.withFallback()` indicates what the value of the property should be if no value was found in the source. You can also notice a `creationTime()` property in the `properties`
  method. This adds a `creationTime` field to the documents which stores the server-generated created time of that document.
- `Entity` is a wrapper over a `ValueObject` that has an `id` and represents specifically one document in a database. For example, [TodoEntity](todo_core/lib/features/todo/todo_entity.dart) represents an entity that wraps a `Todo`. You can tap into an entity's life-cycle by implementing `onBeforeSave()`, `onAfterCreate()`, `onBeforeDelete()`, etc.
- `Repository` defines a location for data to be stored. You can set them to specific locations such as memory, device files, or the cloud. Typically, you would want a repository's location to be defined depending on what the current environment is. You would use an `adapting` repository to handle checking the environment. Taking a look at [TodoRepository](todo_core/lib/features/todo/todo_repository.dart), you'll see that it defines a repository for `TodoEntity`s. You need to pass in the `entityTypeName` and `valueObjectTypeName` so that logging works even in minified contexts, and embedded ValueObjects can be correctly resolved. This repository is defined to be in the `todo` path, which means it will be stored in the `todo` collection in Firestore and the `todo` folder in the device. We also define security rules for this repository, which shows that you can only access and modify this repository's data if you are authenticated.

It's one thing to define these data models, it's another to use them effectively in your app. You can query for data by creating `Query`s and use the `useQuery` hook to automatically update your widget whenever any data that matches that query changes. For example, the `todosModel` in [HomePage](todo/lib/presentation/pages/home_page.dart) collects all the current logged-in user's `TodoEntity`s by running this query: `Query.from<TodoEntity>().where(Todo.userField).isEqualTo(loggedInUserId).all()`. Drop will then find the corresponding `Repository` that handles `TodoEntity`s and queries that for the appropriate entities. This is also environment-aware, so if you are in the `device` environment, it will query from the device's file-system, or if you are in the `production` environment, it will query from your Firebase project. By using `useQuery(...)`, every time you create, update, or delete a `TodoEntity`, the hook will update with the latest data. No need for complex state-management
when Drop can take care of these types of re-renders for you!

To create, update, or delete data, grab the `DropCoreContext` from the current `BuildContext` using `context.dropCoreComponent`, and call `.updateEntity()` or `.delete()` accordingly. You can find examples of this in [HomePage](todo/lib/presentation/pages/home_page.dart).

One of Drop's most useful features is that it can auto-generate `Port`s from your `ValueObject`s automatically so you can easily generate create/edit forms for your data. To do this, convert a `ValueObject` into a `Port` using `.asPort()`, and render the port using `StyledPortDialog`. You can see examples of this in [HomePage](todo/lib/presentation/pages/home_page.dart). The form's UI is auto-generated from the properties of the `ValueObject` itself, but it is also flexible for any additional customizations you may need, such as re-ordering fields, removing/adding fields, adding widgets before/after labels, etc.

### [Pond](https://www.flooddev.com#pond)

This app is composed of many smaller components. The core components are defined in [pond.dart](todo_core/lib/pond.dart). `pond.dart` handles defining all the components of your business logic that are used in all contexts of your app, such as Flutter, the CLI, and on a server backend. In this case, `pond.dart` defines a `CorePondContext` which registers a few components such as `EnvironmentConfigCoreComponent` which handles setting all environment variables from the config files, `AuthCoreComponent` which handles authentication, `UserDeviceTokenCoreComponent` which handles grabbing the device's token and saving it to the currently logged in UserEntity, `PortDropCoreComponent` which handles converting Drop `ValueObject`s to `Port`s, all the custom `Repository`s we defined in our project, and a bunch of others that will be provided documentation upon the final release of Flood.

While `CorePondContext` represents the core features of your app in all contexts, there are specific classes you need to register depending on the context.

- `AppPondContext` defined in [main.dart](todo/lib/main.dart) defines how your app behaves in the context of Flutter, such as defining all the pages of your app (including debug pages such as `/_debug/logs`), adding the Firebase Crashlytics integration using `FirebaseCrashlyticsAppComponent`, providing a style definition using `StyleAppComponent` (learn more about Style [here](https://www.flooddev.com#style)), providing the url bar that shows up when you long-press the bottom-left corner of the screen using `UrlBarAppComponent`, showing the current environment on the top-right of the page using `EnvironmentBannerAppComponent`, and providing all the custom pages you define using [TodoPagesAppPondComponent](todo/lib/presentation/todo_pages_pond_component.dart).
- `AutomatePondContext` defined in [automate.dart](todo_core/tool/automate.dart) defines the different CLI automation commands that are available. For example, `NativeSetupAutomateComponent` defines `dart tool/automate.dart native_setup` which automatically generates the app icons and splash screens for your app, `OpsAutomateComponent` defines `dart tool/automate.dart deploy` which uploads Firebase security rules to Firebase or generates the server backend code and deploys it to Appwrite's Cloud Functions, `ReleaseAutomateComponent` defines `dart tool/automate.dart release` which generates a version and changelog, and deploys the app automatically to the Play Store, App Store, and the web. Learn more about what these automations can do in the `Automate` section below.
- `OpsPondContext` isn't defined in this project, but can be used to define what backend should be generated when you deploy your code to a Dart Cloud Function using Appwrite's Cloud Functions.

### [Automate](https://www.flooddev.com#automate)

Automate allows you to easily run CLI commands that understands your app and do the heavy lifting of backend function deployment, play store release and version management, and native splash screen and app icon setup for you. Defined by the components in [automate.dart](todo_core/tool/automate.dart), here are the commands you can use:

- `dart tool/automate.dart native_setup` looks at your [assets](todo/assets) folder to generate a native splash screen and app icon for you automatically, also providing utilities to add padding to your app icon image and background color for Android's adaptive app icons.
- `dart tool/automate.dart deploy [environment]` deploys resources to a specific environment depending on your cloud setup. If you are using Firebase, it will generate security rules for you based on your Drop `Repository`s and deploy it to your emulator if you are using the `qa` environment, or to a specified Firebase project on `staging` or `production` environments. If you are using Appwrite, it will generate the backend code, package it up, and deploy it to an Appwrite Cloud Function. This functionality is still in development, so there is no showcase of it here.
- `dart tool/automate.dart release [environment]` runs a release pipeline for your app. You can customize the pipeline, but by default, it asks you for a new version for the app, increments the build number, asks you for a changelog, tests the app, signs and builds the app in Android, iOS, and web, and deploys it to the specified deploy targets. It guides you through the process of where to find api keys for `fastlane match`, app ids for the different deploy targets, etc., ensuring you do not have to spend hours of time poring over documentation to get your own fastlane pipeline set up. You can add optional parameters such as `skip_build:true` to skip certain pipeline steps, or `only:android,ios` to deploy only to Android and iOS, skipping web.

### [Debug](https://www.flooddev.com#debug)

By navigating to the `/_debug` page, you can view additional debug information about the app. For example, you can view the logs of the current and previous sessions running the app. This helps tremendously when someone reports having a bug in your app, you can ask them to share those logs with you! You can view the files on the device easily. You can view the Drop `Repository`s along with the `Entity`s in them. You can also reset the app, emulating what would happen if you had never installed the app before (it clears all the Flood-generated files from your device and logs you out). As with all things in Flood, this is completely customizable so you can add your own debug pages if you would like.

If you want to inspect the queries that were run when generating a page, simply add `?_debug=true` to the end of a url to open a debug panel which shows you additional debug information. Not only can you see each query and the resulting data from that query, you can also easily see the logged-in user's ID. Of course, you can define your own components to add more debug containers in this debug panel if you'd like.

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