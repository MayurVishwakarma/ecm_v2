// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Database/DBHelper.dart';
import 'package:ecm_v2/Core/Database/DamageDBHelper.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageReportModel.dart';
import 'package:ecm_v2/Core/Models/ECMReportModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Core/Providers/RoutineProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Common snack helper
void showSnack(BuildContext ctx, String message, Color color) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Online submit dialog
Future<void> showSubmitDialog(
  BuildContext context,
  List<EcmReportMasterModel> data,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();
  final siteEngineerTeamController = TextEditingController();
  final ep = Provider.of<ProjectProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (ap.selectedProject!.userName == 'dba')
                  TextFormField(
                    controller: siteEngineerTeamController,
                    decoration: InputDecoration(
                      labelText: 'Site Team Members',
                      hintText: 'Enter team member names',
                      prefixIcon: const Icon(Icons.groups),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (value.trim().length < 3) {
                          return 'Enter valid name(s)';
                        }
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Submit'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();
              final siteTeam = siteEngineerTeamController.text.trim();

              remarkController.clear();
              siteEngineerTeamController.clear();
              Navigator.of(dialogCtx).pop(); // Close dialog first
              final isSuccess = await ep.insertCheckList(
                ep.checklistModel!,
                remark,
                siteTeam,
                context,
              );

              if (!context.mounted) return;

              if (isSuccess) {
                await ep.getECMReport(
                  deviceId: ep.getDeviceIdBySource(ep.source),
                  processId: ep.selectedReportProcess!.processId!,
                  source: ep.source!,
                  projectId: ap.selectedProject!.id!,
                );

                await ep.deleteReport(data, ap.selectedProject!.id!);
                await ep.deleteNode(
                  ep.getDeviceIdBySource(ep.source!),
                  ep.source!,
                  ap.selectedProject!.id!,
                );

                showSnack(
                  context,
                  'Report submitted successfully!',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to submit report.', Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}

/// Offline submit dialog
Future<void> showOfflineSubmitDialog(
  BuildContext context,
  List<EcmReportMasterModel> data,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();
  final siteEngineerTeamController = TextEditingController();
  final ep = Provider.of<ProjectProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (ap.selectedProject!.userName == 'dba')
                  TextFormField(
                    controller: siteEngineerTeamController,
                    decoration: InputDecoration(
                      labelText: 'Site Team Members',
                      hintText: 'Enter team member names',
                      prefixIcon: const Icon(Icons.groups),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (value.trim().length < 3) {
                          return 'Enter valid name(s)';
                        }
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Save'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();
              final siteTeam = siteEngineerTeamController.text.trim();

              Navigator.of(dialogCtx).pop(); // Close dialog first

              remarkController.clear();
              siteEngineerTeamController.clear();

              final isSuccess = await ep.addNew(
                ep.checklistModel!,
                remark,
                ap.selectedProject!.id!,
              );

              var node = ep.selectedNode?..isSaved = isSuccess ? 1 : 0;
              ep.nodeList!
                      .singleWhere((n) => n.chakNo == node?.chakNo)
                      .isSaved =
                  node?.isSaved;

              await NodeDB.instance.insertOrUpdateOms(node!);

              if (!context.mounted) return;

              if (isSuccess) {
                showSnack(
                  context,
                  'Report saved successfully to offline storage.',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to save report. ❌', Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}

/// Online submit dialog
Future<void> showApproveDialog(
  BuildContext context,
  List<EcmReportMasterModel> data,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();
  final ep = Provider.of<ProjectProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Approve Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Approve'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              remarkController.clear();

              Navigator.of(dialogCtx).pop(); // Close dialog first
              final isSuccess = await ep.approveCheckList(
                ep.checklistModel!,
                remark,
                context,
              );

              if (!context.mounted) return;

              if (isSuccess) {
                await ep.getECMReport(
                  deviceId: ep.getDeviceIdBySource(ep.source),
                  processId: ep.selectedReportProcess!.processId!,
                  source: ep.source!,
                  projectId: ap.selectedProject!.id!,
                );
                showSnack(
                  context,
                  'Report approved successfully!',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to approve report.', Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}

/// Online submit dialog
Future<void> showCommentDialog(
  BuildContext context,
  List<EcmReportMasterModel> data,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();
  final ep = Provider.of<ProjectProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Comment Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.cantaloupe,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Comment'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              remarkController.clear();

              Navigator.of(dialogCtx).pop(); // Close dialog first
              final isSuccess = await ep.CommentCheckList(
                ep.checklistModel!,
                remark,
                context,
              );

              if (!context.mounted) return;

              if (isSuccess) {
                await ep.getECMReport(
                  deviceId: ep.getDeviceIdBySource(ep.source),
                  processId: ep.selectedReportProcess!.processId!,
                  source: ep.source!,
                  projectId: ap.selectedProject!.id!,
                );
                showSnack(
                  context,
                  'Report commented successfully!',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to comment on report.', Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> showDamageSubmitDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();

  final dp = Provider.of<DamageProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Submit'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              remarkController.clear();

              Navigator.of(dialogCtx).pop(); // Close dialog first

              if (dp.selectedMenu!.toLowerCase().contains('damage')) {
                /*                for (var report in dp.damageReport!) {
                  if ((report.value == '1' || report.value == 'yes') &&
                      report.imageByteArray == null) {
                    showSnack(
                      context,
                      'Please attach an image for house damage (ID: ${report.damage})',
                      Colors.red,
                    );
                    return;
                  }
                }
*/
                final isSuccess = await dp.insertDamageReport(
                  context,
                  dp.damageReport!,
                  remark,
                );
                if (isSuccess) {
                  await dp.getDamageReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                  );

                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('material')) {
                final isSuccess = await dp.insertMaterialReport(
                  context,
                  dp.materialReport!,
                  remark,
                );
                if (isSuccess) {
                  await dp.getMaterialReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                  );
                  await dp.deleteMaterialReport(
                    dp.materialReport!,
                    ap.selectedProject!.id!,
                    dp.source!,
                  );
                  await dp.deleteNode(
                    dp.getDeviceIdBySource(dp.source!),
                    dp.source!,
                    ap.selectedProject!.id!,
                  );

                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('information')) {
                final isSuccess = await dp.insertInfoReport(
                  context,
                  dp.infoReports!,
                  remark,
                  1,
                );
                if (isSuccess) {
                  await dp.getInfoReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                    type: 1,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('issue')) {
                final isSuccess = await dp.insertInfoReport(
                  context,
                  dp.infoReports!,
                  remark,
                  2,
                );
                if (isSuccess) {
                  await dp.getInfoReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                    type: 2,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }

              if (!context.mounted) return;
            },
          ),
        ],
      );
    },
  );
}

Future<void> showOfflineDamageSubmitDialog(
  BuildContext context,
  List<DamageReportModel> data,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();
  final dp = Provider.of<DamageProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Save'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              Navigator.of(dialogCtx).pop(); // Close dialog first

              remarkController.clear();

              final isSuccess = await dp.addDamageReport(
                dp.damageReport!,
                remark,
                ap.selectedProject!.id!,
              );

              var node = dp.selectedNode?..isSaved = isSuccess ? 1 : 0;
              dp.nodeList!
                      .singleWhere((n) => n.chakNo == node?.chakNo)
                      .isSaved =
                  node?.isSaved;

              await DamageNodeDB.instance.insertOrUpdateOms(node!);

              if (!context.mounted) return;

              if (isSuccess) {
                showSnack(
                  context,
                  'Report saved successfully to offline storage.',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to save report. ❌', Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> showOfflineMaterialSubmitDialog(
  BuildContext context,
  // List<MaterialReportModel> data,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();
  final dp = Provider.of<DamageProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Save'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              Navigator.of(dialogCtx).pop();

              remarkController.clear();

              final isSuccess = await dp.addMaterialReport(
                dp.materialReport!,
                remark,
                ap.selectedProject!.id!,
              );

              var node = dp.selectedNode?..isSaved = isSuccess ? 1 : 0;
              dp.nodeList!
                      .singleWhere((n) => n.chakNo == node?.chakNo)
                      .isSaved =
                  node?.isSaved;

              await DamageNodeDB.instance.insertOrUpdateOms(node!);

              if (!context.mounted) return;

              if (isSuccess) {
                showSnack(
                  context,
                  'Report saved successfully to offline storage.',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to save report. ❌', Colors.red);
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> showSyncDamageFormSubmitDialog(
  BuildContext context,
  List<DamageReportModel> report,
) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();

  final dp = Provider.of<DamageProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Submit'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              remarkController.clear();

              Navigator.of(dialogCtx).pop(); // Close dialog first

              if (dp.selectedMenu!.toLowerCase().contains('damage')) {
                final isSuccess = await dp.insertDamageReport(
                  context,
                  report,
                  remark,
                );
                if (isSuccess) {
                  await dp.getDamageReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('material')) {
                final isSuccess = await dp.insertMaterialReport(
                  context,
                  dp.materialReport!,
                  remark,
                );
                if (isSuccess) {
                  await dp.getMaterialReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('information')) {
                final isSuccess = await dp.insertInfoReport(
                  context,
                  dp.infoReports!,
                  remark,
                  1,
                );
                if (isSuccess) {
                  await dp.getInfoReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                    type: 1,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('issue')) {
                final isSuccess = await dp.insertInfoReport(
                  context,
                  dp.infoReports!,
                  remark,
                  2,
                );
                if (isSuccess) {
                  await dp.getInfoReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                    type: 2,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }

              if (!context.mounted) return;
            },
          ),
        ],
      );
    },
  );
}

Future<void> showRoutineSubmitDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();

  final rp = Provider.of<RoutineProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Submit'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              remarkController.clear();

              Navigator.of(dialogCtx).pop(); // Close dialog first

              final isSuccess = await rp.insertRoutineReport(
                context,
                rp.routineReport!,
                remark,
              );
              if (isSuccess) {
                await rp.getReport(
                  deviceId: rp.getDeviceIdBySource(rp.source),
                  projectId: ap.selectedProject!.id!,
                  langCode: context.locale.languageCode,
                );
                showSnack(
                  context,
                  'Report submitted successfully!',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to submit report.', Colors.red);
              }

              if (!context.mounted) return;
            },
          ),
        ],
      );
    },
  );
}

Future<void> showRectificationSubmitDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();

  final dp = Provider.of<DamageProvider>(context, listen: false);
  final ap = Provider.of<AuthProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.assignment, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Submit Report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark *',
                    hintText: 'Enter your remark',
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Remark is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Submit'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final remark = remarkController.text.trim();

              remarkController.clear();

              Navigator.of(dialogCtx).pop(); // Close dialog first

              final isSuccess = await dp.insertRectificationReport(
                context,
                dp.rectificationReport!,
                remark,
              );
              if (isSuccess) {
                await dp.getRectificationReport(
                  deviceId: dp.getRectificationDeviceIdBySource(dp.source),
                  source: dp.source!,
                  projectId: ap.selectedProject!.id!,
                );

                showSnack(
                  context,
                  'Report submitted successfully!',
                  Colors.green,
                );
              } else {
                showSnack(context, 'Failed to submit report.', Colors.red);
              }
              /*if (dp.selectedMenu!.toLowerCase().contains('damage')) {

                for (var report in dp.damageReport!) {


                  if ((report.value == '1' || report.value == 'yes') &&
                      report.imageByteArray == null) {
                    showSnack(
                      context,
                      'Please attach an image for house damage (ID: ${report.damage})',
                      Colors.red,
                    );
                    return;
                  }
                }

                final isSuccess = await dp.insertDamageReport(
                  context,
                  dp.damageReport!,
                  remark,
                );
                if (isSuccess) {
                  await dp.getDamageReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                  );

                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('material')) {
                final isSuccess = await dp.insertMaterialReport(
                  context,
                  dp.materialReport!,
                  remark,
                );
                if (isSuccess) {
                  await dp.getMaterialReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                  );
                  await dp.deleteMaterialReport(
                    dp.materialReport!,
                    ap.selectedProject!.id!,
                    dp.source!,
                  );
                  await dp.deleteNode(
                    dp.getDeviceIdBySource(dp.source!),
                    dp.source!,
                    ap.selectedProject!.id!,
                  );

                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('information')) {
                final isSuccess = await dp.insertInfoReport(
                  context,
                  dp.infoReports!,
                  remark,
                  1,
                );
                if (isSuccess) {
                  await dp.getInfoReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                    type: 1,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }
              if (dp.selectedMenu!.toLowerCase().contains('issue')) {
                final isSuccess = await dp.insertInfoReport(
                  context,
                  dp.infoReports!,
                  remark,
                  2,
                );
                if (isSuccess) {
                  await dp.getInfoReport(
                    deviceId: dp.getDeviceIdBySource(dp.source),
                    source: dp.source!,
                    projectId: ap.selectedProject!.id!,
                    type: 2,
                  );
                  showSnack(
                    context,
                    'Report submitted successfully!',
                    Colors.green,
                  );
                } else {
                  showSnack(context, 'Failed to submit report.', Colors.red);
                }
              }*/

              if (!context.mounted) return;
            },
          ),
        ],
      );
    },
  );
}
