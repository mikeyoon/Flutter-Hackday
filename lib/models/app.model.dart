import 'dart:collection';

import 'package:mobile_app/api.dart';
import 'package:mobile_app/records/organization.dart';
import 'package:mobile_app/records/report.dart';
import 'package:mobile_app/records/space.dart';
import 'package:mobile_app/records/user.dart';
import 'package:scoped_model/scoped_model.dart';


class AppModel extends Model {
  Future<User> _currentUser;
  Future<List<Organization>> _organizations = Future.sync(() => []);
  Future<List<Space>> _spaces = Future.sync(() => []);
  Future<List<Report>> _reports = Future.sync(() => []);

  Organization _currentOrg;
  Space _currentSpace;

  /// An unmodifiable view of the items in the cart.
  Future<UnmodifiableListView<Organization>> get orgs => _organizations.then((orgs) => UnmodifiableListView(orgs));
  Future<User> get currentUser => _currentUser;
  Organization get currentOrg => _currentOrg;

  Future<UnmodifiableListView<Space>> get spaces => _spaces.then((spaces) => UnmodifiableListView(spaces));
  Space get currentSpace => _currentSpace;

  Future<UnmodifiableListView<Report>> get reports => _reports.then((reports) => UnmodifiableListView(reports));

  String get orgName => _currentOrg != null ? _currentOrg.username : "";

  loadCurrentUser() {
    _currentUser = fetchCurrentUser();
    _currentUser.then((user) {
      _organizations = fetchOrganizations(user.username);
    });
    notifyListeners();
  }

  selectOrg(Organization org) {
    _currentOrg = org;
    _currentSpace = null;
    _spaces = fetchSpaces(org.username);
    _reports = Future.sync(() => []);
    notifyListeners();
  }

  selectSpace(Space space) {
    _currentSpace = space;
    _reports = fetchReports(orgName, space.token);
    notifyListeners();
  }
}
