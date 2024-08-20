import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/model/database_services.dart';
import 'package:todo_app/model/todoModel.dart';

class pendingWidgets extends StatefulWidget {
  const pendingWidgets({super.key});

  @override
  State<pendingWidgets> createState() => _pendingWidgetsState();
}

class _pendingWidgetsState extends State<pendingWidgets> {

  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseService _databaseService = DatabaseService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: _databaseService.todos,
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<Todo> todos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(

              ),
              itemCount: todos.length,
              itemBuilder: (context,index){
              Todo todo = todos[index];
              final DateTime dt = todo.timestamp.toDate();
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                    endActionPane: ActionPane(motion: DrawerMotion(), children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done,
                        label: "Done",
                        onPressed: (context) {
                       _databaseService.updtaeTodoStatus(todo.id, true);
                      },),
                    ],),
                    startActionPane: ActionPane(motion: DrawerMotion(), children: [
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Edit",
                        onPressed: (context) {
                          _showTaskDIalog(context,todo: todo);
                        },),
                      SlidableAction(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Delete",
                        onPressed: (context) {
                          _databaseService.deleteTodoDTask(todo.id);
                        },),
                    ],),
                    child: ListTile(
                      title: Text(todo.title,style: TextStyle(fontWeight: FontWeight.w500),),
                      subtitle: Text(todo.description),
                      trailing: Text('${dt.day}/${dt.month}/${dt.year}',style: TextStyle(fontWeight: FontWeight.bold),),
                    )),
              );
              },
          );
        }
        else{
          return Center(child: CircularProgressIndicator(color: Colors.white,),);
        }
      },
    );
  }
  void _showTaskDIalog(BuildContext context,{Todo? todo}){
    final TextEditingController _titleController = TextEditingController( text: todo?.title);
    final TextEditingController _descController = TextEditingController( text: todo?.description);
    final DatabaseService _databaseService = DatabaseService();

    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(todo == null ? "Add Task" : "Edit Task",style: TextStyle(fontWeight: FontWeight.w500),),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: () async{
              if(todo == null){
                await _databaseService.addTodoItem(_titleController.text, _descController.text);
              }
              else{
                await _databaseService.updateTodo(todo.id, _titleController.text, _descController.text);
              }
              Navigator.pop(context);
            }, child: Text(todo == null ? "Add" : "Update"),)
        ],
      );
    },);
  }
}
