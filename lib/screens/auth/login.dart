
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:provider/provider.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../controllers/auth_controller/auth_controller.dart';
import '../../controllers/guest_controller/guest_controller.dart';
import '../../core/constant/gradients.dart';

import '../../core/route/route_paths.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../models/common_apis/cityModel.dart';
import '../../utils/widgets/gradient_button.dart';
import '../../utils/widgets/web_view_screen.dart';
import '../../utils/widgets/widgets.dart';
import '../guest/guestProfile/guest_edit_profile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<DropdownSearchState<dynamic>> dropDownkey = GlobalKey<DropdownSearchState<dynamic>>();
  // final dropDownkey = GlobalKey<DropdownSearchState<String>>();
  FocusNode nameFocusNode = FocusNode();
  bool checkValidate = false;
  bool forReferral = false;
  bool showReferral = false;
  bool checkBox = false;
  String countryCode ='91';
  String stateId ='';
  String cityId ='';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchState(
        context: context,
      );
    });
    super.initState();
  }
  bool check =false;



  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController referralCodeCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color? textColor2 =const Color(0xFF909090);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: Stack(
        children: [
          Image.asset(AppAssets.authbackgroundimage,
              fit: BoxFit.fitWidth, width: double.infinity),
          Form(
            key: signInFormKey,
            child: ListView(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 150),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.13, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        checkValidate==false?  'Welcome!' :'Register',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 8, bottom: size.height * 0.06),
                        child:  Text(
                          checkValidate==false?  'Login Now To Continue Your Journey':'Fill Your True Information',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      IntlPhoneField(
                        controller:phoneCtrl ,
                        decoration: const InputDecoration(
                          hintText: 'Enter Mobile No.',
                          border: InputBorder.none,
                          counterText: ''
                        ),
                         autovalidateMode: AutovalidateMode.disabled,
                        initialCountryCode: 'IN',
                        dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                        dropdownIconPosition: IconPosition.trailing,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onCountryChanged: (value) {
                          countryCode=value.fullCountryCode;
                          setState(() {});
                        },
                        onChanged: (phone) {

                          if (phone.number.length == 10) {
                            validatePhone();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom: 8),
                  child: CustomeText(
                    text: 'Use only WhatsApp no.',
                    color: textColor2,
                  ),
                ),
                Visibility(
                    visible: checkValidate == true,
                    child: CustomTextField(
                      controller: nameCtrl,

                      autofocus: checkValidate,
                      textCapitalization: TextCapitalization.words,
                      validator: (val) {
                        return Validator.fullNameValidator(val);
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                      ],
                      onChanged: (value) {},
                      hintText: 'Enter First Name',
                      autofillHints: const [AutofillHints.name],
                      margin: const EdgeInsets.only(top: 1, bottom: 1),
                    ),),
                // if (checkValidate == true)
                  // CustomTextField(
                  //   controller: nameCtrl,
                  //   autofocus: checkValidate,
                  //   textCapitalization: TextCapitalization.words,
                  //   validator: (val) {
                  //     return Validator.fullNameValidator(val);
                  //   },
                  //   inputFormatters: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                  //
                  //   ],
                  //   onChanged: (value) {},
                  //   hintText: 'Enter First Name',
                  //   autofillHints: const [AutofillHints.name],
                  //   margin: const EdgeInsets.only(top: 1, bottom: 1),
                  // ),
                if (checkValidate == true)
                  CustomTextField(
                    controller: lastNameCtrl,
                    textCapitalization: TextCapitalization.words,


                    // validator: (val) {
                    //   return Validator.fullNameValidator(val);
                    // },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))

                    ],
                    onChanged: (value) {},
                    hintText: 'Enter Last Name',
                    autofillHints: const [AutofillHints.name],
                    margin:  EdgeInsets.only(top: 18,bottom: countryCode=='91'?0:18),
                  ),
                if (checkValidate == true &&countryCode=='91')
                  Consumer<GuestControllers>(
                    builder: (context, controller, child) {
                      return

                        CustomDropdown(
                        mandatory: '*',
                        padding:  const EdgeInsets.only(top: kPadding,bottom: kPadding),
                        hintText: 'Select State',
                        onChanged: (v) async {

                          check=true;
                          stateId = controller.satesModel?.data?.firstWhere((element) {
                              return element.name == v;
                            },).id.toString() ?? '';
                        ;

                          if (stateId.isNotEmpty == true) {

                            CityModel? cityModel= await context.read<GuestControllers>().fetchCity(
                              context: context,
                              stateId: stateId,
                            );
                            if(cityModel?.status==true){
                              dropDownkey.currentState?.clear();
                              setState(() {});
                            }else{
                              dropDownkey.currentState?.clear();
                              setState(() {});
                            }
                          }

                        },
                        // selectedItem: stateName,
                        title: 'State',
                        listItem: controller.satesModel?.data?.map((e) => e.name).toList(),
                      );
                    },
                  ),

                if (checkValidate == true &&countryCode=='91')
                Consumer<GuestControllers>(
                  builder: (context, controller, child) {
                    return
                      CustomDropdown(
                      dropDownkey: dropDownkey,
                      padding:  const EdgeInsets.only(top: 0,bottom: kPadding),
                      mandatory: '*',
                      hintText: 'Select City',
                      onChanged: (v) {
                        cityId = controller.cityModel?.data
                            ?.firstWhere(
                              (element) {
                            return element.name == v;
                          },
                        )
                            .id
                            .toString() ??
                            '';
                      },
                      title: 'City',
                      listItem: controller.cityModel?.data?.map((e) => e.name).toList(),
                    );
                  },
                ),
                // if(showReferral==true )
                // const Padding(
                //   padding: EdgeInsets.only(bottom: 12),
                //   child: Text(
                //     'Enter Referral Code',
                //     style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w800),
                //   ),
                // ),
                if (showReferral == true)
                  CustomTextField(
                    controller: referralCodeCtrl,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    hintText: 'Referral Code',

                    validator: (value) {
                      return Validator.referralValidator(value);
                    },
                    // autofillHints: const [AutofillHints.name],
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          if (checkValidate == true)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(
                  width: 20,
                  child: Checkbox(
                    // fillColor: MaterialStateColor.resolveWith(
                    //   (states) {
                    //     return checkBox==false?Colors.black: Colors.black;
                    //   },
                    // ),
                    focusColor: MaterialStateColor.resolveWith((states) {
                      return Colors.black;
                    }),
                    // side: BorderSide.none,
                    activeColor: MaterialStateColor.resolveWith((states) {
                      return Colors.black;
                    }),

                    onChanged: (bool? value) {
                      checkBox =value!;
                      setState(() {});
                    }, value: checkBox,
                  ),
                ),
                SizedBox(
                  width: size.width*0.04,
                ),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: 'Terms & conditions',
                          url: 'https://api.gtp.proapp.in/api/v1/terms_and_condition',
                        ));
                  },
                  child: CustomeText(

                    text: 'I agree to the Terms and Conditions',
                    fontSize: 14,
                    // color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          GradientButton(
            height: 70,
            borderRadius: 18,
            blur: 10,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () {

              if (signInFormKey.currentState?.validate() == true) {
                sendOtp();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  checkValidate == true?'Register':'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 153.80,
                height: 5.74,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(114.78),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
        ],
      ),
      // bottomNavigationBar:
    );
  }

  Padding prefixIcon({required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          const SizedBox(
            height: 20,
            child: VerticalDivider(
              width: 1,
              thickness: 1.1,
            ),
          )
        ],
      ),
    );
  }

  Future validatePhone() async {
    Validatemobile? validate = await context.read<AuthControllers>().validateMobile(context: context, mobile: phoneCtrl.text,);
    if (validate?.status == true) {
      nameCtrl.text = validate?.data?.firstName ?? '';
      lastNameCtrl.text = validate?.data?.lastName ?? '';
      addressCtrl.text = validate?.data?.address ?? '';
      cityId =validate?.data?.cityId.toString() ?? '';
      stateId =validate?.data?.stateId.toString() ?? '';
      checkValidate = false;
      forReferral = true;
      showReferral = false;
      checkBox =true;

      setState(() {});

    } else {
      nameCtrl.clear();
      lastNameCtrl.clear();
      addressCtrl.clear();
      referralCodeCtrl.clear();
      checkValidate = true;
      forReferral = false;
      showReferral = true;
      setState(() {});
    }


  }

  Future sendOtp() async {
    if(checkBox==false){
      showSnackBar(context: context, color: Colors.green, text:'Please check the terms & condition');
    }else{
      await context.read<AuthControllers>().sendOtp(
          context: context,
          mobile: phoneCtrl.text,
          isMobileValidated: forReferral,
          firstName: nameCtrl.text,
          lastName: lastNameCtrl.text,
          referralCode: referralCodeCtrl.text,
          cityId: cityId,
          stateId:stateId,
          countryCode: countryCode);
    }


    // setState(() {});
    // print('check status ${validate?.status}');
  }
}
