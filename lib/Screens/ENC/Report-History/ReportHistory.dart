import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:ecm_v2/Widgets/E&C/ReportHistoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportHistory extends StatefulWidget {
  static const routeName = "/ReportHistory";
  const ReportHistory({super.key});

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  late ScrollController _controller;
  String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstLoad();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    _controller.dispose();
    super.dispose();
  }

  void firstLoad() {
    final ep = Provider.of<ProjectProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    ep.updateFirstLoad(true);
    ep.updateIndex(0);
    ep.updateHasNextPage(true);
    ep.updateLoadMore(false);

    ep
        .getReportHistory(
          projectId: ap.selectedProject?.id,
          deviceId: ep.getDeviceIdBySource(ep.source),
          source: ep.source,
          startDate: '1999-01-01',
          endDate: endDate,
          index: 0,
          limit: ep.limit,
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
          .getReportHistory(
            projectId: ap.selectedProject?.id,
            deviceId: ep.getDeviceIdBySource(ep.source),
            source: ep.source,
            startDate: '1999-01-01',
            endDate: endDate,
            index: ep.index,
            limit: ep.limit,
          )
          .whenComplete(() => ep.updateLoadMore(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<ProjectProvider>(context);
    final ap = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          'Report History'.tr(),
          ap.selectedProject,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ChangeLanguage(context);
            },
            icon: const Icon(Icons.translate_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          firstLoad();
        },
        child: Column(
          children: [
            // 🔹 Node Number Input (Top Section)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ep.getNodeName(ep.source!, ep.selectedNode!),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                  Expanded(
                    child: Text(
                      '(${ep.selectedNode?.areaName} - ${ep.selectedNode?.description})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Report List (Bottom Section)
            Expanded(
              child: ep.isFirstLoadRunning
                  ? const Center(child: CircularProgressIndicator())
                  : ep.ecmReportHistory == null || ep.ecmReportHistory!.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness != Brightness.dark
                              ? ColorManager.pureWhite
                              : ColorManager.darkElm,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'No Result Found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Scrollbar(
                      controller: _controller,
                      thickness: 10,
                      radius: const Radius.circular(15),
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _controller,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            ep.ecmReportHistory!.length +
                            (ep.isLoadMoreRunning ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < ep.ecmReportHistory!.length) {
                            return ReportHistoryWidget(
                              history: ep.ecmReportHistory![index],
                              ep: ep,
                            );
                          } else {
                            // Loader at bottom
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
                    ),
            ),
          ],
        ),
      ) /*RefreshIndicator(
        onRefresh: () async {
          firstLoad();
        },
        child: ep.isFirstLoadRunning
            ? const Center(child: CircularProgressIndicator())
            : ep.ecmReportHistory == null || ep.ecmReportHistory!.isEmpty
            ? Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? ColorManager.pureWhite
                        : ColorManager.darkElm,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'No Result Found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : Scrollbar(
                controller: _controller,
                thickness: 10,
                radius: const Radius.circular(15),
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      ep.ecmReportHistory!.length +
                      (ep.isLoadMoreRunning ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < ep.ecmReportHistory!.length) {
                      return ReportHistoryWidget(
                        history: ep.ecmReportHistory![index],
                        ep: ep,
                      );
                    } else {
                      // Loader at the bottom while fetching more
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
      )*/,
    );
  }
}
