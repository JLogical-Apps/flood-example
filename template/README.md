# Template

Use this as a template to get started with Flood.

Here are the steps to use this as a baseline for your project:

1. Come up with a name for the project. It will be represented as {{NAME}} in the file examples
   below.
2. Rename the `template` directory to {{NAME}} and `template_core` to {{NAME}}_core.
3. In {{NAME}}/pubspec.yaml, replace `template` with {{NAME}}.
4. In {{NAME}}_core/pubspec.yaml, replace `template` with {{NAME}}.
5. In upgrade_both.sh, replace `template` with {{NAME}}. Run the script to update your pubs.
6. Replace every instance of `package:template_core/` with `package:{{NAME}}_core/`.
7. In {{NAME}}_core/tool/automate.dart, replace `Directory.current.parent / 'template'`
   with `Directory.current.parent / '{{NAME}}'` and `coreDirectory.parent / 'template'`
   with `coreDirectory.parent / '{{NAME}}'.
8. Replace every instance of `com.example.template` with your app identifier.
9. Search for `TODO` across the project to find what steps you should take to customize the project.
