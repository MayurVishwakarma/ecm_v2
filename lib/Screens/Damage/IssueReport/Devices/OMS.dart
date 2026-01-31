import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Damage/InformationCountModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Screens/Damage/InformationReport/Reports/InfromationReportList.dart';
import 'package:ecm_v2/Screens/Damage/IssueReport/Reports/IssueReportList.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/TableRowBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filter_list/filter_list.dart';

class OmsIssue extends StatefulWidget {
  const OmsIssue({super.key});

  @override
  State<OmsIssue> createState() => _OmsInformationState();
}

class _OmsInformationState extends State<OmsIssue> {
  late ScrollController _controller;
  TextEditingController _searchController = TextEditingController();
  String? searchQuery;
  List<int>? filter;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(); //..addListener(loadMore);
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
    // _controller.removeListener(loadMore);
    _controller.dispose(); // ✅ important
    super.dispose();
  }

  bool electricalAsc = true; // sorting flag for Electrical

  String? _sortColumn;

  void sortByElectrical(DamageProvider dp) {
    setState(() {
      electricalAsc = !electricalAsc;
      _sortColumn = "electrical";
      dp.damagestatuslist?.sort((a, b) {
        final aVal = a.electrical ?? 0;
        final bVal = b.electrical ?? 0;
        return electricalAsc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
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
    dp.getInformationStatusFilter(
      projectId: ap.selectedProject!.id,
      area: 'all',
      distributory: 'all',
      source: dp.source ?? 'OMS',
      type: 'issue',
    );

    dp
        .getInformationStatusList(
          projectId: ap.selectedProject!.id,
          filter: filter?.join(',') ?? '0',
          area: 'all',
          distributory: 'all',
          source: dp.source ?? 'OMS',
          type: 'issue',
        )
        .whenComplete(() => dp.updateFirstLoad(false));
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
                        icon: Icon(Icons.search, size: 30),
                        onPressed: () {
                          setState(() {
                            searchQuery = SearchController().text;
                          });
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
                                  dp.getInformationStatusList(
                                    projectId: ap.selectedProject!.id,
                                    filter: filter?.join(',') ?? '0',
                                    area: value == -1
                                        ? 'all'
                                        : value.toString(),
                                    distributory: 'all',
                                    type: 'info',
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
                                  dp.getInformationStatusList(
                                    projectId: ap.selectedProject!.id,
                                    filter: filter?.join(',') ?? '0',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory:
                                        ap.selectedDistributory?.id
                                            .toString() ??
                                        'all',
                                    type: 'info',
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

                // -------- Filter -------------
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Nodes :${dp.informationList?.length ?? 0}'),
                      TextButton(
                        onPressed: () {
                          showInformationFilter(context, dp);
                        },
                        child: Text('Filter'),
                      ),
                    ],
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
                                        ...(dp.informationList?.where(
                                                  (e) =>
                                                      (e.chakNo ?? '').contains(
                                                        searchQuery ?? '',
                                                      ),
                                                ) ??
                                                [])
                                            .map((item) {
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
                                                            "(${item.area} - ${item.description})",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        if (dp.source == 'LORA')
                                                          Text(
                                                            "(${item.chakNo?.trim()})",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      dp.updateSelectedInformationNode(
                                                        item,
                                                      );
                                                      Navigator.pushNamedAndRemoveUntil(
                                                        context,
                                                        IssueNodeHistory
                                                            .routeName,
                                                        (route) => true,
                                                      );
                                                    },
                                                  ),
                                                  TableRowBuild(
                                                    child: dp
                                                        .getDamageStatusBar(
                                                          'Total count',
                                                          (item.totalCount ??
                                                              0),
                                                        ),
                                                    onTap: () {
                                                      dp.updateSelectedInformationNode(
                                                        item,
                                                      );
                                                      Navigator.pushNamedAndRemoveUntil(
                                                        context,
                                                        InformationNodeHistory
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
                                  if (dp.informationList == null ||
                                      dp.informationList!.isEmpty)
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

  Future<void> showInformationFilter(
    BuildContext context,
    DamageProvider dp,
  ) async {
    await FilterListDialog.display<InformationCountModel>(
      context,
      hideSelectedTextCount: true,
      listData: dp.informationCount ?? [],
      selectedListData: dp.informationFilter ?? [], // ✅ ensure not null
      choiceChipLabel: (item) {
        return "${item!.infoDescription}\t (${item.cnt})";
      },
      validateSelectedItem: (list, val) {
        list ??= [];
        // compare by id instead of reference
        return list.any((element) => element.infoId == val.infoId);
      },
      onApplyButtonClick: (selectedList) {
        dp.updateInformationFilter(selectedList ?? []);

        // Convert to just IDs for API
        final filterIds = (selectedList ?? []).map((e) => e.infoId).toList();

        Navigator.pop(context);

        // refresh API with filters
        final ap = Provider.of<AuthProvider>(context, listen: false);

        dp.getDamageStatusNode(
          projectId: ap.selectedProject!.id,
          search: filterIds.isEmpty ? '0' : filterIds.join(','),
          area: ap.selectedArea?.areaId.toString() ?? 'all',
          distributory: ap.selectedDistributory?.id.toString() ?? 'all',
          source: dp.source,
        );
      },
      onItemSearch: (item, query) {
        return item.infoDescription!.toLowerCase().contains(
          query.toLowerCase(),
        );
      },
    );
  }
}
