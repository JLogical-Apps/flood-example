import 'package:flutter/material.dart';
import 'package:flood/flood.dart';
import 'package:todo/presentation/pages/auth/login_page.dart';
import 'package:todo/presentation/utils/redirect_utils.dart';
import 'package:todo_core/features/todo/todo.dart';
import 'package:todo_core/features/todo/todo_entity.dart';

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>().onlyIfLoggedIn();

  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    if (loggedInUserId == null) {
      return StyledLoadingPage();
    }

    final todosModel = useQuery(Query.from<TodoEntity>().where(Todo.userField).isEqualTo(loggedInUserId).all());

    return ModelBuilder.page(
      model: todosModel,
      builder: (List<TodoEntity> todoEntities) {
        final uncompletedTodos = todoEntities.where((todoEntity) => !todoEntity.value.completedProperty.value).toList();
        final completedTodos = todoEntities.where((todoEntity) => todoEntity.value.completedProperty.value).toList();

        return StyledPage(
          titleText: 'Todos',
          actions: [
            ActionItem(
              titleText: 'Logout',
              color: Colors.red,
              descriptionText: 'Log out of your account.',
              iconData: Icons.logout,
              onPerform: (context) async {
                await context.authCoreComponent.logout();
                await context.pushReplacement(LoginRoute());
              },
            ),
          ],
          body: StyledList.column.withScrollbar.centered(
            children: [
              StyledButton.strong(
                labelText: 'Create Todo',
                iconData: Icons.add,
                onPressed: () => context.showStyledDialog(StyledPortDialog(
                  titleText: 'Create Todo',
                  port: (Todo()..userProperty.set(loggedInUserId)).asPort(context.corePondContext),
                  onAccept: (Todo todo) async {
                    final todoEntity = TodoEntity()..set(todo);
                    await context.dropCoreComponent.update(todoEntity);
                  },
                )),
              ),
              ...uncompletedTodos.map((todoEntity) => StyledCard(
                    titleText: todoEntity.value.nameProperty.value,
                    bodyText: todoEntity.value.descriptionProperty.value,
                    leading: StyledCheckbox(
                      value: todoEntity.value.completedProperty.value,
                      onChanged: (value) async {
                        await context.dropCoreComponent
                            .updateEntity(todoEntity, (Todo todo) => todo.completedProperty.set(value));
                      },
                    ),
                    actions: _getTodoActions(todoEntity),
                  )),
              if (uncompletedTodos.isNotEmpty && completedTodos.isNotEmpty) StyledDivider(),
              ...completedTodos.map((todoEntity) => StyledCard.subtle(
                    titleText: todoEntity.value.nameProperty.value,
                    bodyText: todoEntity.value.descriptionProperty.value,
                    leading: StyledCheckbox(
                      value: todoEntity.value.completedProperty.value,
                      onChanged: (value) async {
                        await context.dropCoreComponent
                            .updateEntity(todoEntity, (Todo todo) => todo.completedProperty.set(value));
                      },
                    ),
                    actions: _getTodoActions(todoEntity),
                  )),
            ],
          ),
        );
      },
    );
  }

  List<ActionItem> _getTodoActions(TodoEntity todoEntity) {
    return [
      ActionItem(
        titleText: 'Edit',
        color: Colors.orange,
        descriptionText: 'Edit this Todo.',
        iconData: Icons.edit,
        onPerform: (context) => context.showStyledDialog(StyledPortDialog<Todo>(
          titleText: 'Edit Todo',
          port: todoEntity.value.asPort(context.corePondContext),
          onAccept: (Todo todo) async {
            await context.dropCoreComponent.updateEntity(todoEntity..set(todo));
          },
        )),
      ),
      ActionItem(
        titleText: 'Delete',
        color: Colors.red,
        descriptionText: 'Delete this Todo.',
        iconData: Icons.delete,
        onPerform: (context) => context.showStyledDialog(StyledDialog.yesNo(
          titleText: 'Confirm Delete',
          bodyText: 'Are you sure you want to delete this Todo? You cannot undo this.',
          onAccept: () async {
            await context.dropCoreComponent.delete(todoEntity);
          },
        )),
      ),
    ];
  }
}
