import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/loginScreen.dart';
import 'package:todo_app/model/database_services.dart';
import 'package:todo_app/services/auth_services.dart';
import 'package:todo_app/widgets/completedWidget.dart';
import 'package:todo_app/widgets/pendingWidgets.dart';

import 'model/todoModel.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {

  int _buttonIndex = 0;
  final _widgets = [
    // pending task
    pendingWidgets(),
    // completed task
    completedWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        foregroundColor: CupertinoColors.white,
        title: Text("ToDo"),
        actions: [
          IconButton(onPressed: () async{
            await AuthService().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Loginscreen()));
          }, icon: Icon(Icons.exit_to_app),),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius:  BorderRadius.circular(10),
                  onTap: (){
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 0 ? Colors.indigo : Colors.white,
                      borderRadius:  BorderRadius.circular(10),
                    ),
                    child: Container(
                      child: Center(
                        child: Text("Pending",style: TextStyle(fontSize: _buttonIndex == 0 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 0 ? Colors.white : Colors.black,
                        ),),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius:  BorderRadius.circular(10),
                  onTap: (){
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 1 ? Colors.indigo : Colors.white,
                      borderRadius:  BorderRadius.circular(10),
                    ),
                    child: Container(
                      child: Center(
                        child: Text("Completed",style: TextStyle(fontSize: _buttonIndex == 0 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 1 ? Colors.white : Colors.black,
                        ),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 45,),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            _showTaskDIalog(context);
          }),
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
