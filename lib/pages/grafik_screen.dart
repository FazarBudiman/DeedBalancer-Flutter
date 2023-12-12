import 'dart:math';
import 'package:DeedBalancer/service/access_token.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class GrafikScreen extends StatefulWidget {
  const GrafikScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GrafikScreenState createState() => _GrafikScreenState();
}

class _GrafikScreenState extends State<GrafikScreen> {
  late List<FlSpot> positiveSpots = [];
  late List<FlSpot> negativeSpots = [];
  late List<String> days = [];
  String? accessToken;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAccessToken();
  }

  Future<void> loadAccessToken() async {
    String? token = await AccessToken.getToken();
    setState(() {
      accessToken = token;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    const apiUrl =
        'https://api-deed-balancer.netlify.app/.netlify/functions/api/chart';

    final headers = {'access-token': '$accessToken'};
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<int> positif = List<int>.from(data['positif']);
        final List<int> negatif = List<int>.from(data['negatif']);
        final List<String> hari = List<String>.from(data['hari']);
        setState(() {
          isLoading = false;
        });

        positiveSpots = List<FlSpot>.generate(
            positif.length,
            (index) =>
                FlSpot((index + 1).toDouble(), positif[index].toDouble()));

        negativeSpots = List<FlSpot>.generate(
            negatif.length,
            (index) =>
                FlSpot((index + 1).toDouble(), negatif[index].toDouble()));

        days = hari;
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Is Your Deed Balanced?",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      buildDateRange()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 300.h,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            barWidth: 2.5,
                            spots: positiveSpots,
                            isCurved: true,
                            curveSmoothness: 0.2,
                            color: Colors.blue,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                          LineChartBarData(
                            barWidth: 2.5,
                            curveSmoothness: 0.2,
                            isCurved: true,
                            spots: negativeSpots,
                            color: Colors.red,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color:
                                Colors.transparent, // Pilih warna yang sesuai
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: _leftTitles),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: _bottomTitles,
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Column(
                    children: <Widget>[
                      _buildLegendItem(Colors.blue, 'Positive Activities'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _buildLegendItem(Colors.red, 'Negative Activities'),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget buildDateRange() {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 6));

    String formattedStartDate = DateFormat('dd/MM/yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd/MM/yyyy').format(endDate);

    String dateRange = '$formattedStartDate - $formattedEndDate';

    return Text(
      dateRange,
      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(4), // Adjust the value as needed
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(label),
      ],
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= 1 && value <= days.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(days[(value - 1).toInt()]),
            );
          }
          return const Text('');
        },
      );

  SideTitles get _leftTitles {
    double maxValue = findMaxValue(); // Fungsi untuk menemukan nilai terbesar
    return SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= 0 && value <= maxValue) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(value.toInt().toString()),
            );
          }
          return Text((value.toInt() - 1).toString());
        },
        interval: 1.0);
  }

  double findMaxValue() {
    double maxValue = double.negativeInfinity;

    for (FlSpot spot in positiveSpots) {
      maxValue = max(maxValue, spot.y);
    }

    for (FlSpot spot in negativeSpots) {
      maxValue = max(maxValue, spot.y);
    }

    return maxValue;
  }
}
