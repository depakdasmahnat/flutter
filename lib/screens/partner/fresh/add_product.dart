import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/product_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/partner/fresh/utils/multi_filter_picker.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/partner/partner_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/dashboard/filters_model.dart';
import '../../../models/partner/category_model.dart';
import '../../../models/partner/product/my_products_model.dart';
import '../../../models/partner/product/product_templates_model.dart';
import '../../../models/partner/product/units_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/file_picker_controller.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import 'utils/single_category_picker.dart';
import 'utils/unit_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, this.templateData, this.productsData}) : super(key: key);
  final MyProductsData? productsData;

  final ProductTemplatesData? templateData;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late MyProductsData? productsData = widget.productsData;
  late bool? editMode = productsData != null ? true : false;
  late ProductTemplatesData? templateData = widget.templateData;

  LocalDatabase localDatabase = LocalDatabase();
  late TextEditingController nameCtrl = TextEditingController(text: templateData?.name ?? "");
  late TextEditingController descriptionCtrl = TextEditingController(text: templateData?.description ?? "");
  TextEditingController salesPriceCtrl = TextEditingController();
  TextEditingController mrpPriceCtrl = TextEditingController();
  TextEditingController initialInventoryCtrl = TextEditingController();

  TextEditingController searchCtrl = TextEditingController();
  late String? productImage = templateData?.image;
  late num? id = templateData?.id;
  File? image;
  double imageRadius = 150;

  GlobalKey<FormState> partnerSignUpKey = GlobalKey<FormState>();
  bool isServiceProvider = false;
  ServiceType? type;

  CategoryData? selectedCategory;
  List<CategoryData>? categoryData;

  CategoryData? selectedSubCategory;
  List<CategoryData>? subCategoryData;

  UnitData? selectedUnit;
  List<UnitData>? units;

  List<FiltersData?>? filtersData;
  List<FiltersData?>? selectedFilters = [];

  Future fetchFilters() async {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    return dashboardController.fetchFilters(context: context, type: type, searchKey: searchCtrl.text);
  }

  Future fetchUnits() async {
    ProductController productController = Provider.of<ProductController>(context, listen: false);
    return productController.fetchUnits(context: context, type: type);
  }

  fetchCategories() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    dashboardController.fetchCategories(context: context, searchKey: searchCtrl.text, type: type);
  }

  fetchSubCategories() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    dashboardController.fetchSubCategories(
        context: context,
        searchKey: searchCtrl.text,
        categoryId: "${selectedCategory?.id ?? ""}",
        type: type);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
        type = partnerController.serviceType;
        fetchFilters();
        if (templateData != null) {
          selectedCategory = CategoryData(id: templateData?.categoryId, name: templateData?.categoryName);
          selectedSubCategory =
              CategoryData(id: templateData?.subcategoryId, name: templateData?.subcategoryName);
          setState(() {});
        }

        fetchCategories();
        fetchSubCategories();
        fetchUnits();

        if (templateData != null) {
          // unitData = UnitData(id: productsData?.unitId, name: productsData?.unitName);
          List<FiltersData?>? newFilters = [];
          for (ProductFilters? data in templateData?.filters ?? []) {
            newFilters.add(
              FiltersData(
                id: data?.id,
                name: data?.name,
                selected: data?.selected,
              ),
            );
          }

          selectedFilters = newFilters;

          setState(() {});
        }

        if (editMode == true) {
          id = productsData?.id;
          nameCtrl.text = productsData?.name ?? nameCtrl.text;
          mrpPriceCtrl.text = productsData?.mrpPrice ?? mrpPriceCtrl.text;
          salesPriceCtrl.text = productsData?.price ?? salesPriceCtrl.text;
          descriptionCtrl.text = productsData?.description ?? descriptionCtrl.text;
          initialInventoryCtrl.text = "${productsData?.initialInventory ?? initialInventoryCtrl.text}";
          productImage = productsData?.image;
          setState(() {});

          selectedCategory = CategoryData(id: productsData?.categoryId, name: productsData?.categoryName);
          selectedSubCategory =
              CategoryData(id: productsData?.subcategoryId, name: productsData?.subcategoryName);
          selectedUnit = UnitData(id: productsData?.unitId, name: productsData?.unitName);

          setState(() {});

          List<FiltersData?>? newFilters = [];
          for (ProductFilters? data in productsData?.filters ?? []) {
            newFilters.add(
              FiltersData(
                id: data?.id,
                name: data?.name,
                selected: data?.selected,
              ),
            );
          }

          selectedFilters = newFilters;
          setState(() {});
        }
      },
    );
  }

  // String selectedCategoriesName() {
  //   List categoriesList = [];
  //   for (CategoryData? data in selectedCategory ?? []) {
  //     categoriesList.add(data?.name);
  //   }
  //
  //   String categories = categoriesList.isEmpty ? "Select Categories" : categoriesList.join(" ,");
  //   return categories;
  // }
  //
  // String selectedCategoriesIds() {
  //   List categoriesList = [];
  //   for (CategoryData? data in selectedCategory ?? []) {
  //     categoriesList.add(data?.id);
  //   }
  //
  //   String categories = categoriesList.isEmpty ? "" : categoriesList.join(",");
  //   return categories;
  // }

  @override
  Widget build(BuildContext context) {
    ProductController productController = Provider.of<ProductController>(context);
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    categoryData = dashboardController.categoryData;
    subCategoryData = dashboardController.subCategoryData;
    filtersData = dashboardController.filtersData;
    units = productController.unitData;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode == true ? "Update Product" : "Add Product",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        key: partnerSignUpKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: () {
                if (editMode == true ? (productsData?.status == "Pending") : templateData?.image == null) {
                  addImages();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (image != null)
                        ImageView(
                          height: imageRadius,
                          width: imageRadius,
                          borderRadiusValue: 6,
                          file: image,
                          fit: BoxFit.contain,
                          border: Border.all(color: Colors.grey.shade200),
                          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                        )
                      else if (productImage?.isNotEmpty == true)
                        ImageView(
                          height: imageRadius,
                          width: imageRadius,
                          borderRadiusValue: 6,
                          networkImage: "$productImage",
                          fit: BoxFit.contain,
                          border: Border.all(color: Colors.grey.shade200),
                          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                        )
                      else
                        ImageView(
                          height: imageRadius,
                          width: imageRadius,
                          borderRadiusValue: 6,
                          assetImage: AppImages.noImage,
                          fit: BoxFit.contain,
                          border: Border.all(color: Colors.grey.shade200),
                          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                        ),
                      const Positioned(
                        right: -6,
                        bottom: 10,
                        child: Icon(CupertinoIcons.add_circled_solid, size: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: nameCtrl,
              autofocus: true,
              enabled: isEnabledField(
                  field: editMode == true ? productsData?.name : templateData?.name,
                  status: productsData?.status),
              suffixIcon: isFieldLocked(
                  field: editMode == true ? productsData?.name : templateData?.name,
                  status: productsData?.status),
              validator: (val) {
                return Validator.nameValidator(val);
              },
              labelText: "Product Name",
              hintText: "Product  Name",
              style: textStyle(),
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
            ),
            CustomTextField(
              controller: descriptionCtrl,
              enabled: isEnabledField(
                  field: editMode == true ? productsData?.description : templateData?.description,
                  status: productsData?.status),
              suffixIcon: isFieldLocked(
                  field: editMode == true ? productsData?.description : templateData?.description,
                  status: productsData?.status),
              autofocus: true,
              labelText: "Description",
              hintText: "Description",
              minLines: 2,
              maxLines: 20,
              errorStyle: const TextStyle(color: Colors.red),
              // validator: (val) {
              //   if (val?.isEmpty == true) {
              //     return "Add Description";
              //   }
              //   return null;
              // },
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
            ),
            CustomTextField(
              controller: mrpPriceCtrl,
              autofocus: true,
              style: textStyle(),
              keyboardType: TextInputType.number,
              validator: (val) {
                return Validator.numberValidator(val);
              },
              labelText: "Mrp Price",
              prefixIcon: const Icon(Icons.attach_money),
              hintText: "0.0",
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
            ),
            CustomTextField(
              controller: salesPriceCtrl,
              autofocus: true,
              style: textStyle(),
              keyboardType: TextInputType.number,
              validator: (val) {
                return Validator.validatePrices(val ?? "", mrpPriceCtrl.text);
              },
              prefixIcon: const Icon(Icons.attach_money),
              labelText: "Sales Price",
              hintText: "0.0",
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
            ),
            CustomTextField(
              controller: initialInventoryCtrl,
              autofocus: true,
              labelText: "Initial Inventory",
              style: textStyle(),
              keyboardType: TextInputType.number,
              validator: (val) {
                return Validator.numberValidator(val);
              },
              hintText: "0",
              margin: const EdgeInsets.only(left: 24, right: 24, top: 14),
            ),
            GestureDetector(
              onTap: () {
                CustomBottomSheet.show(
                  context: context,
                  isScrollControlled: false,
                  enableDrag: true,
                  constraints: BoxConstraints(minHeight: size.height * 0.6),
                  physics: const ScrollPhysics(),
                  mainAxisSize: MainAxisSize.max,
                  title: "Select Unit",
                  body: UnitPicker(
                    selected: selectedUnit,
                    list: units,
                    onChanged: (UnitData? value) {
                      selectedUnit = value;
                      setState(() {});
                      fetchSubCategories();
                    },
                  ),
                  showTitleDivider: false,
                );
              },
              child: CustomTextField(
                autofocus: true,
                enabled: false,
                errorStyle: const TextStyle(color: Colors.red),
                suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                hintText: selectedUnit?.name ?? "Select Unit",
                hintStyle: selectedUnit != null ? textStyle() : null,
                validator: (val) {
                  if (selectedUnit == null) {
                    return "Select Unit";
                  }
                  return null;
                },
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
            ),
            GestureDetector(
              onTap: () {
                CustomBottomSheet.show(
                  context: context,
                  isScrollControlled: false,
                  enableDrag: true,
                  constraints: BoxConstraints(minHeight: size.height * 0.6),
                  physics: const ScrollPhysics(),
                  mainAxisSize: MainAxisSize.max,
                  title: "Select Category",
                  body: SingleCategoryPicker(
                    selected: selectedCategory,
                    list: categoryData,
                    onChanged: (CategoryData? value) {
                      selectedCategory = value;
                      setState(() {});
                      fetchSubCategories();
                    },
                  ),
                  showTitleDivider: false,
                );
              },
              child: CustomTextField(
                autofocus: true,
                enabled: false,
                errorStyle: const TextStyle(color: Colors.red),
                suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                hintText: selectedCategory?.name ?? "Select Category",
                hintStyle: selectedCategory != null ? textStyle() : null,
                validator: (val) {
                  if (selectedCategory == null) {
                    return "Select Category";
                  }
                  return null;
                },
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
            ),
            GestureDetector(
              onTap: () {
                CustomBottomSheet.show(
                  context: context,
                  isScrollControlled: false,
                  enableDrag: true,
                  constraints: BoxConstraints(minHeight: size.height * 0.6),
                  physics: const ScrollPhysics(),
                  mainAxisSize: MainAxisSize.max,
                  title: "Select Sub Category",
                  body: SingleCategoryPicker(
                    selected: selectedSubCategory,
                    list: subCategoryData,
                    onChanged: (CategoryData? value) {
                      selectedSubCategory = value;
                      setState(() {});
                    },
                  ),
                  showTitleDivider: false,
                );
              },
              child: CustomTextField(
                autofocus: true,
                enabled: false,
                errorStyle: const TextStyle(color: Colors.red),
                suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                hintText: selectedSubCategory?.name ?? "Select Sub Category",
                hintStyle: selectedSubCategory != null ? textStyle() : null,
                validator: (val) {
                  if (selectedSubCategory == null) {
                    return "Select Sub Category";
                  }
                  return null;
                },
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
            ),
            GestureDetector(
              onTap: () {
                CustomBottomSheet.show(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    constraints: BoxConstraints(minHeight: size.height * 0.6),
                    physics: const ScrollPhysics(),
                    mainAxisSize: MainAxisSize.max,
                    title: "Select Filter",
                    body: MultiFilterPicker(
                      selectedList: selectedFilters,
                      list: filtersData,
                      onChange: (List<FiltersData?>? value) {
                        selectedFilters = value;
                        setState(() {});
                      },
                    ),
                    showTitleDivider: false,
                    bottomNavBarHeight: 60,
                    bottomNavBar: CustomButton(
                      text: "Select",
                      fontSize: 18,
                      height: 45,
                      mainAxisAlignment: MainAxisAlignment.center,
                      onPressed: () {
                        context.pop();
                      },
                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    ));
              },
              child: CustomTextField(
                autofocus: true,
                enabled: false,
                errorStyle: const TextStyle(color: Colors.red),
                suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                hintText: productController.getFilterName(filterOptions: selectedFilters),
                hintStyle: selectedFilters.haveData ? textStyle() : null,
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
            ),
            CustomButton(
              height: 45,
              text: editMode == true ? "Update Product" : "Add Product",
              backgroundColor: primaryColor,
              fontSize: 18,
              onPressed: () {
                editProduct();
              },
              mainAxisAlignment: MainAxisAlignment.center,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
            )
          ],
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
  }

  Future editProduct() async {
    if (partnerSignUpKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      List unitIdsList = [];
      for (ProductTemplateUnits? data in templateData?.units ?? []) {
        unitIdsList.add(data?.id);
      }
      String? unitIds = unitIdsList.isNotEmpty ? unitIdsList.join(",") : "";

      if (editMode == true) {
        await context
            .read<ProductController>()
            .editProduct(
              context: context,
              id: "$id",
              name: nameCtrl.text,
              categoryId: "${selectedCategory?.id ?? ""}",
              subcategoryId: "${selectedSubCategory?.id ?? ""}",
              description: descriptionCtrl.text,
              price: salesPriceCtrl.text,
              mrpPrice: mrpPriceCtrl.text,
              unitId: "${selectedUnit?.id ?? ""}",
              initialInventory: initialInventoryCtrl.text,
              templateId: "${templateData?.id ?? ""}",
              imageName: templateData?.imageName ?? "",
              imagePath: templateData?.path ?? "",
              image: image,
              filterOptions: selectedFilters,
            )
            .then((value) {
          context.read<ProductController>().fetchMyProducts(context: context, isRefresh: true);
          return value;
        });
      } else {
        await context
            .read<ProductController>()
            .addProduct(
              context: context,
              name: nameCtrl.text,
              categoryId: "${selectedCategory?.id ?? ""}",
              subcategoryId: "${selectedSubCategory?.id ?? ""}",
              description: descriptionCtrl.text,
              price: salesPriceCtrl.text,
              mrpPrice: mrpPriceCtrl.text,
              unitId: "${selectedUnit?.id ?? ""}",
              initialInventory: initialInventoryCtrl.text,
              templateId: "${templateData?.id ?? ""}",
              imageName: templateData?.imageName ?? "",
              imagePath: templateData?.path ?? "",
              image: image,
              filterOptions: selectedFilters,
            )
            .then((value) {
          context.read<ProductController>().fetchMyProducts(context: context, isRefresh: true);
          return value;
        });
      }
    } else {
      String? error = "Select All Required Fields";
      Map body = {
        "name": nameCtrl.text,
        "categoryId": "${selectedCategory?.id ?? ""}",
        "subcategoryId": "${selectedSubCategory?.id ?? ""}",
        "description": descriptionCtrl.text,
        "price": salesPriceCtrl.text,
        "mrpPrice": mrpPriceCtrl.text,
        "unitId": "${selectedUnit?.id ?? ""}",
        "initialInventory": initialInventoryCtrl.text,
        "templateId": "${templateData?.id ?? ""}",
        "imageName": templateData?.imageName ?? "",
        "imagePath": templateData?.path ?? "",
        "image": image,
        "filterOptions": selectedFilters,
      };

      debugPrint("body $body");

      // if (location.address == null) {
      //   error = "Address is Required";
      // } else if (selectedCountry == null) {
      //   error = "Country is Required";
      // } else if (selectedState == null) {
      //   error = "State is Required";
      // } else if (selectedCity == null) {
      //   error = "City is Required";
      // } else if (isServiceProvider ? selectedCategories?.isEmpty == true : false) {
      //   error = "Categories are Required";
      // }
      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error_outline);
    }
  }

  Future<void> updateProfileImage({required ImageSource source}) async {
    File? pickedImg = await FilePickerController().selectCroppedImage(
      source: source,
      context: context,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: thumbnailAspectRatioPresets,
    );

    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
      }
    });

    if (context.mounted) {
      context.pop();
    }
  }

  Future addImages() async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Change Profile Pic",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.camera);
                      },
                      child: pickImageButton(
                        text: "Camera",
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.gallery);
                      },
                      child: pickImageButton(
                        text: "Gallery",
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  isEnabledField({
    required String? field,
    required String? status,
  }) {
    return (field != null && status != "Pending") ? false : true;
  }

  isFieldLocked({
    required String? field,
    required String? status,
  }) {
    return (field != null && status != "Pending") ? const Icon(CupertinoIcons.lock_circle) : null;
  }
}
