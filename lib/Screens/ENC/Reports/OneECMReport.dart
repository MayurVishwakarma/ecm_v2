// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Models/ECMReportModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ConnectivityProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Screens/ENC/Report-History/ReportHistory.dart';
import '../../../Utils/Themes/color_manager.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/CustomCounter.dart';
import '../../../Widgets/ENC/EcmImagePicker.dart';
import '../../../Widgets/ENC/ViewPDFWidget.dart';
import '../../../Widgets/POP-Ups/ChangeLanguage.dart';
import '../../../Widgets/POP-Ups/SubmitDialog.dart';

class OneEcmReports extends StatefulWidget {
  static const routeName = "/OneEcmReports";
  const OneEcmReports({super.key});

  @override
  State<OneEcmReports> createState() => _OneEcmReportsState();
}

class _OneEcmReportsState extends State<OneEcmReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReport();
    });
  }

  Future<void> _loadReport() async {
    if (!mounted) return;

    final ep = context.read<ProjectProvider>();
    final ap = context.read<AuthProvider>();
    final process = ep.selectedReportProcess;
    final project = ap.selectedProject;
    final source = ep.source ?? 'OMS';

    if (process?.processId == null ||
        ep.selectedNode == null ||
        project?.id == null) {
      ep.updateLoad(false);
      ep.updateChecklistModel(null);
      return;
    }

    try {
      await ep.getECMReport(
        deviceId: ep.getDeviceIdBySource(source),
        processId: process!.processId!,
        source: source,
        projectId: project!.id!,
        langCode: context.locale.languageCode,
      );
    } catch (error, stackTrace) {
      debugPrint('Error loading report: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _cleanErrorMessage(error),
            style: const TextStyle(
              color: ColorManager.pureWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: ColorManager.hotCoral,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          showCloseIcon: true,
          closeIconColor: ColorManager.pureWhite,
        ),
      );
    }
  }

  String _cleanErrorMessage(Object error) {
    final message = error.toString().replaceFirst(
      RegExp(r'^Exception:\s*'),
      '',
    );

    return message.trim().isEmpty
        ? 'unable to load data for this process\nplease try again letter'.tr()
        : message;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, ProjectProvider, ConnectivityProvider>(
      builder: (context, ap, ep, cp, child) {
        final process = ep.selectedReportProcess;
        final processName = process?.processName ?? 'Report';
        final appbarTitle = process == null
            ? 'Report'.tr()
            : '${ep.ConvertLongtoShortString(processName.tr())} ${'Report'.tr()}';
        final processItems = _itemsForSelectedProcess(ep);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: customECMAppbar(context, appbarTitle, ap.selectedProject),
            actions: [
              IconButton(
                tooltip: 'Change Language'.tr(),
                onPressed: () async {
                  await ChangeLanguage(context);
                  if (!mounted) return;
                  await ep.toggleTranslation(context.locale.languageCode);
                },
                icon: const Icon(Icons.translate_outlined),
              ),
              IconButton(
                tooltip: 'Report History'.tr(),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ReportHistory.routeName,
                    (route) => true,
                  );
                },
                icon: const Icon(Icons.info, color: ColorManager.hotCoral),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(ap, ep, cp, processItems),
          body: SafeArea(
            child: Column(
              children: [
                _buildReportHeader(ep, cp, processItems),
                Expanded(child: _buildReportContent(ap, ep, processItems)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportHeader(
    ProjectProvider ep,
    ConnectivityProvider cp,
    List<EcmReportMasterModel> processItems,
  ) {
    final node = ep.selectedNode;
    final source = ep.source ?? 'OMS';
    final processName = ep.selectedReportProcess?.processName ?? 'Report';
    final nodeName = node == null ? '-' : ep.getNodeName(source, node).trim();
    final description = source == 'LORA'
        ? node?.gatewayNo?.trim()
        : [node?.areaName, node?.description]
              .where((value) => value != null && value.trim().isNotEmpty)
              .join(' - ');
    final status = _statusFromReportOrNode(ep, processItems);
    final statusColor = _statusColor(processName, status);
    // final checklistCount = processItems
    //     .where((item) => _inputType(item) != 'image')
    //     .length;
    // final imageCount = processItems
    //     .where((item) => _inputType(item) == 'image')
    //     .length;
    final completion = _completionStats(processItems);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _progressColor(completion.ratio).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: _progressColor(completion.ratio),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nodeName.isEmpty ? '-' : nodeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (description != null && description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                ep.getApprovestatus(processName, status).tr(),
                statusColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // _buildProgressPanel(completion),
          /*         const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                Icons.rule_outlined,
                '${'Count'.tr()}: $checklistCount',
              ),
              if (imageCount > 0)
                _buildInfoChip(
                  Icons.image_outlined,
                  '${'img'.tr()}: $imageCount',
                ),
              _buildInfoChip(
                cp.isOnline ? Icons.wifi_outlined : Icons.wifi_off_outlined,
                cp.isOnline ? 'Online' : 'No internet connection'.tr(),
                color: cp.isOnline
                    ? ColorManager.ecoGreen
                    : ColorManager.cantaloupe,
              ),
            ],
          ),
        */
        ],
      ),
    );
  }

  /*Widget _buildProgressPanel(_CompletionStats completion) {
    final progressColor = _progressColor(completion.ratio);
    final percent = (completion.ratio * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: progressColor.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: completion.ratio,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  color: progressColor,
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Completed'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${completion.done}/${completion.total}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completion.ratio,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: progressColor,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  completion.total == 0
                      ? 'No data available'.tr()
                      : '${completion.pending} ${'Pending'.tr()}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget _buildReportContent(
    AuthProvider ap,
    ProjectProvider ep,
    List<EcmReportMasterModel> processItems,
  ) {
    if (ep.selectedReportProcess == null || ep.selectedNode == null) {
      return _buildEmptyState(
        icon: Icons.assignment_late_outlined,
        title: 'No data available'.tr(),
        message: 'No data available'.tr(),
      );
    }

    if (ep.isLoad) {
      return _buildLoadingState();
    }

    if (ep.checklistModel == null || processItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off_outlined,
        title: 'No Results Found'.tr(),
        message: 'No data available'.tr(),
        onRetry: _loadReport,
      );
    }

    final sections = _groupChecklistItems(processItems);
    final imageItems = processItems
        .where((item) => _inputType(item) == 'image')
        .toList();

    return RefreshIndicator(
      color: ColorManager.ecoGreen,
      onRefresh: _loadReport,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
        children: [
          for (final section in sections)
            _buildChecklistSection(section, ap, ep),
          if (imageItems.isNotEmpty) _buildImageSection(ap, ep, imageItems),
          _buildAuditTrail(ep, processItems),
          const SizedBox(height: 72),
        ],
      ),
    );
  }

  Widget _buildChecklistSection(
    _ChecklistSection section,
    AuthProvider ap,
    ProjectProvider ep,
  ) {
    final counters = <int, int>{};
    final completion = _completionStats(section.items);
    final progressColor = _progressColor(completion.ratio);
    final percent = (completion.ratio * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: section.items.length <= 8,
          tilePadding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          childrenPadding: const EdgeInsets.only(bottom: 10),
          leading: SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: completion.ratio,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey.shade200,
                  color: progressColor,
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            section.name.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${completion.done}/${completion.total} ${'Selected'.tr()}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Text(
                    //   '${'Count'.tr()}: ${section.items.length}',
                    //   style: TextStyle(
                    //     color: Colors.grey.shade600,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completion.ratio,
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade200,
                    color: progressColor,
                  ),
                ),
              ],
            ),
          ),
          children: [
            for (final item in section.items)
              buildChecklistItem(
                item,
                _nextChecklistIndex(counters, item),
                _canEdit(ap, ep, item),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
    AuthProvider ap,
    ProjectProvider ep,
    List<EcmReportMasterModel> imageItems,
  ) {
    final uploadedCount = imageItems.where(_itemCompleted).length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: ColorManager.skyBlue.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.collections_outlined,
                  color: ColorManager.skyBlue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'img'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _buildInfoChip(
                Icons.cloud_done_outlined,
                '$uploadedCount/${imageItems.length}',
                color: _progressColor(uploadedCount / imageItems.length),
              ),
            ],
          ),
          const SizedBox(height: 12),
          EcmImagePicker(isEdit: _canEdit(ap, ep, imageItems.first)),
        ],
      ),
    );
  }

  Widget _buildAuditTrail(
    ProjectProvider ep,
    List<EcmReportMasterModel> processItems,
  ) {
    if (processItems.isEmpty) return const SizedBox.shrink();

    final first = processItems.first;
    final cards = <Widget>[];

    if (processItems.any((item) => item.workedOn != null)) {
      cards.add(
        _buildAuditCard(
          title: 'Submitted'.tr(),
          icon: Icons.cloud_done_outlined,
          color: ColorManager.skyBlue,
          rows: [
            _AuditRow('By'.tr(), ep.workedBy ?? ''),
            _AuditRow('On'.tr(), ep.getDateFormated(first.workedOn)),
            _AuditRow('Remarks'.tr(), first.remark ?? ''),
          ],
        ),
      );
    }

    if (processItems.any((item) => item.approvedBy != null)) {
      final title = ep
          .approvedTitle(
            ep.selectedReportProcess?.processName,
            _statusValue(first.approvedStatus),
          )
          .tr();
      cards.add(
        _buildAuditCard(
          title: title,
          icon: Icons.verified_outlined,
          color: ColorManager.ecoGreen,
          rows: [
            _AuditRow('By'.tr(), ep.approvedBy ?? 'Unknown'),
            _AuditRow('On'.tr(), ep.getDateFormated(first.approvedOn)),
            _AuditRow(
              'Remarks'.tr(),
              first.approvalRemark ?? 'No Remark Available',
            ),
          ],
        ),
      );
    }

    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(children: cards);
  }

  Widget _buildAuditCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<_AuditRow> rows,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: color.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                  children: [
                    TextSpan(
                      text: '${row.label}: ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: row.value),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildBottomBar(
    AuthProvider ap,
    ProjectProvider ep,
    ConnectivityProvider cp,
    List<EcmReportMasterModel> processItems,
  ) {
    final widgets = <Widget>[];

    if (!cp.isOnline) {
      widgets.add(_buildOfflineBanner());
    }

    final actions = _buildReportActions(ap, ep, cp, processItems);
    if (actions.isNotEmpty) {
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final isNarrow = constraints.maxWidth < 420;
              final itemWidth = isNarrow
                  ? constraints.maxWidth
                  : (constraints.maxWidth - spacing * (actions.length - 1)) /
                        actions.length;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final action in actions)
                    SizedBox(width: itemWidth, height: 48, child: action),
                ],
              );
            },
          ),
        ),
      );
    }

    if (widgets.isEmpty) return null;

    return SafeArea(
      top: false,
      child: Column(mainAxisSize: MainAxisSize.min, children: widgets),
    );
  }

  List<Widget> _buildReportActions(
    AuthProvider ap,
    ProjectProvider ep,
    ConnectivityProvider cp,
    List<EcmReportMasterModel> processItems,
  ) {
    if (processItems.isEmpty || ep.selectedReportProcess?.processName == null) {
      return const [];
    }

    final processName = ep.selectedReportProcess!.processName;
    final status = _statusValue(processItems.first.approvedStatus);
    final actions = <Widget>[];

    if (ep.isSubmit(ap.isManager, processName, status)) {
      actions.add(
        _buildActionButton(
          icon: cp.isOnline
              ? Icons.cloud_upload_outlined
              : Icons.save_alt_outlined,
          label: cp.isOnline ? 'Submit'.tr() : 'Save Offline'.tr(),
          color: cp.isOnline ? ColorManager.ecoGreen : ColorManager.cantaloupe,
          onPressed: () async {
            if (cp.isOnline) {
              await showSubmitDialog(context, processItems);
            } else {
              await showOfflineSubmitDialog(context, processItems);
            }
          },
        ),
      );
    }

    if (ep.isApproved(ap.isManager, processName, status)) {
      actions.addAll([
        _buildActionButton(
          icon: Icons.verified_outlined,
          label: 'Approve'.tr(),
          color: ColorManager.ecoGreen,
          onPressed: () async {
            await showApproveDialog(context, processItems);
          },
        ),
        _buildActionButton(
          icon: Icons.mode_comment_outlined,
          label: 'Comment'.tr(),
          color: ColorManager.cantaloupe,
          onPressed: () async {
            await showCommentDialog(context, processItems);
          },
        ),
      ]);
    }

    return actions;
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: ColorManager.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      color: ColorManager.cantaloupe,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Text(
        'You are offline. Some functionalities may be limited.'.tr(),
        style: const TextStyle(
          color: ColorManager.pureWhite,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: ColorManager.ecoGreen),
          const SizedBox(height: 14),
          Text(
            'Please wait'.tr(),
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    Future<void> Function()? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('Retry'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: chipColor, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 142),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.55)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget buildChecklistItem(EcmReportMasterModel item, int index, bool isEdit) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isBullet = _isOne(item.isBullet);
    final isHeader = _isOne(item.isBulletHeader);
    final completed = _itemCompleted(item);
    final accentColor = completed ? ColorManager.ecoGreen : Colors.grey;
    final inputType = _inputType(item);

    void showManagerSnack() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Managers are not allowed to change the report.',
            style: TextStyle(
              color: ColorManager.pureWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: ColorManager.hotCoral,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (inputType == 'boolean') {
      return _buildBooleanChecklistItem(
        item,
        index,
        isEdit,
        ap.isManager,
        isBullet,
        isHeader,
        completed,
        showManagerSnack,
      );
    }

    final input = _buildInputControl(
      item,
      isEdit,
      ap.isManager,
      showManagerSnack,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHeader
            ? Theme.of(context).colorScheme.primary.withOpacity(0.06)
            : ColorManager.pureWhite,
        border: Border.all(
          color: isHeader
              ? Theme.of(context).colorScheme.primary.withOpacity(0.35)
              : accentColor.withOpacity(completed ? 0.32 : 0.18),
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 540;
          final description = _buildChecklistDescription(
            item,
            index,
            isBullet,
            isHeader,
            completed,
          );

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                description,
                if (input != null) ...[
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerRight, child: input),
                ],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: description),
              if (input != null) ...[
                const SizedBox(width: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: input,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildBooleanChecklistItem(
    EcmReportMasterModel item,
    int index,
    bool isEdit,
    bool isManager,
    bool isBullet,
    bool isHeader,
    bool completed,
    VoidCallback showManagerSnack,
  ) {
    const selectedColor = Color(0xFFE5F5F2);
    const checkColor = Color(0xFF168A84);
    final canTap = isEdit || isManager;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: !canTap
            ? null
            : () {
                if (!isEdit && isManager) {
                  showManagerSnack();
                  return;
                }

                setState(() {
                  item.value = completed ? '' : 'OK';
                });
              },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: completed ? selectedColor : ColorManager.pureWhite,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: completed
                  ? checkColor.withOpacity(0.08)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: _buildReferenceCheckbox(completed),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description ?? '',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: isHeader
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    if (!isHeader && !isBullet)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          '#$index',
                          style: TextStyle(
                            color: completed ? checkColor : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferenceCheckbox(bool checked) {
    const checkColor = Color(0xFF168A84);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: checked ? checkColor : ColorManager.pureWhite,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: checked ? checkColor : Colors.grey.shade800,
          width: 1.5,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, color: ColorManager.pureWhite, size: 14)
          : null,
    );
  }

  Widget _buildChecklistDescription(
    EcmReportMasterModel item,
    int index,
    bool isBullet,
    bool isHeader,
    bool completed,
  ) {
    final accentColor = completed ? ColorManager.ecoGreen : Colors.grey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isBullet)
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          )
        else
          const SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: Icon(Icons.circle, size: 7, color: Colors.black54),
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              item.description ?? '',
              textAlign: TextAlign.left,
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                height: 1.3,
                fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500,
                color: isHeader
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildInputControl(
    EcmReportMasterModel item,
    bool isEdit,
    bool isManager,
    VoidCallback showManagerSnack,
  ) {
    final inputType = _inputType(item);
    final isHeader = _isOne(item.isBulletHeader);

    if ((inputType == 'text' || inputType == 'float') && !isHeader) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: !isEdit && isManager ? showManagerSnack : null,
        child: SizedBox(
          width: 150,
          child: DecimalNumberPickerField(
            initialValue: item.value,
            isEdit: isEdit,
            suffix: item.inputText?.toString(),
            onChanged: (val) {
              setState(() => item.value = val);
            },
          ),
        ),
      );
    }

    if (inputType == 'pdf') {
      return Tooltip(
        message: 'PDF',
        child: IconButton.filledTonal(
          icon: Image.asset("assets/images/pdf.png", cacheHeight: 25),
          onPressed: () async {
            if (!isEdit && isManager) {
              showManagerSnack();
              return;
            }
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return PdfWidget(report: item);
              },
            );
          },
        ),
      );
    }

    if (inputType == 'json') {
      return Tooltip(
        message: 'JSON',
        child: IconButton.filledTonal(
          icon: const Icon(Icons.code, size: 20),
          onPressed: () {
            if (!isEdit && isManager) {
              showManagerSnack();
            }
          },
        ),
      );
    }

    return null;
  }

  List<EcmReportMasterModel> _itemsForSelectedProcess(ProjectProvider ep) {
    final processId = ep.selectedReportProcess?.processId;
    final items = ep.checklistModel ?? const <EcmReportMasterModel>[];

    if (processId == null) return const <EcmReportMasterModel>[];

    return items.where((item) => item.processId == processId).toList();
  }

  List<_ChecklistSection> _groupChecklistItems(
    List<EcmReportMasterModel> items,
  ) {
    final order = <String>[];
    final grouped = <String, List<EcmReportMasterModel>>{};

    for (final item in items) {
      if (_inputType(item) == 'image') continue;

      final rawName = item.subProcessName?.trim();
      final sectionName = rawName == null || rawName.isEmpty
          ? 'Report'.tr()
          : rawName;

      grouped.putIfAbsent(sectionName, () {
        order.add(sectionName);
        return <EcmReportMasterModel>[];
      });
      grouped[sectionName]!.add(item);
    }

    return [
      for (final sectionName in order)
        _ChecklistSection(sectionName, grouped[sectionName]!),
    ];
  }

  int _nextChecklistIndex(Map<int, int> counters, EcmReportMasterModel item) {
    if (_isOne(item.isBullet)) return 0;

    final key = item.subProcessId ?? 0;
    counters[key] = (counters[key] ?? 0) + 1;
    return counters[key]!;
  }

  bool _canEdit(
    AuthProvider ap,
    ProjectProvider ep,
    EcmReportMasterModel item,
  ) {
    final processName = ep.selectedReportProcess?.processName;
    if (processName == null) return false;

    return ep.isEdit(
      ap.isManager,
      processName,
      _statusValue(item.approvedStatus),
    );
  }

  int _statusFromReportOrNode(
    ProjectProvider ep,
    List<EcmReportMasterModel> items,
  ) {
    if (items.isNotEmpty) {
      return _statusValue(items.first.approvedStatus);
    }

    final processName = ep.selectedReportProcess?.processName;
    final node = ep.selectedNode;
    if (processName == null || node == null) return 0;

    return ep.getProStatus(processName, node);
  }

  Color _statusColor(String processName, int status) {
    final lowerName = processName.toLowerCase();
    final isShortFlow =
        lowerName.contains('dry comm') ||
        lowerName.contains('wet comm') ||
        lowerName.contains('auto');

    if (status == 0) return ColorManager.hotCoral;
    if (isShortFlow && status == 2) return ColorManager.ecoGreen;
    if (!isShortFlow && status == 3) return ColorManager.ecoGreen;
    if (status == 3 || status == 4) return ColorManager.cantaloupe;
    if (!isShortFlow && status == 1) return ColorManager.skyBlue;
    return Colors.blue.shade800;
  }

  Color _progressColor(double ratio) {
    if (ratio >= 1) return ColorManager.ecoGreen;
    if (ratio >= 0.65) return Colors.blue.shade700;
    if (ratio > 0) return ColorManager.cantaloupe;
    return ColorManager.hotCoral;
  }

  _CompletionStats _completionStats(List<EcmReportMasterModel> items) {
    final actionableItems = items.where(_isActionableItem).toList();
    final completedItems = actionableItems.where(_itemCompleted).length;

    return _CompletionStats(completedItems, actionableItems.length);
  }

  bool _isActionableItem(EcmReportMasterModel item) {
    if (_isOne(item.isBulletHeader)) return false;

    switch (_inputType(item)) {
      case 'boolean':
      case 'text':
      case 'float':
      case 'pdf':
      case 'json':
      case 'image':
        return true;
      default:
        return false;
    }
  }

  bool _itemCompleted(EcmReportMasterModel item) {
    if (!_isActionableItem(item)) return false;

    if (_inputType(item) == 'boolean') {
      return item.value == 'OK';
    }

    return _hasValue(item.value) || item.imageByteArray != null;
  }

  bool _hasValue(dynamic value) {
    final text = value?.toString().trim();
    return text != null && text.isNotEmpty;
  }

  int _statusValue(dynamic status) {
    if (status is int) return status;
    return int.tryParse(status?.toString() ?? '0') ?? 0;
  }

  bool _isOne(dynamic value) {
    return value == 1 || value == '1';
  }

  String _inputType(EcmReportMasterModel item) {
    return (item.inputType ?? '').toLowerCase();
  }
}

class _ChecklistSection {
  const _ChecklistSection(this.name, this.items);

  final String name;
  final List<EcmReportMasterModel> items;
}

class _AuditRow {
  const _AuditRow(this.label, this.value);

  final String label;
  final String value;
}

class _CompletionStats {
  const _CompletionStats(this.done, this.total);

  final int done;
  final int total;

  int get pending => total - done;
  double get ratio => total == 0 ? 0 : done / total;
}
