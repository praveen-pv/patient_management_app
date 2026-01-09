import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/common/colors.dart';
import '../../core/common/utils.dart';
import '../../providers/authProvider/auth_provider.dart';
import '../../providers/registerProvider/register_provider.dart';
import '../../widgets/add_treatment_dialog.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/selected_treatment.dart';
import '../../widgets/treatment_card.dart';
import '../pdfScreen/pdf_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final totalCtrl = TextEditingController();
  final discountCtrl = TextEditingController();
  final advanceCtrl = TextEditingController();
  final balanceCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String paymentMode = "Cash";
  DateTime? treatmentDate;
  String? hour;
  String? minute;

  String? selectedLocation;
  String? selectedBranch;

  List<SelectedTreatment> selectedTreatments = [];

  final locations = ["Kochi", "Kozhikode", "Kottayam", "Trivandrum"];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegisterProvider>();
      provider.getBranchReports();
       provider.getTreatmentReports();
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    totalCtrl.dispose();
    discountCtrl.dispose();
    advanceCtrl.dispose();
    balanceCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    nameCtrl.clear();
    phoneCtrl.clear();
    addressCtrl.clear();
    totalCtrl.clear();
    discountCtrl.clear();
    advanceCtrl.clear();
    balanceCtrl.clear();

    setState(() {
      selectedLocation = null;
      treatmentDate = null;
      hour = null;
      minute = null;
      paymentMode = "Cash";
      selectedTreatments.clear();
    });
    final provider = context.read<RegisterProvider>();
    provider.clearSelections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Register"),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(29.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Name"),
              CustomTextField(
                  hint: "Enter your full name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
          
                    return null;
                  },
                  controller: nameCtrl
              ),
          
              SizedBox(height: 16.h),
          
              _label("Whatsapp Number"),
              CustomTextField(
                hint: "Enter your Whatsapp number",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Whatsapp number';
                  }
          
                  return null;
                },
                controller: phoneCtrl,
              ),
          
              SizedBox(height: 16.h),
          
              _label("Address"),
              CustomTextField(
                hint: "Enter your  address",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
          
                  return null;
                },
                controller: addressCtrl,
              ),
          
              SizedBox(height: 16.h),
          
              _label("Location"),
              CustomDropdownField(
                hint: "Choose your location",
          
                value: selectedLocation,
                items: locations,
          
                onChanged: (val) {
                  setState(() => selectedLocation = val);
                },
              ),
          
              SizedBox(height: 16.h),
          
              _label("Branch"),
              Consumer<RegisterProvider>(
                builder: (context, provider, _) {
                  if (provider.isBranchLoading) {
                    return Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
          
                  if (provider.branchReportList.isEmpty) {
                    return const Text("No branches found");
                  }
          
                  return CustomDropdownField(
                    hint: "Select the branch",
                    value: provider.selectedBranchName,
                    items: provider.branchReportList
                        .map((branch) => branch.name)
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        provider.selectBranch(value);
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 16.h),
          
              if (selectedTreatments.isEmpty)
                _addTreatmentButton(color: Pallette.primaryColor),
          
              const SizedBox(height: 16),
          
              Column(
                children: List.generate(
                  selectedTreatments.length,
                  (index) => TreatmentCard(
                    index: index + 1,
                    treatment: selectedTreatments[index],
                    onRemove: () {
                      setState(() => selectedTreatments.removeAt(index));
                    },
                  ),
                ),
              ),
          
              if (selectedTreatments.isNotEmpty) ...[
                const SizedBox(height: 12),
                _addTreatmentButton(color: Colors.green),
              ],
          
              SizedBox(height: 24.h),
          
              _label("Total Amount"),
              CustomTextField(
                hint: "Enter your Total Amount",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Total Amount';
                  }
          
                  return null;
                },
                controller: totalCtrl,

              ),
          
              SizedBox(height: 16.h),
          
              _label("Discount Amount"),
              CustomTextField(
                hint: "Enter your Discount Amount",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Discount Amount';
                  }
          
                  return null;
                },
                controller: discountCtrl,
              ),
          
              SizedBox(height: 20.h),
          
              _label("Payment Option"),
              Row(
                children: [
                  _paymentRadio("Cash"),
                  _paymentRadio("Card"),
                  _paymentRadio("UPI"),
                ],
              ),
          
              SizedBox(height: 16.h),
          
              _label("Advance Amount"),
              CustomTextField(
                hint: "Enter your Advance Amount",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Advance Amount';
                  }
          
                  return null;
                },
                controller: advanceCtrl,
              ),
          
              SizedBox(height: 16.h),
          
              _label("Balance Amount"),
              CustomTextField(
                hint: "Enter your Balance Amount",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Balance Amount';
                  }
          
                  return null;
                },
                controller: balanceCtrl,
              ),
          
              SizedBox(height: 20.h),
          
              _label("Treatment Date"),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => treatmentDate = picked);
                  }
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Pallette.bgGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          treatmentDate == null
                              ? ""
                              : "${treatmentDate!.day.toString().padLeft(2, '0')}/"
                                    "${treatmentDate!.month.toString().padLeft(2, '0')}/"
                                    "${treatmentDate!.year}",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month,
                        color: Pallette.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
          
              SizedBox(height: 20.h),
          
              _label("Treatment Time"),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      hint: "Hour",
                      value: hour,
                      items: List.generate(12, (i) => "${i + 1}"),
                      onChanged: (v) => setState(() => hour = v),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomDropdownField(
                      hint: "Minutes",
                      value: minute,
                      items: const ["00", "15", "30", "45"],
                      onChanged: (v) => setState(() => minute = v),
                    ),
                  ),
                ],
              ),
          
              SizedBox(height: 30.h),
          
              CustomButton(text: "Save", onTap: _prepareApiData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentRadio(String value) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => paymentMode = value),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: paymentMode,
              activeColor: Pallette.primaryColor,
              onChanged: (v) => setState(() => paymentMode = v!),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }

  void _prepareApiData() async {
    final provider = context.read<RegisterProvider>();
    final authprovider = context.read<Authprovider>();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (context.read<RegisterProvider>().selectedBranchId == null) {
      return showSnackBarMsg(context, "Please select branch", Colors.red);
    }

    if (selectedTreatments.isEmpty) {
      return showSnackBarMsg(
        context,
        "Please add at least one treatment",
        Colors.red,
      );
    }

    if (treatmentDate == null || hour == null || minute == null) {
      return showSnackBarMsg(
        context,
        "Please select treatment date & time",
        Colors.red,
      );
    }

    final dateTime =
        "${treatmentDate!.day.toString().padLeft(2, '0')}/"
        "${treatmentDate!.month.toString().padLeft(2, '0')}/"
        "${treatmentDate!.year}-$hour:$minute";
    //
    // final treatments = selectedTreatments.map((e) => e.id).join(",");
    //
    // final male = selectedTreatments
    //     .where((e) => e.male > 0)
    //     .map((e) => e.id)
    //     .join(",");
    //
    // final female = selectedTreatments
    //     .where((e) => e.female > 0)
    //     .map((e) => e.id)
    //     .join(",");

    final treatmentsIds =
    selectedTreatments.map((t) => t.id).join(",");

    final male =
    selectedTreatments.map((t) => t.male).join(",");

    final female =
    selectedTreatments.map((t) => t.female).join(",");


    final excecutive = authprovider.user?.name.toString();
    print("excecutive  $excecutive");
    final registerdata = {
      "name": nameCtrl.text.trim(),
      //"excecutive": "test_user",
      "excecutive": "Admin",
      "phone": phoneCtrl.text.trim(),
      "address": addressCtrl.text.trim(),
      "payment": paymentMode,
      "total_amount": double.tryParse(totalCtrl.text) ?? 0,
      "discount_amount": double.tryParse(discountCtrl.text) ?? 0,
      "advance_amount": double.tryParse(advanceCtrl.text) ?? 0,
      "balance_amount": double.tryParse(balanceCtrl.text) ?? 0,

      "date_nd_time":
          "${treatmentDate!.day.toString().padLeft(2, '0')}/"
          "${treatmentDate!.month.toString().padLeft(2, '0')}/"
          "${treatmentDate!.year}-"
          "${hour!.padLeft(2, '0')}:${minute!.padLeft(2, '0')} AM",

      "branch": provider.selectedBranchId.toString(),

      "treatments": treatmentsIds,
      "male": male,
      "female": female,

      "id": "0",
    };
print("registerdata $registerdata");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool confirmation = await myalert(context, "Do you want Register!");
    if (!confirmation) return;
    bool? isregister = await context
        .read<RegisterProvider>()
        .isCreateNewRegister(
          authtoken: prefs.getString("access_token") ?? "",
          registerdata: registerdata,
        );
    print('isregister: $isregister');
    if (isregister == true) {
      showSnackBarMsg(context, 'Registered successfully!', Colors.green);

      final List<SelectedTreatment> pdfTreatments =
      selectedTreatments.map((t) {
        return SelectedTreatment(
          id: t.id,
          name: t.name,
          male: t.male,
          female: t.female,
        );
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptPreviewScreen(
            registerData: Map<String, dynamic>.from(registerdata),
            treatments: pdfTreatments,
            branchName: provider.selectedBranchName ?? "",
          ),
        ),
      );



      _clearForm();
    } else {
      showSnackBarMsg(context, "Failed to create registration", Colors.red);
    }
  }

  Widget _addTreatmentButton({required Color color}) {
    return InkWell(
      onTap: () async {
        final result = await showDialog<SelectedTreatment>(
          context: context,
          builder: (_) => const AddTreatmentDialog(),
        );

        if (result != null) {
          setState(() => selectedTreatments.add(result));
        }
      },
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Text(
          "+ Add Treatments",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}

Widget _label(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 13.sp, color: Pallette.textGrey),
    ),
  );
}
