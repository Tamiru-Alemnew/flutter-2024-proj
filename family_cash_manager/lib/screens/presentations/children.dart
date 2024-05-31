import 'package:family_cash_manager/blocs/family_members_bloc.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:family_cash_manager/widgets/presentation/common_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageChildren extends StatelessWidget {
  const ManageChildren({Key? key}) : super(key: key);


  Future<String> getUserRole(BuildContext context) async {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final userState = userBloc.state;
    if (userState is UserAuthenticated) {
      return userState.user.role;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserRole(context),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data != 'parent') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('You must be a parent to edit categories')),
            );
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
          return Container();
        } else {
          return Scaffold(
            drawer: const CommonSideBar(),
            appBar: AppBar(
              title: const Text('Family Cash Manager'),
            ),
            body: ChildrenPage(),
          );
        }
      },

    );
  }
}

/// This class represents the page for managing children in the Family Cash Manager app.
/// It extends StatefulWidget to provide a dynamic user interface that can change based on data and user interactions.
class ChildrenPage extends StatefulWidget {
  @override
  _ChildrenPageState createState() => _ChildrenPageState();
}

/// This class represents the state of the ChildrenPage widget in the Family Cash Manager app.
/// It manages the list of children and their information.
class _ChildrenPageState extends State<ChildrenPage> {

  List<User>? childrenList;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FamilyMembersBloc>(context).add(GetAllFamilyMembers());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          'Manage Children',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: BlocBuilder<FamilyMembersBloc, FamilyMembersState>(
        builder: (context, state) {
          if (state is FamilyMembersLoaded) {
            childrenList = state.familyMembers
                .map((user) => User(
                    email: user.email, role: user.role, userId: user.userId))
                .toList();
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: childrenList!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      key: ValueKey(childrenList![index].userId),
                      title: Text(childrenList![index].email),
                      subtitle: Text(childrenList![index].role),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Change Role"),
                                content: Text(
                                    "Do you want to change ${childrenList?[index].email}'s role?"),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Change"),
                                    onPressed: () {
                                      final userState =
                                          context.read<UserBloc>().state;

                                      if (userState is UserAuthenticated) {
                                        BlocProvider.of<FamilyMembersBloc>(
                                                context)
                                            .add(UpdateRole(
                                          id: childrenList![index].userId,
                                          role: childrenList![index].role ==
                                                  "parent"
                                              ? "children"
                                              : "parent",
                                        ));

                                        Navigator.of(context).pop();
                                        _showSnackbar();
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Role changed successfully'),
      ),
    );
  }
}
