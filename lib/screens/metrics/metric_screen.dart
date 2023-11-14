import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/model/metric.dart';

import '../../data_source/local/secure_storage.dart';
import '../../data_source/remote/api_service.dart';
import '../../util/color.dart';
import '../../util/constant.dart';

class MetricScreen extends StatefulWidget {
  const MetricScreen({super.key});

  @override
  State<MetricScreen> createState() => _MetricScreenState();
}

class _MetricScreenState extends State<MetricScreen> {
  late final ApiService _apiService;
  bool _isLoading = false;
  late final String _accessToken;
  Metric metrics = Metric();

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.black87,
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white70,
          statusBarIconBrightness: Brightness.dark),
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Metrics",
              style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    SecureStorage.getInstance().readSecureData(ACCESS_TOKEN_KEY).then((value) {
      _accessToken = value!;
      setState(() => _isLoading = true);
      _apiService.getActiveUsers(_accessToken).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            metrics = Metric.fromJson(jsonDecode(response.body));
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(response.reasonPhrase.toString())));
          setState(() => _isLoading = false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(radius: 30,color: primaryColor),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/WWJD-dark.png"))),
                      ),
                      Row(
                        children: [
                          Text(
                            "Total Users: ",
                            style:
                                GoogleFonts.roboto(color: Colors.grey.shade700),
                          ),
                          Text(metrics.userCount.toString())
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "METRICS",
                            style: GoogleFonts.roboto(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "WWJD / Metrics",
                            style:
                                GoogleFonts.roboto(color: Colors.grey.shade700),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text("Daily Active Users (DAU)"),
                          Text(metrics.dailyActiveUsers.toString()),

                        ],
                      ),
                      Column(
                        children: [
                          const Text("Monthly Active Users (MAU)"),
                          Text(metrics.monthlyActiveUsers.toString()),

                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
