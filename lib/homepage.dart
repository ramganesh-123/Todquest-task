import 'package:Todquest_task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final TaskController controller = Get.put(TaskController());
  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todquest-task')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _showAddTaskDialog(context),
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    var task = controller.tasks[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            color:
                                task.isCompleted ? Colors.green : Colors.black,
                          ),
                        ),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            controller.toggleTask(task.id);
                            if (task.isCompleted) {
                              Get.snackbar(
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                'Task Completed',
                                ' "${task.title}"!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            final taskTitle = task.title;
                            controller.deleteTask(task.id);
                            Get.snackbar(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              'Task Deleted',
                              'Task "$taskTitle" has been removed',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade400,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Add Task',
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: taskController,
          decoration: const InputDecoration(
            hintText: 'Enter task',
            errorStyle: TextStyle(color: Colors.red),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (formKey.currentState!.validate()) {
          controller.addTask(taskController.text.trim());
          taskController.clear();
          Get.back();
        } else {
          Get.snackbar(
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            'Error',
            'Please enter a valid task',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      },
    );
  }
}
