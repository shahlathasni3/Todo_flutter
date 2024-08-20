import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/model/database_services.dart';
import 'package:todo_app/model/todoModel.dart';

class completedWidget extends StatefulWidget {
  const completedWidget({super.key});

  @override
  State<completedWidget> createState() => _completedWidgetsState();
}

class _completedWidgetsState extends State<completedWidget> {

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
      stream: _databaseService.completedtodos,
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
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                    key: ValueKey(todo.id),
                    endActionPane: ActionPane(motion: DrawerMotion(), children: [
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
                      title: Text(todo.title,style: TextStyle(fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough),),
                      subtitle: Text(todo.description,style: TextStyle(decoration: TextDecoration.lineThrough),),
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
}
