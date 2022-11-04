import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController beratCon = TextEditingController();
  RxString provAsalId = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString provTujuanId = "0".obs;
  RxString cityTujuanId = "0".obs;
  RxString codeKurir = "".obs;
  RxBool iSLoadning = false.obs;
  List<Ongkir> ongkisKirim = [];

  void cekOngkir() async {
    if (provAsalId != "0" &&
        cityAsalId != "0" &&
        provTujuanId != "0" &&
        cityTujuanId != "0" &&
        codeKurir != "" &&
        beratCon != "") {
      // Eksekusi
      try {
        iSLoadning.value = true;
        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {"key": "c9fabfb6ee8a2bb9f58cf5a5edc2d9f1"},
          body: {
            "origin": cityAsalId.value,
            "destination": cityTujuanId.value,
            "weight": beratCon.text,
            "courier": codeKurir.value
          },
        );
        iSLoadning.value = false;
        List ongkir = json.decode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;
        ongkisKirim = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
            title: "ONGKOS KIRIM",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ongkisKirim
                  .map((e) => ListTile(
                        title: Text("${e.service!.toUpperCase()}"),
                        subtitle: Text("${e.cost![0].value}"),
                      ))
                  .toList(),
            ));
      } catch (e) {
        Get.defaultDialog(
            title: "TERJADI KESALAHAN",
            middleText: "Tidak Dapat Mengecek Ongkir");
      }
    } else {
      Get.defaultDialog(
          title: "TERJADI KESALAHAN", middleText: "Data Input Belum Lengkap");
    }
  }
}
