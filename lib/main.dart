import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobile_app/home/report_detail.dart';
import 'package:mobile_app/records/report.dart';
import 'package:mobile_app/records/space.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:mobile_app/home/org_selector.dart';
import 'package:mobile_app/models/app.model.dart';
import './records/user.dart';

void main() {
  final model = new AppModel();
  model.loadCurrentUser();

  runApp(
    ScopedModel<AppModel>(
      model: model,
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Mode App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (content, child, app) => Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: FutureBuilder<UnmodifiableListView<Report>>(
            future: app.reports,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length <= 0) {
                  if (app.currentSpace != null) {
                    return Center(child: new Text('No Reports In Space'));
                  } else {
                    return Center(child: new Text('Please Select a Space'));
                  }
                }

                return GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data.map((report) =>
                    new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => new ReportDetailPage(report: report)));
                      },
                      child: Card(child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: report.webPreviewImage != null ?
                                Image.network(report.webPreviewImage, fit: BoxFit.fitHeight) :
                                Image.asset('images/no-preview.png', fit: BoxFit.fitHeight)
                            ),
                            flex: 1,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(child: Text(report.name, style: TextStyle(fontSize: 14)), padding: EdgeInsets.all(8))
                          )
                        ],
                      ))
                    )
                  ).toList()
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(child: CircularProgressIndicator());
            }
          )
        ),
        drawer: new Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: 280.0,
                padding: EdgeInsets.zero,
                child: FutureBuilder<User>(
                  future: app.currentUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return new ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          DrawerHeader(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                new Text(app.orgName, style: TextStyle(color: Colors.white, fontSize: 16.0)),
                                new Text(snapshot.data.name),
                              ]
                            ),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                            )
                          ),
                          ListTile(
                            title: new Text('Switch Organization'),
                            onTap: () {
                              // Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) => new OrgSelectorPage(username: snapshot.data.username)));
                            },
                          ),
                        ]
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error);
                    }

                    return Center(child: CircularProgressIndicator());
                  }
                )
              ),
              Expanded(
                child: new Align(
                  alignment: Alignment.topLeft,
                  child: FutureBuilder<List<Space>>(
                    future: app.spaces,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (app.currentOrg == null) {
                          return ListView(
                            children: <Widget>[
                              ListTile(title: Text('Please select an organization'))
                            ]
                          );
                        }

                        return ListView(
                          children: snapshot.data.map((space) =>
                            ListTile(
                              title: Text(space.name),
                              onTap: () {
                                app.selectSpace(space);
                              },
                              selected: app.currentSpace != null ? space.token == app.currentSpace.token : false,
                            )
                          ).toList()
                        );
                      }

                      return CircularProgressIndicator();
                    }
                  )
                ),
              )
            ]
          )

        )
      )
    );
  }
}
