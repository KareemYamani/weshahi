import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../localization/local_manager.dart';
import 'package:weshahi/models/design_and_order_models.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../controllers/user_controller.dart';
import '../../data/app_data.dart';
import '../../data/design_options.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

import '../../widgets/design_app_bar.dart';
import '../../widgets/primary_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  String city = 'دمشق';

  late DesignItemType type;

  @override
  void initState() {
    super.initState();
    type = Get.arguments as DesignItemType? ?? DesignItemType.scarf;

    final user = Get.find<UserController>().user.value;
    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
    addressController = TextEditingController(text: user.address);
    city = user.city;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar(
        localManager.tr('common.alert'),
        localManager.tr('common.fill_required'),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final user = UserModel(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      city: city,
      address: addressController.text.trim(),
    );

    Get.find<UserController>().setUser(user);

    final designController = Get.find<DesignController>();
    final orderController = Get.find<OrderController>();

    if (type == DesignItemType.scarf) {
      orderController.createOrder(
        type: DesignItemType.scarf,
        user: user,
        scarf: designController.scarfDesign.value,
      );
    } else {
      orderController.createOrder(
        type: DesignItemType.cap,
        user: user,
        cap: designController.capDesign.value,
      );
    }

    Get.offAllNamed(Routes.success);
  }

  @override
  Widget build(BuildContext context) {
    final designController = Get.find<DesignController>();
    final scarf = designController.scarfDesign.value;
    final cap = designController.capDesign.value;

    final isScarf = type == DesignItemType.scarf;
    final scarfColor = scarfColors.firstWhere(
      (c) => c.id == scarf.colorId,
      orElse: () => scarfColors.first,
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            DesignAppBar(title: localManager.tr('order.title'), onBack: () => Get.back()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isScarf
                                  ? scarfColor.color
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                isScarf ? '🧣' : '🎓',
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isScarf
                                      ? localManager.tr('order.item.scarf')
                                      : localManager.tr('order.item.cap'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isScarf
                                      ? '${localManager.tr('order.summary.color')}: ${scarfColor.name}'
                                      : '${localManager.tr('order.summary.cap_color')}: ${scarfColor.name}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isScarf
                                      ? '${localManager.tr('order.summary.text')}: ${scarf.rightText} / ${scarf.leftText}'
                                      : '${localManager.tr('order.summary.text')}: ${cap.topText}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isScarf
                                ? '150,000 ${localManager.tr('common.currency')}'
                                : '75,000 ${localManager.tr('common.currency')}',
                            style: const TextStyle(
                              color: AppColors.accentDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            localManager.tr('order.recipient_info'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              labelText: localManager.tr('user_info.full_name_label'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 70,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '+963',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.textSec,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    labelText: localManager.tr('user_info.phone_label'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: city,
                            items: syriaCities
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => city = value);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: localManager.tr('user_info.city_label'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: addressController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              labelText: localManager.tr('user_info.address_label'),
                              hintText: localManager.tr('user_info.address_hint'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.credit_card_outlined,
                            size: 18,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            localManager.tr('order.payment_method'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFACC15)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  localManager.tr('order.cash_on_delivery'),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  localManager.tr('order.cod_desc'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        isScarf
                            ? '150,000 ${localManager.tr('common.currency')}'
                            : '75,000 ${localManager.tr('common.currency')}',
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        localManager.tr('order.total'),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(label: localManager.tr('order.confirm'), onPressed: _submit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
