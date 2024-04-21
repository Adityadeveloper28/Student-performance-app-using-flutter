import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  String? email;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? submittedFormData;
  bool isAuthenticated = false; // Flag to indicate whether the user is authenticated

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserData();
  }

  @override
  void initState() {
    super.initState();
    // Fetch submitted form data only if the user is authenticated
    _fetchSubmittedFormData();
  }

  Future<void> _fetchUserData() async {
    try {
      final Map<String, String>? args =
      ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
      if (args != null && args.containsKey('email')) {
        email = args['email'];
        final apiUrl = Uri.parse('https://server-rj2m.onrender.com/user/$email');
        final response = await http.get(apiUrl);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            userData = data;
            isAuthenticated = true; // Set isAuthenticated to true after successful login
          });
        } else {
          throw Exception('Failed to load user data');
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle error
    }
  }

  Future<void> _fetchSubmittedFormData() async {
    try {
      if (isAuthenticated && userData != null && userData!.containsKey('name')) {
        final username = userData!['name'];
        final apiUrl = Uri.parse('https://server2-oiod.onrender.com/form/$username');
        final response = await http.get(apiUrl);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            submittedFormData = data;
          });
        } else {
          throw Exception('Failed to load form data');
        }
      }
    } catch (error) {
      print('Error fetching submitted form data: $error');
      // Handle error
    }
  }

  List<charts.Series<MapEntry<String, int>, String>> _createSampleData(
      Map<String, dynamic> data) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${userData!['name']}'),
      ),
      body: Center(
        child: isAuthenticated && submittedFormData != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MAD: ${submittedFormData!['MAD']}'),
            Text('COA: ${submittedFormData!['COA']}'),
            Text('IP: ${submittedFormData!['IP']}'),
            Text('WEBX: ${submittedFormData!['WEBX']}'),
            // Add more fields as needed
            SizedBox(
              height: 200,
              child: charts.BarChart(
                _createSampleData(submittedFormData!),
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
          ],
        )
            : CircularProgressIndicator(), // Show loading indicator while fetching data
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            'form',
          ).then((_) {
            // Refresh data after returning from form page
            _fetchSubmittedFormData();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
