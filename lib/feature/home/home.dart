import 'package:flutter/material.dart';
import 'package:flutterproject/feature/home/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc()..add(GroupFetched()); // Initialize and trigger the event
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _homeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: BlocBuilder<HomeBloc, GroupState>(
          builder: (context, state) {
            switch (state.groupStatus) {
              case GroupStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case GroupStatus.failure:
                return Center(child: Text(state.message));
              case GroupStatus.success:
                return ListView.builder(
                  itemCount: state.grouplist.length,
                  itemBuilder: (context, index) {
                    final item = state.grouplist[index];
                    return ListTile(
                      title: Text(item.name.toString()),
                    );
                  },
                );
              default:
                return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }
}
