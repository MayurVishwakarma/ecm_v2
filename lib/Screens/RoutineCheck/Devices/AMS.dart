import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/Damage/NodeTableWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmsRoutine extends StatefulWidget {
  const AmsRoutine({super.key});

  @override
  State<AmsRoutine> createState() => _AmsRoutineState();
}

class _AmsRoutineState extends State<AmsRoutine> {
  late ScrollController _controller;
  TextEditingController _searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(loadMore);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = Provider.of<DamageProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      dp.updateSource('AMS');
      ap.updateSelectedArea(null);
      ap.updateSelectedDistributory(null);
      ap.getAreaList(ap.selectedProject?.id);
      ap.getDistributoryList('all', ap.selectedProject?.id);
      firstLoad();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    _controller.dispose(); // ✅ important
    super.dispose();
  }

  bool electricalAsc = true; // sorting flag for Electrical
  bool mechanicalAsc = true; // sorting flag for Mechanical
  String? _sortColumn;
  void sortByElectrical(DamageProvider dp) {
    setState(() {
      electricalAsc = !electricalAsc;
      _sortColumn = "electrical";
      dp.nodeList?.sort((a, b) {
        final aVal = a.electrical ?? 0;
        final bVal = b.electrical ?? 0;
        return electricalAsc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
  }

  void sortByMechanical(DamageProvider dp) {
    setState(() {
      mechanicalAsc = !mechanicalAsc;
      _sortColumn = "mechanical";
      dp.nodeList?.sort((a, b) {
        final aVal = a.mechanical ?? 0;
        final bVal = b.mechanical ?? 0;
        return mechanicalAsc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
  }

  void firstLoad() {
    final dp = Provider.of<DamageProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    dp.updateFirstLoad(true);
    dp.updateIndex(0);
    dp.updateHasNextPage(true);
    dp.updateLoadMore(false);

    dp
        .getDamageFormNode(
          projectId: ap.selectedProject!.id,
          search: '',
          area: 'all',
          distributory: 'all',
          index: 0,
          limit: 30,
          source: dp.source ?? 'AMS',
        )
        .whenComplete(() => dp.updateFirstLoad(false));
  }

  void loadMore() {
    final dp = Provider.of<DamageProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    if (dp.hasNextPage &&
        !dp.isFirstLoadRunning &&
        !dp.isLoadMoreRunning &&
        _controller.position.extentAfter < 300) {
      dp.updateLoadMore(true);
      dp.updateIndex(dp.index + 1);

      dp
          .getDamageFormNode(
            projectId: ap.selectedProject!.id,
            search: searchQuery ?? '',
            area: ap.selectedArea?.areaId.toString() ?? 'all',
            distributory: ap.selectedDistributory?.id.toString() ?? 'all',

            index: dp.index,
            limit: 30,
            source: dp.source ?? 'AMS',
          )
          .whenComplete(() => dp.updateLoadMore(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DamageProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    final areaList = ap.area ?? [];
    final distList = ap.distributory ?? [];
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
                            dp.updateIndex(0);
                            dp.getDamageFormNode(
                              projectId: ap.selectedProject!.id,
                              search: searchQuery!,
                              area: ap.selectedArea?.areaId.toString() ?? 'all',
                              distributory:
                                  ap.selectedDistributory?.id.toString() ??
                                  'all',

                              index: 0,
                              limit: 30,
                              source: dp.source,
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
                                  dp.updateIndex(0);
                                  ap.updateSelectedArea(selected);
                                  ap.updateSelectedDistributory(null);
                                  ap.getDistributoryList(
                                    (value == -1 ? 'all' : value.toString()),
                                    ap.selectedProject?.id,
                                  );
                                  dp.getDamageFormNode(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area: value == -1
                                        ? 'all'
                                        : value.toString(),
                                    distributory: 'all',

                                    index: dp.index,
                                    limit: 30,
                                    source: dp.source,
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
                                  dp.updateIndex(0);
                                  ap.updateSelectedDistributory(selected);
                                  dp.getDamageFormNode(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory:
                                        ap.selectedDistributory?.id
                                            .toString() ??
                                        'all',

                                    index: dp.index,
                                    limit: 30,
                                    source: dp.source,
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
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    // columnWidths: {
                    //   0: FixedColumnWidth(130), // Chak No. column fixed width
                    //   1: FixedColumnWidth(150), // Chak No. column fixed width
                    //   2: FixedColumnWidth(150), // Chak No. column fixed width
                    // },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          // color: ColorManager.ecoGreen,
                          // border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'AMS No'.tr(),
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                /*Text(
                                  '(Distri-Area)'.tr(),
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              */
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => sortByElectrical(dp),
                              child: SizedBox(
                                width: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Electrical".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (_sortColumn == "electrical")
                                        Icon(
                                          electricalAsc
                                              ? Icons.arrow_upward_rounded
                                              : Icons.arrow_downward_rounded,
                                          size: 16,
                                        )
                                      else
                                        Icon(
                                          Icons.sort_rounded,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      // Icon(
                                      //   electricalAsc
                                      //       ? Icons.arrow_upward_rounded
                                      //       : Icons.arrow_downward_rounded,
                                      //   size: 18,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => sortByMechanical(dp),
                              child: SizedBox(
                                width: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Mechanical".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (_sortColumn == "mechanical")
                                        Icon(
                                          mechanicalAsc
                                              ? Icons.arrow_upward_rounded
                                              : Icons.arrow_downward_rounded,
                                          size: 16,
                                        )
                                      else
                                        Icon(
                                          Icons.sort_rounded,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: {
                      0: FixedColumnWidth(130), // Chak No. column fixed width
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: ColorManager.ecoGreen),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'AMS No'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '(Distri-Area)'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                "Electronical".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  "Mechanical".tr(),

                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
*/
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
                        child: dp.isFirstLoadRunning
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  NodeTableWidget(dp: dp),
                                  if (dp.isLoadMoreRunning == true) Container(),
                                  if (dp.hasNextPage == false) Container(),
                                  if (dp.nodeList == null ||
                                      dp.nodeList!.isEmpty)
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
}
