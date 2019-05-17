import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/records/organization.dart';
import 'package:mobile_app/records/report.dart';
import 'package:mobile_app/records/space.dart';
import 'package:mobile_app/records/user.dart';

const token = '';
const password = '';

const MODE_URL = 'https://beta.mode.com/api/';

String basicAuthenticationHeader(String username, String password) {
  return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
}

Future<User> fetchCurrentUser() async {
  final response =
    await http.get(
      MODE_URL + 'account?embed%5Borganizations=1',
      headers: {'authorization': basicAuthenticationHeader(token, password)});

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return User.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load user');
  }
}

Future<List<Organization>> fetchOrganizations(String username) async {
  final response =
    await http.get(
      MODE_URL + '$username/organizations',
      headers: {'authorization': basicAuthenticationHeader(token, password)});

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    final body = json.decode(response.body);
    Iterable orgsJson = body['_embedded']['organizations'];
    final orgs = orgsJson.map((map) => Organization.fromJson(map)).toList();
    orgs.sort((a, b) => a.name.compareTo(b.name));
    return orgs;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load orgs');
  }
}

Future<List<Space>> fetchSpaces(String orgName) async {
  final response =
    await http.get(
      MODE_URL + '$orgName/spaces',
      headers: {'authorization': basicAuthenticationHeader(token, password)});

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    String source = Utf8Decoder().convert(response.bodyBytes);
    final body = json.decode(source);
    Iterable spacesJson = body['_embedded']['spaces'];
    final spaces = spacesJson.map((map) => Space.fromJson(map)).toList();
    spaces.sort((a, b) => a.name.compareTo(b.name));
    return spaces;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load spaces');
  }
}

Future<List<Report>> fetchReports(String orgName, String spaceToken) async {
  final response =
    await http.get(
      MODE_URL + '$orgName/spaces/$spaceToken/reports',
      headers: {'authorization': basicAuthenticationHeader(token, password)});

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    String source = Utf8Decoder().convert(response.bodyBytes);
    final body = json.decode(source);
    Iterable reportsJson = body['_embedded']['reports'];
    final reports = reportsJson.map((map) => Report.fromJson(map)).toList();
    reports.sort((a, b) {
      if (a.name != null && b.name != null) {
        return a.name.compareTo(b.name);
      }

      if (a.name != null) {
        return -1;
      }

      if (b.name != null) {
        return 1;
      }

      return 0;
    });
    return reports;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load spaces');
  }
}