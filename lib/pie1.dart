import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final apiUrl = Uri.parse('https://server2-oiod.onrender.com/marks');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          setState(() {
            dataList = jsonData.cast<Map<String, dynamic>>();
          });
        } else {
          throw Exception('Data is not in the expected format');
        }
      } else {
        print('Failed to fetch data from API. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<charts.Series<MapEntry<String, int>, String>> _createSampleData(Map<String, dynamic> data) {
    final seriesData = [
      MapEntry('MAD', (data['MAD'] ?? 0) as int),
      MapEntry('IP', (data['IP'] ?? 0) as int),
      MapEntry('COA', (data['COA'] ?? 0) as int),
      MapEntry('WEBX', (data['WEBX'] ?? 0) as int),
    ];

    return [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Marks',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MapEntry<String, int> entry, _) => entry.key,
        measureFn: (MapEntry<String, int> entry, _) => entry.value,
        data: seriesData,
      ),
    ];
  }

  Widget _buildAccordion(Map<String, dynamic> data) {
    return ExpansionTile(
      title: Text('${data['rollNo']} - ${data['name']}'),
      children: [
        SizedBox(
          height: 200,
          child: charts.BarChart(
            _createSampleData(data),
            animate: true,
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  fontSize: 10,
                ),
              ),
              viewport: charts.NumericExtents(0, 20),
            ),
          ),
        ),
        ListTile(
          title: Text('MAD: ${data['MAD']}, COA: ${data['COA']}, IP: ${data['IP']}, WEBX: ${data['WEBX']}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data from API'),
        ),
        body: dataList.isNotEmpty ? ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return _buildAccordion(dataList[index]);
          },
        ) : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
