// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageReportModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Utils/Functions/ImagePriviewWidget.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DamageStatusReport extends StatefulWidget {
  static const routeName = "/DamageStatusReport";
  const DamageStatusReport({super.key});

  @override
  State<DamageStatusReport> createState() => _DamageStatusReportState();
}

class _DamageStatusReportState extends State<DamageStatusReport> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = context.read<DamageProvider>();
      final ap = context.read<AuthProvider>();

      dp.getDamageReport(
        deviceId: dp.getDeviceIdBySource(dp.source),
        source: dp.source!,
        projectId: ap.selectedProject!.id!,
      );

      dp.toggleTranslation(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = context.watch<AuthProvider>();
    final dp = context.watch<DamageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          '${dp.getNodeName(dp.source!, dp.selectedNode!)} ${'Report'.tr()}',
          ap.selectedProject,
        ),
        actions: [
          IconButton(
            onPressed: () => ChangeLanguage(context),
            icon: const Icon(Icons.translate_outlined),
          ),
        ],
      ),
      body: _buildBody(dp),
    );
  }

  Widget _buildBody(DamageProvider dp) {
    if (dp.isLoad) {
      return const Center(
        child: CircularProgressIndicator(color: ColorManager.ecoGreen),
      );
    }

    if (dp.damageReport == null || dp.damageReport!.isEmpty) {
      return const Center(
        child: Text(
          'No data available for this process',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildProcessList(dp),
          const SizedBox(height: 16),
          // if (dp.damageReport!.any((item) => item.imageByteArray != null))
          _buildImageList(dp),
          _buildSubmissionInfo(dp),
        ],
      ),
    );
  }

  Widget _buildProcessList(DamageProvider dp) {
    return Column(
      children: dp.damageProcess.map((subProcess) {
        final filteredItems = dp.damageReport!
            .where(
              (item) =>
                  item.type == subProcess &&
                  item.type?.toLowerCase() != 'image',
            )
            .where((item) => item.value != '0')
            .toList();

        if (filteredItems.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: ExpansionTile(
            title: Text(
              subProcess.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.15),
            collapsedBackgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.2,
              ),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.2,
              ),
            ),
            children: List.generate(
              filteredItems.length,
              (index) => buildChecklistItem(
                filteredItems[index],
                index + 1,
                dp.isEdit,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageList(DamageProvider dp) {
    final imageItems = dp.damageReport!
        .where(
          (e) =>
              e.type?.toLowerCase() == 'image' &&
              e.value != null &&
              e.imageByteArray != null,
        )
        .toList();

    if (imageItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageItems.length, // ✅ dynamic length
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.5, // tweak for image proportions
        ),
        itemBuilder: (context, index) {
          final imageItem = imageItems[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PreviewImageWidget(imageItem.imageByteArray!),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageItem.imageByteArray ?? Uint8List(0),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(imageItem.damage ?? ''),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmissionInfo(DamageProvider dp) {
    final submittedItems =
        dp.damageReport?.where((item) => item.userId != null).toList() ?? [];

    if (submittedItems.isEmpty) return const SizedBox.shrink();

    final firstItem = dp.damageReport!.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submitted'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('${'By'.tr()} : ${dp.workedBy ?? ''}'),
          Text('${'On'.tr()} : ${dp.getDateFormated(firstItem.datetime)}'),
          Text('${'Remarks'.tr()} : ${firstItem.remark ?? ''}'),
        ],
      ),
    );
  }

  Widget buildChecklistItem(DamageReportModel item, int index, bool isEdit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                item.damage ?? '',
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
