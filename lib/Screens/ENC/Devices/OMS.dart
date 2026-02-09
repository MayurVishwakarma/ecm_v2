// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Screens/ENC/OfflineDevices/OfflineOMS.dart';
import '../../../Utils/Themes/color_manager.dart';
import '../../../Widgets/ENC/NodeTableWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OmsPage extends StatefulWidget {
  const OmsPage({super.key});

  @override
  State<OmsPage> createState() => _OmsPageState();
}

class _OmsPageState extends State<OmsPage> {
  late ScrollController _controller;
  TextEditingController _searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(loadMore);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pp = Provider.of<ProjectProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);

      pp.updateSource('OMS');
      ap.updateSelectedArea(null);
      ap.updateSelectedDistributory(null);
      firstLoad();
      pp.loadProcesses(
        source: pp.source ?? 'OMS',
        projectId: ap.selectedProject!.id,
      );
    });
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    _controller.dispose(); // ✅ important
    super.dispose();
  }

  void firstLoad() {
    final ep = Provider.of<ProjectProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    ep.updateNodeList([]);
    ep.updateFirstLoad(true);
    ep.updateIndex(0);
    ep.updateHasNextPage(true);
    ep.updateLoadMore(false);

    ep
        .getEcmNodes(
          projectId: ap.selectedProject!.id,
          search: '',
          area: 'all',
          distributory: 'all',
          process: 'all',
          subProcess: 'all',
          index: 0,
          limit: 30,
          source: ep.source ?? 'OMS',
        )
        .whenComplete(() => ep.updateFirstLoad(false));
  }

  void loadMore() {
    final ep = Provider.of<ProjectProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    if (ep.hasNextPage &&
        !ep.isFirstLoadRunning &&
        !ep.isLoadMoreRunning &&
        _controller.position.extentAfter < 300) {
      ep.updateLoadMore(true);
      ep.updateIndex(ep.index + 1);

      ep
          .getEcmNodes(
            projectId: ap.selectedProject!.id,
            search: searchQuery ?? '',
            area: ap.selectedArea?.areaId.toString() ?? 'all',
            distributory: ap.selectedDistributory?.id.toString() ?? 'all',
            process: ep.selectedProcess?.processId.toString() ?? 'all',
            subProcess: ep.selectedSubProcess?.subProcessId.toString() ?? 'all',
            index: ep.index,
            limit: 30,
            source: ep.source ?? 'OMS',
          )
          .whenComplete(() => ep.updateLoadMore(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<ProjectProvider>(context);
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
                            ep.updateIndex(0);
                            ep.getEcmNodes(
                              projectId: ap.selectedProject!.id,
                              search: searchQuery!,
                              area: ap.selectedArea?.areaId.toString() ?? 'all',
                              distributory:
                                  ap.selectedDistributory?.id.toString() ??
                                  'all',
                              process:
                                  ep.selectedProcess?.processId.toString() ??
                                  'all',
                              subProcess:
                                  ep.selectedSubProcess?.subProcessId
                                      .toString() ??
                                  'all',
                              index: 0,
                              limit: 30,
                              source: ep.source,
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
                                  ep.updateIndex(0);
                                  ap.updateSelectedArea(selected);
                                  ap.updateSelectedDistributory(null);
                                  ap.getDistributoryList(
                                    (value == -1 ? 'all' : value.toString()),
                                    ap.selectedProject?.id,
                                  );
                                  ep.getEcmNodes(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area: value == -1
                                        ? 'all'
                                        : value.toString(),
                                    distributory: 'all',
                                    process: 'all',
                                    subProcess: 'all',
                                    index: ep.index,
                                    limit: 30,
                                    source: ep.source,
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
                                  ep.updateIndex(0);
                                  ap.updateSelectedDistributory(selected);
                                  ep.getEcmNodes(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory:
                                        ap.selectedDistributory?.id
                                            .toString() ??
                                        'all',
                                    process:
                                        ep.selectedProcess?.processId
                                            .toString() ??
                                        'all',
                                    subProcess: 'all',
                                    index: ep.index,
                                    limit: 30,
                                    source: ep.source,
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

                // -------- PROCESS DROPDOWN ----------
                if (ep.processList != null && ep.processList!.isNotEmpty)
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
                                initialValue: ep.selectedProcess?.processId,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: "Select Process".tr(),
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    ep.processList
                                        ?.map(
                                          (process) => DropdownMenuItem<int>(
                                            value: process.processId,
                                            child: Text(
                                              process.processName?.tr() ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                                onChanged: (value) {
                                  final selected = ep.processList?.firstWhere(
                                    (p) => p.processId == value,
                                  );
                                  ep.updateSelectedProcess(selected);
                                  ep.updateIndex(0);
                                  ep.getEcmNodes(
                                    projectId: ap.selectedProject!.id,
                                    search: searchQuery ?? '',
                                    area:
                                        ap.selectedArea?.areaId.toString() ??
                                        'all',
                                    distributory:
                                        ap.selectedDistributory?.id
                                            .toString() ??
                                        'all',
                                    process: value == -1
                                        ? 'all'
                                        : value.toString(),
                                    subProcess: 'all',
                                    index: ep.index,
                                    limit: 30,
                                    source: ep.source,
                                  );
                                },
                              ),
                            ),
                            if (ep.selectedProcess?.processName !=
                                'ALL PROCESS')
                              const SizedBox(width: 16),
                            if (ep.selectedProcess?.processName !=
                                'ALL PROCESS')
                              Flexible(
                                fit: FlexFit.tight,
                                child: DropdownButtonFormField<int>(
                                  initialValue:
                                      ep.selectedSubProcess?.subProcessId,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: "Select SubProcess".tr(),
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      ep.subProcessList
                                          ?.map(
                                            (sub) => DropdownMenuItem<int>(
                                              value: sub.subProcessId,
                                              child: Text(
                                                sub.subProcessName?.tr() ?? '',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                          .toList() ??
                                      [],
                                  onChanged: (value) {
                                    final selected = ep.subProcessList
                                        ?.firstWhere(
                                          (s) => s.subProcessId == value,
                                        );
                                    ep.updateSelectedSubProcess(selected);
                                    ep.updateIndex(0);
                                    ep.getEcmNodes(
                                      projectId: ap.selectedProject!.id,
                                      search: searchQuery ?? '',
                                      area:
                                          ap.selectedArea?.areaId.toString() ??
                                          'all',
                                      distributory:
                                          ap.selectedDistributory?.id
                                              .toString() ??
                                          'all',
                                      process: ep.selectedProcess?.processId
                                          .toString(),
                                      subProcess: value == -1
                                          ? 'all'
                                          : (value ?? 'all').toString(),
                                      index: ep.index,
                                      limit: 30,
                                      source: ep.source,
                                    );
                                  },
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            OfflineOms.routeName,
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
                ),

                // --------Node List----------
                if (ep.processList != null && ep.processList!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FixedColumnWidth(130), // Chak No. column fixed width
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: ColorManager.ecoGreen,
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '(Distri-Area)'.tr(),
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            for (var process in ep.processList!.where(
                              (e) => e.processId != 0,
                            ))
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                    ep.ConvertLongtoShortString(
                                      process.processName!.tr(),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontSize:
                                          context.locale.languageCode != 'en'
                                          ? 12
                                          : 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (ep.processList != null && ep.processList!.isNotEmpty)
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
                          child: ep.isFirstLoadRunning
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    NodeTableWidget(
                                      projectProvider: ep,
                                      onReturn: () {
                                        firstLoad();
                                      },
                                    ),
                                    if (ep.isLoadMoreRunning == true)
                                      Container(),
                                    if (ep.hasNextPage == false) Container(),
                                    if (ep.nodeList == null ||
                                        ep.nodeList!.isEmpty)
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

                /*ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final data = ep.nodeList?[index];
                    final processList = ep.processList
                        ?.where((process) => process.processId != 0)
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap: () {
                          ep.updateSelectedNode(data);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            EcmReports.routeName,
                            (route) => true,
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: ColorManager.ecoGreen,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data?.chakNo.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '( ${(data?.areaName ?? '').trim()} - ${(data?.description ?? '').trim()} )',
                                        softWrap: true,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: processList?.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 4,
                                      ),
                                  itemBuilder: (BuildContext context, int i) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                ep.ConvertLongtoShortString(
                                                  processList![i].processName!,
                                                ),
                                                softWrap: true,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                child: Image(
                                                  image: AssetImage(
                                                    ep
                                                        .getprocessstatus(
                                                          processList[i]
                                                              .processName!,
                                                          ep
                                                              .getProStatus(
                                                                processList[i]
                                                                    .processName!,
                                                                data!,
                                                              ),
                                                        ),
                                                  ),
                                                  height: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: ep.nodeList?.length ?? 0,
                ),
              */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
