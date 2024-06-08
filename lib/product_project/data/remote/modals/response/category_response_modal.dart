// To parse this JSON data, do
//
//     final categoryModal = categoryModalFromJson(jsonString);

import 'dart:convert';

List<String> categoryModalFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String categoryModalToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
