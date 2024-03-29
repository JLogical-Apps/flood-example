import 'package:flood_core/flood_core.dart';
import 'package:todo_core/features/todo/todo.dart';
import 'package:todo_core/features/todo/todo_entity.dart';

class TodoRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<TodoEntity, Todo>(
    TodoEntity.new,
    Todo.new,
    entityTypeName: 'TodoEntity',
    valueObjectTypeName: 'Todo',
  ).adapting('todo').withSecurity(RepositorySecurity(
        read: Permission.authenticated,
        create: Permission.authenticated,
        update: Permission.authenticated,
        delete: Permission.authenticated,
      ));
}
