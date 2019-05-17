import 'package:flutter/material.dart';
import 'package:mobile_app/records/report.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:mobile_app/records/organization.dart';
import 'package:mobile_app/models/app.model.dart';

class _ReportDetailState extends State {
  final Report report;

  _ReportDetailState(this.report);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.name),
      ),
      body: SingleChildScrollView(
        child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: report.webPreviewImage != null ?
              Image.network(report.webPreviewImage, fit: BoxFit.fitHeight) :
              Image.asset('images/no-preview.png', fit: BoxFit.fitHeight),
          ),
          new Row(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text('Name:'),
                  new Text('Token:'),
                  new Text('Description:'),
                  new Text('Create Date:'),
                  new Text('Modified Date:'),
                  new Text('Last Run Date:'),
                  new Text('Last Successful Run Date:'),
                  new Text('Shared:'),
                  new Text('Query Count:'),
                  new Text('Chart Count:'),
                  new Text('Schedules Count:'),
                  new Text('Manual Run Disabled:'),
                ],
              ),
              Flexible(child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(report.name),
                    new Text(report.token),
                    new Text(report.description),
                    new Text(report.createdDate.toIso8601String()),
                    new Text(report.modifiedDate.toIso8601String()),
                    new Text(report.lastRunDate.toIso8601String()),
                    new Text(report.lastSuccessRunDate.toIso8601String()),
                    new Text(report.shared.toString()),
                    new Text(report.queryCount.toString()),
                    new Text(report.chartCount.toString()),
                    new Text(report.schedulesCount.toString()),
                    new Text(report.manualRunDisabled.toString()),
                  ],
                )
              ))
            ]
          )
        ],
      )
      )
    );
  }
}

class ReportDetailPage extends StatefulWidget {
  final Report report;

  ReportDetailPage({Key key, this.report}) : super(key: key);

  _ReportDetailState createState() {
    return new _ReportDetailState(report);
  }

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

            return CircularProgressIndicator();
          }
        )
      )
    );
  }
}
