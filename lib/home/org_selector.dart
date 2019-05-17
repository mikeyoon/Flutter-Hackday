import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:mobile_app/records/organization.dart';
import 'package:mobile_app/models/app.model.dart';

class OrgSelectorPage extends StatelessWidget {
  final String username;

  OrgSelectorPage({Key key, @required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text("Select an Organization"),
        ),
        body: FutureBuilder<List<Organization>>(
          future: model.orgs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map((org) =>
                  ListTile(
                    title: new Text(org.name),
                    onTap: () {
                      model.selectOrg(org);
                    },
                    selected: org.username == model.orgName,
                  )
                ).toList(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(child: CircularProgressIndicator());
          }
        )
      )
    );
  }
}
