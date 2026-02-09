// ignore_for_file: file_names, prefer_typing_uninitialized_variables, strict_top_level_inference

import '../../../Core/Providers/AuthProvider.dart';
import '../../../Screens/Maintainance/SearchBar.dart';
import '../../../Screens/Maintainance/Self_Diagnostic_Onsite.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/ExpandableTiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisnetScreen extends StatefulWidget {
  const DisnetScreen({super.key});

  @override
  State<DisnetScreen> createState() => _DisnetScreenState();
}

class _DisnetScreenState extends State<DisnetScreen> {
  @override
  void initState() {
    super.initState();
    populateLists();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(context, 'Disnet Help', ap.selectedProject),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: TextField(
                  controller: _searchController,
                  onTap: () => showSearch(
                    context: context,
                    delegate: ItemSearchDelegate(),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    filled: true,
                    // fillColor: Colors.grey[200],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: ExpandableTile(
                  title: Text(
                    "Communication Issue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      fontSize: 18,
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: commList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Self_Diagnostic(
                                issue: commList
                                    .elementAt(index)
                                    .issue
                                    .toString(),
                                desc: commList.elementAt(index).desc.toString(),
                                hoSupportId: commList
                                    .elementAt(index)
                                    .hoSupportId,
                              ),
                            ),
                            (Route<dynamic> route) => true,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            child: ListTile(
                              title: Text(
                                commList.elementAt(index).issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: ExpandableTile(
                  title: Text(
                    "System Issue",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      fontSize: 18,
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sysList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Self_Diagnostic(
                                issue: sysList
                                    .elementAt(index)
                                    .issue
                                    .toString(),
                                desc: sysList.elementAt(index).desc.toString(),
                                hoSupportId: sysList
                                    .elementAt(index)
                                    .hoSupportId,
                              ),
                            ),
                            (Route<dynamic> route) => true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            // color: Color.fromARGB(255, 84, 206, 77),
                            child: ListTile(
                              title: Text(
                                sysList.elementAt(index).issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: ExpandableTile(
                  title: Text(
                    "Process Issue",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      fontSize: 18,
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: procList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Self_Diagnostic(
                                issue: procList
                                    .elementAt(index)
                                    .issue
                                    .toString(),
                                desc: procList.elementAt(index).desc.toString(),
                                hoSupportId: procList
                                    .elementAt(index)
                                    .hoSupportId,
                              ),
                            ),
                            (Route<dynamic> route) => true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            // color: Color.fromARGB(255, 84, 206, 77),
                            child: ListTile(
                              title: Text(
                                procList.elementAt(index).issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: ExpandableTile(
                  title: Text(
                    "Operation Issue",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: opList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Self_Diagnostic(
                                issue: opList.elementAt(index).issue.toString(),
                                desc: opList.elementAt(index).desc.toString(),
                                hoSupportId: opList
                                    .elementAt(index)
                                    .hoSupportId,
                              ),
                            ),
                            (Route<dynamic> route) => true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            // color: Color.fromARGB(255, 84, 206, 77),
                            child: ListTile(
                              title: Text(
                                opList.elementAt(index).issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: ExpandableTile(
                  title: Text(
                    "Irrigation Schedule Issue",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Lato',
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: irriList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Self_Diagnostic(
                                issue: irriList
                                    .elementAt(index)
                                    .issue
                                    .toString(),
                                desc: irriList.elementAt(index).desc.toString(),
                                hoSupportId: irriList
                                    .elementAt(index)
                                    .hoSupportId,
                              ),
                            ),
                            (Route<dynamic> route) => true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            child: ListTile(
                              title: Text(
                                irriList.elementAt(index).issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  //  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: ExpandableTile(
                  title: Text(
                    "Hardware Issue",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      fontSize: 18,
                    ),
                  ),
                  body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: hardList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Self_Diagnostic(
                                issue: hardList
                                    .elementAt(index)
                                    .issue
                                    .toString(),
                                desc: hardList.elementAt(index).desc.toString(),
                                hoSupportId: hardList
                                    .elementAt(index)
                                    .hoSupportId,
                              ),
                            ),
                            (Route<dynamic> route) => true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            child: ListTile(
                              title: Text(
                                hardList.elementAt(index).issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var commList;
  var sysList;
  var procList;
  var opList;
  var irriList;
  var hardList;

  void populateLists() async {
    var vm = ItemSearchDelegate().vm;
    // if (commList == null)
    commList = vm.where((x) => x.category == 'Communication Issue').toList();
    // var commList;
    // commList.forEach((item) => commList.add(item));
    sysList = vm.where((x) => x.category == 'System Issue').toList();
    // sysList.forEach((item) => sysList.add(item));
    procList = vm.where((x) => x.category == 'Process Issue').toList();
    // procList.forEach((item) => procList.add(item));
    opList = vm.where((x) => x.category == 'Operational Issue').toList();
    // opList.forEach((item) => opList.add(item));
    irriList = vm
        .where((x) => x.category == 'Irrigation Schedule Issue')
        .toList();
    // irriList.forEach((item) => irriList.add(item));
    hardList = vm.where((x) => x.category == 'Hardware Issue').toList();
    // hardList.forEach((item) => hardList.add(item));
    //category
    // commcat = commList.where((x) => x.category == commList.).toList();
    setState(() {
      commList;
      sysList;
      procList;
      opList;
      irriList;
      hardList;
    });
  }
}
