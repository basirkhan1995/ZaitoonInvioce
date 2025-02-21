import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/EstimateBloc/bloc/estimate_bloc.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Components/Widgets/underline_textfield.dart';
import 'package:zaitoon_invoice/Json/estimate.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/New/product_textfield.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/pdf.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/print.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/customer_searchable_field.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Products/new_product.dart';

class EstimateView extends StatefulWidget {
  const EstimateView({super.key});

  @override
  State<EstimateView> createState() => _EstimateViewState();
}

class _EstimateViewState extends State<EstimateView> {
  final formKey = GlobalKey<FormState>();
  final customer = TextEditingController();
  final invoiceNumber = TextEditingController();
  final dueDate = TextEditingController();
  final issueDate = TextEditingController();
  List<EstimateItemsModel> estimateItems = [];

  final estimateDetails = EstimateInfoModel();
  final pdf = Pdf();
  @override
  void initState() {
    estimateItems.add(EstimateItemsModel(controller: TextEditingController()));
    initialDate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstimateBloc>().add(LoadItemsEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthenticatedState) {
            estimateDetails.supplier = state.user.businessName ?? "";
            estimateDetails.supplierAddress = state.user.address ?? "";
            estimateDetails.supplierMobile = state.user.mobile1 ?? "";
            estimateDetails.supplierTelephone = state.user.mobile2 ?? "";
            estimateDetails.logo = state.user.companyLogo;
            estimateDetails.supplierEmail = state.user.email ?? "";
            estimateDetails.invoiceNumber = invoiceNumber.text;
            estimateDetails.clientName = customer.text;
          }
          return Column(
            children: [
              buildAppBar(context),
              buildEstimate(context),
            ],
          );
        },
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(locale.newEstimate, style: theme.titleLarge),
          BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return ZOutlineButton(
                  height: 45,
                  width: 120,
                  icon: FontAwesomeIcons.solidFilePdf,
                  label: Text("PDF"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PdfPrintSetting(
                              info: estimateDetails,
                              items: estimateItems,
                            );
                          });
                    }
                  });
            },
          )
        ],
      ),
    );
  }

  Widget buildEstimate(BuildContext context) {
    return AppBackground(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          buildInvoiceHeader(context),
          buildEstimateItems(),
          invoiceFooter(),
        ],
      ),
    );
  }

  Widget buildInvoiceHeader(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            spacing: 20,
            children: [
              UnderlineTextfield(
                title: locale.invoiceNumber,
                isRequired: true,
                controller: invoiceNumber,
              ),
              AccountSearchableInputField(
                title: locale.customer,
                controller: customer,
                onChanged: (value) {
                  setState(() {
                    estimateDetails.clientName = customer.text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return locale.required(locale.client);
                  }
                  return null;
                },

                isRequire: true,
                end: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 15,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add_circle_outline_rounded),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        Column(
          spacing: 20,
          children: [
            UnderlineTextfield(
              title: locale.invoiceDate,
              isRequired: true,
              controller: issueDate,
              onTap: () => datePicker(context, issueDate, "issueDate"),
            ),
            UnderlineTextfield(
              title: locale.dueDate,
              isRequired: true,
              controller: dueDate,
              onTap: () => datePicker(context, dueDate, "dueDate"),
            ),
          ],
        ),
      ],
    );
  }

  void initialDate() {
    invoiceNumber.text = "INV000001";
    final now = DateTime.now();
    final defaultIssueDate = DateFormat('MMM dd, yyyy').format(now);
    final defaultDueDate =
        DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));

    // Set default values in text controllers
    issueDate.text = defaultIssueDate;
    dueDate.text = defaultDueDate;

    // Update the invoiceInfo object with default dates
    estimateDetails.invoiceDate = DateFormat('MMM dd, yyyy').format(now);
    estimateDetails.dueDate =
        DateFormat('MMM dd, yyyy').format(now.add(const Duration(days: 7)));
  }

  Future<void> datePicker(BuildContext context,
      TextEditingController controller, String field) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;

        // Update the respective field in the model
        if (field == "issueDate") {
          estimateDetails.invoiceDate = formattedDate;
        } else if (field == "dueDate") {
          estimateDetails.dueDate = formattedDate;
        }
      });
    }
  }

  Widget buildTotal(
      {required List<EstimateItemsModel> invoiceItems,
      required EstimateInfoModel info}) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      final locale = AppLocalizations.of(context)!;
      double calculateSubtotal() {
        double subtotal = 0.0;
        for (var item in invoiceItems) {
          subtotal += item.quantity * item.amount;
        }
        return subtotal;
      }

      double calculateTotalVat() {
        double totalVat = 0.0;
        for (var item in invoiceItems) {
          totalVat += (item.quantity * item.amount) * (item.tax / 100);
        }
        return totalVat;
      }

      double calculateDiscount() {
        double totalDiscount = 0.0;
        for (var item in invoiceItems) {
          totalDiscount +=
              (item.quantity * item.amount) * (item.discount / 100);
        }
        return totalDiscount;
      }

      double calculateTotal() {
        double subtotal = calculateSubtotal();
        double totalVat = calculateTotalVat();
        double totalDiscount = calculateDiscount();
        return subtotal + totalVat - totalDiscount;
      }

      final subtotal = calculateSubtotal();
      final totalVat = calculateTotalVat();
      final totalDiscount = calculateDiscount();
      final total = calculateTotal();

      String? currency;
      if (state is AuthenticatedState) {
        currency = "USD";
        info.currency = "USD";
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.subtotal),
                    Text("${subtotal.toStringAsFixed(2)} $currency",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.tax),
                    Text("${totalVat.toStringAsFixed(2)} $currency",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.discount),
                    Text("${totalDiscount.toStringAsFixed(2)} $currency",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).colorScheme.primary),
                  child: Text(
                    "${AppLocalizations.of(context)!.total}: ${total.toStringAsFixed(2)} $currency",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget buildEstimateItems() {
    return BlocConsumer<EstimateBloc, EstimateState>(
      listener: (context, state) {
        if (state is EstimateItemsLoadedState) {
          estimateItems = state.items;
        }
      },
      builder: (context, state) {
        if (state is EstimateItemsLoadedState) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Form(
              key: formKey,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                columnWidths: const {
                  0: FixedColumnWidth(40), // Adjust width for the first column
                  1: FlexColumnWidth(10), // Item name gets more space
                  2: FixedColumnWidth(80), // Quantity
                  3: FixedColumnWidth(100), // Unit price
                  4: FixedColumnWidth(100), // Discount
                  5: FixedColumnWidth(80), // Tax
                  6: FixedColumnWidth(110), // Total
                  7: FixedColumnWidth(60), // Action Button
                },
                border: TableBorder.symmetric(
                  outside: BorderSide(
                      color: Colors.grey.withValues(alpha: .2),
                      width: 1), // Table border outline
                  inside: BorderSide.none, // No internal borders
                ),
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text("#",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary)),
                      ),
                      Text(AppLocalizations.of(context)!.description,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.qty,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.rate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.discount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.tax,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.total,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(AppLocalizations.of(context)!.action,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ),

                  ...state.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    int rowNumber = index + 1;
                    final rowTotal = ((item.quantity * item.amount) -
                            ((item.quantity * item.amount) *
                                (item.discount / 100)) +
                            ((item.quantity * item.amount) * (item.tax / 100)))
                        .toStringAsFixed(2);
                    item.total = double.parse(rowTotal);
                    item.rowNumber = rowNumber;
                    item.focusNode ??= FocusNode();
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0),
                          child: Center(child: Text(rowNumber.toString())),
                        ),
                        ProductTextField(
                          end: IconButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              iconSize: 15,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                showDialog(context: context, builder: (context){
                                  return NewProduct();
                                });
                              },
                              icon: Icon(Icons.add_circle_outline_rounded)),
                          controller: item.controller,
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                      itemId: value,
                                      itemName: item.controller!.text,
                                    ),
                                  ),
                                );
                          },
                          hintText: "",
                        ),

                        //QTY
                        UnderlineTextfield(
                          enabledColor: Colors.cyan,
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        quantity: int.tryParse(item.controller!.text) ?? 1),
                                  ),
                                );
                          },
                        ),
                        //Price
                        UnderlineTextfield(
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          enabledColor: Colors.teal,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        amount: double.tryParse(value) ?? 0.00),
                                  ),
                                );
                          },
                        ),
                        //Discount
                        UnderlineTextfield(
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3), // Restrict input to 3 characters
                          ],
                          enabledColor: Colors.green,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        discount:
                                            double.tryParse(value) ?? 0.0),
                                  ),
                                );
                          },
                        ),
                        UnderlineTextfield(
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3), // Restrict input to 3 characters
                          ],
                          enabledColor: Colors.red,
                          title: "",
                          onChanged: (value) {
                            context.read<EstimateBloc>().add(
                                  UpdateItemEvent(
                                    index,
                                    item.copyWith(
                                        tax: double.tryParse(value) ?? 0.0),
                                  ),
                                );
                          },
                        ),
                        UnderlineTextfield(
                          textAlign: TextAlign.center,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          readOnly: true,
                          title: "",
                          hintText: rowTotal,
                        ),
                        Center(
                          child: IconButton(
                            constraints: BoxConstraints(),
                            iconSize: 18,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade900,
                            ),
                            onPressed: () {
                              context
                                  .read<EstimateBloc>()
                                  .add(RemoveItemEvent(index));
                            },
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget invoiceFooter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      context
                          .read<EstimateBloc>()
                          .add(AddItemEvent(estimateItems));
                    });
                  },
                  child: Chip(
                      side: BorderSide.none,
                      avatar: const Icon(Icons.add_circle_outline_rounded),
                      label: Text(
                        AppLocalizations.of(context)!.addItem,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ))),
            ],
          ),
          Expanded(child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              if (state is EstimateItemsLoadedState) {
                return buildTotal(
                    invoiceItems: state.items, info: estimateDetails);
              }
              return Container();
            },
          )),
        ],
      ),
    );
  }
}
