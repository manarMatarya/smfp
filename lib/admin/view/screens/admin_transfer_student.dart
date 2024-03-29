import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smfp/admin/logic/controller/admin_controller.dart';
import 'package:smfp/admin/view/screens/get_complaints.dart';
import 'package:smfp/utiles/theme.dart';
import 'package:smfp/view/widgets/custom_shimmer.dart';
import 'package:smfp/view/widgets/homework/homework_skelton.dart';
import 'package:smfp/view/widgets/my_appbar.dart';
import 'package:smfp/view/widgets/no_data.dart';
import 'package:smfp/view/widgets/text_utils.dart';

// ignore: must_be_immutable
class TransferStudentsRequests extends StatelessWidget {
  TransferStudentsRequests({Key? key}) : super(key: key);
  AdminController controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    controller.studentNames.value = [];
    controller.transfers.value = [];
    controller.getTransfer();
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      TextUtils(
                        text: "طلبات نقل الطلاب",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GetX<AdminController>(
                        builder: ((controller) {
                          return controller.loadingTransfer.value
                              ? customShimmer(item: const HomeworkCardSkelton())
                              : controller.transfers.isEmpty
                                  ? const NoData()
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return buildItem(
                                          name: controller.studentNames[index],
                                          reason: controller
                                              .transfers[index].reason,
                                          id: controller.transfers[index].name,
                                          currentSchool: controller
                                              .transfers[index].currentSchool,
                                          toScool: controller
                                              .transfers[index].toSchool,
                                        );
                                      },
                                      itemCount: controller.transfers.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                    );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(
      {required String name,
      required String reason,
      required String id,
      required String currentSchool,
      required String toScool}) {
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)][100],
      //elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الطالب : ' + name,
                style: const TextStyle(
                  overflow: TextOverflow.visible,
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'دواعي النقل : ' + reason,
                style: const TextStyle(
                  overflow: TextOverflow.visible,
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text('قبول'),
                      onPressed: () {
                        controller.currentSchoolAccept(
                            id, currentSchool, toScool);
                      },
                    ),
                  ),
                  const Text(
                    '|',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Expanded(
                    child: TextButton(
                      child: const Text('رفض'),
                      onPressed: () {
                        controller.deletEDocument(id: id);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
