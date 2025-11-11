// import 'package:kms/src/utils/app_const.dart';
// import 'package:kms/src/widgets/app_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';

// class TypeAheadFormFieldWidget extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final TextStyle hintStyle;
//   final InputBorder enabledBorder;
//   final InputBorder errorBorder;
//   final Future<List<dynamic>> Function(String) suggestionsCallback;
//   final Widget Function(BuildContext, dynamic) itemBuilder;
//   final Function(dynamic) onSuggestionSelected;

//   TypeAheadFormFieldWidget({
//     required this.controller,
//     required this.hintText,
//     required this.hintStyle,
//     required this.enabledBorder,
//     required this.errorBorder,
//     required this.suggestionsCallback,
//     required this.itemBuilder,
//     required this.onSuggestionSelected,
//   });

//   @override
//   _TypeAheadFormFieldWidgetState createState() =>
//       _TypeAheadFormFieldWidgetState();
// }

// class _TypeAheadFormFieldWidgetState extends State<TypeAheadFormFieldWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
//       child: Container(
//         padding: EdgeInsets.only(left: 16, right: 16),
//         decoration: BoxDecoration(
//             color: AppConst.primary,
//             border: Border.all(color: AppConst.black, width: 1),
//             borderRadius: BorderRadius.circular(20)),
//         child: TypeAheadFormField(
//           textFieldConfiguration: TextFieldConfiguration(
//             controller: widget.controller,
//             decoration: InputDecoration(
//               hintText: widget.hintText,
//               hintStyle: widget.hintStyle,
//               enabledBorder: widget.enabledBorder,
//               errorBorder: widget.errorBorder,
//             ),
//             style: widget.hintStyle,
//           ),
//           suggestionsCallback: widget.suggestionsCallback,
//           itemBuilder: widget.itemBuilder,
//           onSuggestionSelected: widget.onSuggestionSelected,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "This field cannot be empty";
//             } else {
//               return null;
//             }
//           },
//           noItemsFoundBuilder: (BuildContext context) {
//             return AppText(
//               txt: 'No matching item found.',
//               size: 15,
//               color: AppConst.black,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
