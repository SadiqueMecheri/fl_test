import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Const/utils.dart';
import '../Providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  ScrollController scrollController;
  HomeScreen({super.key, required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// for calling refresh use    taskProvider.resetTasks();taskProvider.fetchTasks();
  @override
  void initState() {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.fetchTasks();
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        provider.loadMore(); // Load more data when scrolled to bottom
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                InkWell(
                  onTap: () {
                    _addTaskAlert(context, 0, "0", "0", 0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 12, right: 12, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Add Task",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        taskProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : taskProvider.errorMessage != null
                ? Center(child: Text(taskProvider.errorMessage!))
                : taskProvider.visibleTasks.isEmpty
                    ? const Center(child: Text('No data available'))
                    : Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Tasks :${taskProvider.taskrep.totalTasks}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Pending Tasks :${taskProvider.taskrep.pendingTasks}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: buttonColor),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: List.generate(
                              taskProvider.hasMore
                                  ? taskProvider.visibleTasks.length + 1
                                  : taskProvider.visibleTasks.length,
                              (index) {
                                if (index == taskProvider.visibleTasks.length) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final task = taskProvider.visibleTasks[index];

                                final Color color = Colors
                                    .primaries[index % Colors.primaries.length];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: color.withOpacity(0.1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.7,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      task.name,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      task.description,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors
                                                              .grey.shade800),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _addTaskAlert(
                                                          context,
                                                          task.id,
                                                          task.name,
                                                          task.description,
                                                          1);
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 23,
                                                      child: SvgPicture.asset(
                                                        "assets/svg/edit.svg",
                                                        color: buttonColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      deletetask(
                                                        context,
                                                        task.id,
                                                      );
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 23,
                                                      child: SvgPicture.asset(
                                                        "assets/svg/delete1.svg",
                                                        color: buttonColor,
                                                        height: 28,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            "Status",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            task.status,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            "Percentage",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            "${task.percentage}%",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    buttonColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
        const SizedBox(
          height: 120,
        )
      ],
    );
  }

// add task and edit task
  void _addTaskAlert(
      BuildContext context, int id, String name, String description, int from) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDeadline;
    bool isLoading = false;
    if (from == 1) {
      titleController.text = name;
      descriptionController.text = description;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.grey[200],
          insetPadding: const EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  from == 0 ? 'Add Task' : 'update Task',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                // height: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Title Field
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Enter name",
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Description Field
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Description",
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDeadline = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDeadline != null
                                  ? "Deadline: ${selectedDeadline!.toLocal().toString().split(' ')[0]}"
                                  : "Select Deadline",
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black45,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save Button
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () async {
                              final title = titleController.text;
                              final description = descriptionController.text;

                              if (title.isEmpty ||
                                  description.isEmpty ||
                                  selectedDeadline == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All fields are required'),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              try {
                                await Provider.of<TaskProvider>(
                                  context,
                                  listen: false,
                                ).addTask(
                                    title,
                                    description,
                                    selectedDeadline!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0],
                                    "Starting",
                                    from,
                                    id);

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(from == 1
                                        ? 'Task updated successfully!'
                                        : 'Task added successfully!'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(from == 1
                                        ? 'Failed to update task: $e'
                                        : 'Failed to add task: $e'),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                                taskProvider.resetTasks();
                                taskProvider.fetchTasks();
                              }
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: buttonColor,
                              ),
                              child: Center(
                                child: Text(
                                  from == 1 ? "Update" : "Save",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // delete dialoge
  void deletetask(BuildContext context, int id) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool isLoadingdelete = false;

            return CupertinoAlertDialog(
              title: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              content: const Text(
                'Do you want to Delete?',
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                isLoadingdelete
                    // ignore: dead_code
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoadingdelete = true;
                          });

                          try {
                            await Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            ).deleteitem(id);
                            Navigator.of(context).pop(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task deleted successfully!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete task: $e'),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoadingdelete = false;
                            });
                            taskProvider.resetTasks();
                            taskProvider.fetchTasks();
                          }
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
