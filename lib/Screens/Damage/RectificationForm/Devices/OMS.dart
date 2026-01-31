import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Screens/Damage/RectificationForm/Reports/RectificationReport.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/TableRowBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OmsRectification extends StatefulWidget {
  const OmsRectification({super.key});

  @override
  State<OmsRectification> createState() => _OmsRectificationState();
}

class _OmsRectificationState extends State<OmsRectification> {
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
      dp.updateSource('OMS');
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

  void firstLoad() {
    final dp = Provider.of<DamageProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    dp.updateFirstLoad(true);
    dp.updateIndex(0);
    dp.updateHasNextPage(true);
    dp.updateLoadMore(false);

    dp
        .getRectificationFormNode(
          projectId: ap.selectedProject!.id,
          search: '',
          area: 'all',
          distributory: 'all',
          index: 0,
          limit: 30,
          source: dp.source ?? 'OMS',
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
          .getRectificationFormNode(
            projectId: ap.selectedProject!.id,
            search: searchQuery ?? '',
            area: ap.selectedArea?.areaId.toString() ?? 'all',
            distributory: ap.selectedDistributory?.id.toString() ?? 'all',

            index: dp.index,
            limit: 30,
            source: dp.source ?? 'OMS',
          )
          .whenComplete(() => dp.updateLoadMore(false));
    }
  }

  bool countAsc = true; // sorting flag for Electrical

  String? _sortColumn;

  void sortByCount(DamageProvider dp) {
    setState(() {
      countAsc = !countAsc;
      _sortColumn = "count";
      dp.rectificationList?.sort((a, b) {
        final aVal = a.rectification ?? 0;
        final bVal = b.rectification ?? 0;
        return countAsc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
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
                            dp.getRectificationFormNode(
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
                                  dp.getRectificationFormNode(
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
                                  dp.getRectificationFormNode(
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
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            OfflineDamageOms.routeName,
                            (route) => true,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue, // Text color
                        ),
                        child: Text('viewOffline'.tr()),
                      ),
                    ),
                  ],
                ),*/

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

                    children: [
                      TableRow(
                        decoration: BoxDecoration(
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
                                  'ChakNo'.tr(),
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => sortByCount(dp),
                              child: SizedBox(
                                width: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Count".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (_sortColumn == "count")
                                        Icon(
                                          countAsc
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
                        ],
                      ),
                    ],
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
                        child: dp.isFirstLoadRunning
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

                                      children: [
                                        ...(dp.rectificationList ?? []).map((
                                          item,
                                        ) {
                                          return TableRow(
                                            children: [
                                              // Wrap first cell
                                              TableRowBuild(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      dp
                                                          .getNodeName(
                                                            dp.source!,
                                                            item,
                                                          )
                                                          .trim(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    if (dp.source != 'LORA')
                                                      Text(
                                                        "(${item.areaName} - ${item.description})",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.blue,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    if (dp.source == 'LORA')
                                                      Text(
                                                        "(${item.gatewayNo?.trim()})",
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
                                                  dp.updateSelectedRec(item);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    RectificationReport
                                                        .routeName,
                                                    (route) => true,
                                                  );
                                                },
                                              ),
                                              TableRowBuild(
                                                child: dp.getDamageStatusBar(
                                                  'Electrical',
                                                  (item.rectification ?? 0),
                                                ),
                                                onTap: () {
                                                  dp.updateSelectedRec(item);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    RectificationReport
                                                        .routeName,
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

                                  if (dp.isLoadMoreRunning == true) Container(),
                                  if (dp.hasNextPage == false) Container(),
                                  if (dp.rectificationList == null ||
                                      dp.rectificationList!.isEmpty)
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
                                          'No Results Found'.tr(),
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
