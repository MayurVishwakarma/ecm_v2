// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/RoutineProvider.dart';
import '../../../Screens/RoutineCheck/Reports/RoutineReport.dart';
import '../../../Utils/Themes/color_manager.dart';
import '../../../Widgets/TableRowBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OmsRoutine extends StatefulWidget {
  const OmsRoutine({super.key});

  @override
  State<OmsRoutine> createState() => _OmsRoutineState();
}

class _OmsRoutineState extends State<OmsRoutine> {
  late ScrollController _controller;
  TextEditingController _searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(loadMore);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rp = Provider.of<RoutineProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      rp.updateSource('OMS');
      ap.updateSelectedArea(null);
      ap.updateSelectedDistributory(null);
      rp.updateSelectedStatus(null);
      rp.updateSelectedSchedule(null);
      ap.getAreaList(ap.selectedProject?.id);
      ap.getDistributoryList('all', ap.selectedProject?.id);
      rp.getRoutineStatusList();
      firstLoad();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    _controller.dispose(); // ✅ important
    super.dispose();
  }

  void firstLoad() {
    final rp = Provider.of<RoutineProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    rp.updateFirstLoad(true);
    rp.updateIndex(0);
    rp.updateHasNextPage(true);
    rp.updateLoadMore(false);

    rp
        .getRouineList(
          projectId: ap.selectedProject!.id,
          search: '',
          area: 'all',
          distributory: 'all',
          routineStatus: 3,
          nextSchedule: 0,
          index: 0,
          limit: 30,
          source: rp.source ?? 'OMS',
        )
        .whenComplete(() => rp.updateFirstLoad(false));
  }

  void loadMore() {
    final rp = Provider.of<RoutineProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    if (rp.hasNextPage &&
        !rp.isFirstLoadRunning &&
        !rp.isLoadMoreRunning &&
        _controller.position.extentAfter < 300) {
      rp.updateLoadMore(true);
      rp.updateIndex(rp.index + 1);

      rp
          .getRouineList(
            projectId: ap.selectedProject!.id,
            search: searchQuery ?? '',
            area: ap.selectedArea?.areaId.toString() ?? 'all',
            distributory: ap.selectedDistributory?.id.toString() ?? 'all',
            routineStatus: rp.selectedStatus?.id ?? 3,
            nextSchedule: rp.selecltedSchedule?.id ?? 0,
            index: rp.index,
            limit: 30,
            source: rp.source ?? 'OMS',
          )
          .whenComplete(() => rp.updateLoadMore(false));
    }
  }

  bool doneOnAsc = true;
  bool nextScheAsc = true;
  bool routineAsc = true;
  String? _sortColumn;

  @override
  Widget build(BuildContext context) {
    final rp = Provider.of<RoutineProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    final areaList = ap.area ?? [];
    final distList = ap.distributory ?? [];
    final statusList = rp.routineStatusList ?? [];
    final scheduleList = rp.nextScheduleList ?? [];
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          firstLoad();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.84,
            child: Column(
              children: [
                // --------Search Bar----------
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      searchQuery = value;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Search by Chak No.'.tr(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 30,
                          // color: Colors.white,
                        ),
                        onPressed: () {
                          if (searchQuery != null) {
                            rp.updateIndex(0);
                            rp.getRouineList(
                              projectId: ap.selectedProject!.id,
                              search: searchQuery ?? '',
                              area: ap.selectedArea?.areaId.toString() ?? 'all',
                              distributory:
                                  ap.selectedDistributory?.id.toString() ??
                                  'all',
                              routineStatus: rp.selectedStatus?.id ?? 3,
                              nextSchedule: rp.selecltedSchedule?.id ?? 0,
                              index: rp.index,
                              limit: 30,
                              source: rp.source,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),

                // -------- AREA DROPDOWN ----------
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Select Area'.tr(),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              initialValue:
                                  areaList.any(
                                    (a) => a.areaId == ap.selectedArea?.areaId,
                                  )
                                  ? ap.selectedArea?.areaId
                                  : null,
                              items: areaList.map<DropdownMenuItem<int>>((
                                area,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: area.areaId,
                                  child: Text(
                                    area.areaName ?? '',
                                    softWrap: true,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = areaList.firstWhere(
                                    (area) => area.areaId == value,
                                  );
                                  rp.updateIndex(0);
                                  ap.updateSelectedArea(selected);
                                  ap.updateSelectedDistributory(null);
                                  ap.getDistributoryList(
                                    (value == -1 ? 'all' : value.toString()),
                                    ap.selectedProject?.id,
                                  );
                                  rp.getRouineList(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area: value == -1
                                        ? 'all'
                                        : value.toString(),
                                    distributory:
                                        ap.selectedDistributory?.areaId
                                            .toString() ??
                                        'all',
                                    routineStatus: rp.selectedStatus?.id ?? 3,
                                    nextSchedule: rp.selecltedSchedule?.id ?? 0,

                                    index: rp.index,
                                    limit: 30,
                                    source: rp.source,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Distributory'.tr(),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              isExpanded: true,
                              initialValue:
                                  distList.any(
                                    (d) => d.id == ap.selectedDistributory?.id,
                                  )
                                  ? ap.selectedDistributory?.id
                                  : null,
                              items: distList.map<DropdownMenuItem<int>>((
                                dist,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: dist.id,
                                  child: Text(
                                    dist.description ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                if (value != null) {
                                  final selected = distList.firstWhere(
                                    (d) => d.id == value,
                                  );
                                  rp.updateIndex(0);
                                  ap.updateSelectedDistributory(selected);
                                  rp.getRouineList(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory: value == -1
                                        ? 'all'
                                        : value.toString(),
                                    routineStatus: rp.selectedStatus?.id ?? 3,
                                    nextSchedule: rp.selecltedSchedule?.id ?? 0,

                                    index: rp.index,
                                    limit: 30,
                                    source: rp.source,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Select Status'.tr(),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              initialValue:
                                  statusList.any(
                                    (a) => a.id == rp.selectedStatus?.id,
                                  )
                                  ? rp.selectedStatus?.id
                                  : null,
                              items: statusList.map<DropdownMenuItem<int>>((
                                status,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: status.id,
                                  child: Text(
                                    status.name,
                                    softWrap: true,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = statusList.firstWhere(
                                    (status) => status.id == value,
                                  );
                                  rp.updateIndex(0);
                                  rp.updateSelectedStatus(selected);
                                  rp.getRouineList(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory:
                                        ap.selectedDistributory?.id
                                            .toString() ??
                                        'all',
                                    routineStatus: value,
                                    nextSchedule: rp.selecltedSchedule?.id ?? 0,

                                    index: rp.index,
                                    limit: 30,
                                    source: rp.source,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            fit: FlexFit.tight,
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Schedule'.tr(),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              isExpanded: true,
                              initialValue:
                                  scheduleList.any(
                                    (d) => d.id == rp.selecltedSchedule?.id,
                                  )
                                  ? rp.selecltedSchedule?.id
                                  : null,
                              items: scheduleList.map<DropdownMenuItem<int>>((
                                schedule,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: schedule.id,
                                  child: Text(
                                    schedule.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                if (value != null) {
                                  final selected = scheduleList.firstWhere(
                                    (d) => d.id == value,
                                  );
                                  rp.updateIndex(0);
                                  rp.updateSelectedSchedule(selected);
                                  rp.getRouineList(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory:
                                        ap.selectedDistributory?.id
                                            .toString() ??
                                        'all',
                                    routineStatus: rp.selectedStatus?.id ?? 3,
                                    nextSchedule: value,

                                    index: rp.index,
                                    limit: 30,
                                    source: rp.source,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // --------Node List----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // double tableWidth = constraints.maxWidth;

                      return Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        columnWidths: {
                          0: FlexColumnWidth(
                            2,
                          ), // Chak No. column gets more space
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            children: [
                              _buildHeader("ChakNo."),
                              _buildSortableHeader(
                                "Done On",
                                _sortColumn == "doneOn" ? doneOnAsc : null,
                                () => sortByDoneOn(rp),
                              ),
                              _buildSortableHeader(
                                "Next Schedule",
                                _sortColumn == "nextSchedule"
                                    ? nextScheAsc
                                    : null,
                                () => sortByNextSchedule(rp),
                              ),
                              _buildSortableHeader(
                                "Status",
                                _sortColumn == "routineStatus"
                                    ? routineAsc
                                    : null,
                                () => sortByStatus(rp),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _controller,
                    interactive: true,
                    thickness: 10,
                    radius: Radius.circular(15),
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      controller: _controller,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: rp.isFirstLoadRunning
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      border: TableBorder.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      columnWidths: {
                                        0: FlexColumnWidth(
                                          2,
                                        ), // Chak No. column gets more space
                                        1: FlexColumnWidth(1.5),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(1.5),
                                      },
                                      children: [
                                        ...(rp.routineList ?? []).map((item) {
                                          return TableRow(
                                            children: [
                                              // Wrap first cell
                                              TableRowBuild(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      item.chakNo!.trim(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      "(${item.areaName} - ${item.description})",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.blue,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  rp.updateSelectedNode(item);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    RoutineReport.routeName,
                                                    (route) => true,
                                                  );
                                                },
                                              ),
                                              TableRowBuild(
                                                child: Text(
                                                  rp.getShortDateFormated(
                                                    item.workedOn,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                onTap: () {
                                                  rp.updateSelectedNode(item);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    RoutineReport.routeName,
                                                    (route) => true,
                                                  );
                                                },
                                              ),
                                              TableRowBuild(
                                                child: Text(
                                                  rp.getShortDateFormated(
                                                    item.nextScheduleDate,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                onTap: () {
                                                  rp.updateSelectedNode(item);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    RoutineReport.routeName,
                                                    (route) => true,
                                                  );
                                                },
                                              ),
                                              TableRowBuild(
                                                child: rp.getRoutineStatus(
                                                  item.routineStatus ?? 0,
                                                  item.nextScheduleDate?.add(
                                                    Duration(
                                                      hours: 5,
                                                      minutes: 30,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  rp.updateSelectedNode(item);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    RoutineReport.routeName,
                                                    (route) => true,
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),

                                  if (rp.isLoadMoreRunning == true) Container(),
                                  if (rp.hasNextPage == false) Container(),
                                  if (rp.routineList == null ||
                                      rp.routineList!.isEmpty)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).brightness !=
                                                Brightness.dark
                                            ? ColorManager.pureWhite
                                            : ColorManager.darkElm,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'No Result Found',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
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
      ),
    );
  }

  void _sortList<T extends Comparable>(
    RoutineProvider rp,
    T? Function(dynamic item) getField,
    bool ascending,
    T defaultValue,
  ) {
    rp.routineList?.sort((a, b) {
      final aVal = getField(a) ?? defaultValue;
      final bVal = getField(b) ?? defaultValue;
      return ascending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
    });
  }

  void sortByDoneOn(RoutineProvider rp) {
    setState(() {
      doneOnAsc = !doneOnAsc;
      _sortColumn = "doneOn";
      _sortList<DateTime>(
        rp,
        (item) => item.workedOn,
        doneOnAsc,
        DateTime.fromMillisecondsSinceEpoch(0), // fallback = epoch
      );
    });
  }

  void sortByNextSchedule(RoutineProvider rp) {
    setState(() {
      nextScheAsc = !nextScheAsc;
      _sortColumn = "nextSchedule";
      _sortList<DateTime>(
        rp,
        (item) => item.nextScheduleDate,
        nextScheAsc,
        DateTime.fromMillisecondsSinceEpoch(0),
      );
    });
  }

  void sortByStatus(RoutineProvider rp) {
    setState(() {
      routineAsc = !routineAsc;
      _sortColumn = "routineStatus";
      _sortList<int>(
        rp,
        (item) => item.routineStatus,
        routineAsc,
        0, // fallback int
      );
    });
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSortableHeader(
    String text,
    bool? ascending,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              ascending == null
                  ? Icons.sort_rounded
                  : (ascending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded),
              size: 16,
              color: ascending == null ? Colors.grey : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
