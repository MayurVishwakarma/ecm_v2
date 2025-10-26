// ignore_for_file: file_names, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcmStatusCountDialog extends StatefulWidget {
  const EcmStatusCountDialog({super.key});

  @override
  State<EcmStatusCountDialog> createState() => _EcmStatusCountDialogState();
}

class _EcmStatusCountDialogState extends State<EcmStatusCountDialog> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final pp = Provider.of<ProjectProvider>(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              // color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        children: [
                          //Heading Part
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: ColorManager.ecoGreen,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          ap
                                              .getStateImage(
                                                '${ap.selectedProject!.state}'
                                                    .toString(),
                                              )
                                              .toString(),
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          ap.selectedProject!.projectName
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: (() {
                                        Navigator.pop(context);
                                      }),
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //Total Node Count
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorManager.ecoGreen,
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "${"Total Nodes".tr()}: ${pp.ecmStatusCount!.sCount}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Count Container
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //Mechanical
                                  if (pp.ecmStatusCount!.pendingMechanical !=
                                          0 &&
                                      pp.ecmStatusCount!.pendingMechanical !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'MECHANICAL INSTALLATION'
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingMechanical}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedMechanical}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyMechanical}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyMechanical}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedMechanical}',
                                                          ),
                                                        ],
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
                                  //Controll Unit
                                  if (pp.ecmStatusCount!.pendingErection != 0 &&
                                      pp.ecmStatusCount!.pendingErection !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'CONTROL UNIT ERECTION'
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingErection}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedErection}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyErection}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyErection}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedErection}',
                                                          ),
                                                        ],
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
                                  //Wet Comm
                                  if (pp.ecmStatusCount!.pendingWetComm != 0 &&
                                      pp.ecmStatusCount!.pendingWetComm != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'DRY COMMISSIONING'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedDryComm}',
                                                          ),
                                                        ],
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
                                  //Dry Comm
                                  if (pp.ecmStatusCount!.pendingDryComm != 0 &&
                                      pp.ecmStatusCount!.pendingDryComm != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'WET COMMISSIONING'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedWetComm}',
                                                          ),
                                                        ],
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
                                  //Tower Installation
                                  if (pp.ecmStatusCount!.pendingProcess1 != 0 &&
                                      pp.ecmStatusCount!.pendingProcess1 !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'TOWER INSTALLATION'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingProcess1}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedProcess1}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyProcess1}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyProcess1}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedProcess1}',
                                                          ),
                                                        ],
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
                                  if (pp.ecmStatusCount!.pendingProcess2 != 0 &&
                                      pp.ecmStatusCount!.pendingProcess2 !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'CONTROL UNIT ERECTION'
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingProcess2}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedProcess2}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyProcess2}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyProcess2}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedProcess2}',
                                                          ),
                                                        ],
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
                                  if (pp.ecmStatusCount!.pendingProcess3 != 0 &&
                                      pp.ecmStatusCount!.pendingProcess3 !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'COMMISSIONING'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingProcess3}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedProcess3}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyProcess3}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyProcess3}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedProcess3}',
                                                          ),
                                                        ],
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
                                  if (pp.ecmStatusCount!.pendingAutoDryComm !=
                                          0 &&
                                      pp.ecmStatusCount!.partiallyAutoDryComm !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'AUTO DRY COMMISSIONNING'
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingAutoDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedAutoDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyAutoDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyAutoDryComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedWetComm}',
                                                          ),
                                                        ],
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
                                  if (pp.ecmStatusCount!.pendingAutoWetComm !=
                                          0 &&
                                      pp.ecmStatusCount!.pendingAutoWetComm !=
                                          null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                height: 20,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.ecoGreen,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'AUTO WET COMMISSIONNING'
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/notcompletted.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Commented.png',
                                                            ),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Partially.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/Completed.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/fullydone.png',
                                                            ),
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${'Pending'.tr()}: ${pp.ecmStatusCount!.pendingAutoWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Commented'.tr()}: ${pp.ecmStatusCount!.rejectedAutoWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Partially Done'.tr()}: ${pp.ecmStatusCount!.partiallyAutoWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed'.tr()}: ${pp.ecmStatusCount!.fullyAutoWetComm}',
                                                          ),
                                                          Text(
                                                            '${'Fully Completed & Approved'.tr()}: ${pp.ecmStatusCount!.fullyApprovedWetComm}',
                                                          ),
                                                        ],
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
