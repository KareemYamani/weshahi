import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        'تنبيه',
        'يرجى تعبئة جميع الحقول',
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
            DesignAppBar(title: 'إتمام الطلب', onBack: () => Get.back()),
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
                                  isScarf ? 'وشاح تخرج' : 'قبعة تخرج',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isScarf
                                      ? 'اللون: ${scarfColor.name}'
                                      : 'لون القبعة: ${scarfColor.name}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isScarf
                                      ? 'النص: ${scarf.rightText} / ${scarf.leftText}'
                                      : 'النص: ${cap.topText}',
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
                            isScarf ? '150,000 ل.س' : '75,000 ل.س',
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
                        children: const [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'بيانات المستلم',
                            style: TextStyle(
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
                            decoration: const InputDecoration(
                              labelText: 'الاسم الكامل',
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
                                  decoration: const InputDecoration(
                                    labelText: 'رقم الجوال',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: city,
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
                            decoration: const InputDecoration(
                              labelText: 'المحافظة',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: addressController,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'العنوان',
                              hintText: 'المنطقة، الشارع...',
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
                        children: const [
                          Icon(
                            Icons.credit_card_outlined,
                            size: 18,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'طريقة الدفع',
                            style: TextStyle(
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
                        children: const [
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
                                  'الدفع عند الاستلام',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'ادفع نقداً عند استلام طلبك',
                                  style: TextStyle(
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
                        isScarf ? '150,000 ل.س' : '75,000 ل.س',
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'الإجمالي',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(label: 'تأكيد الطلب', onPressed: _submit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
