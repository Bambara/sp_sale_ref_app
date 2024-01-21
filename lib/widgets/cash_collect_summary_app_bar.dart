import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';

class CashCollectSummaryAppBar extends StatelessWidget {
  const CashCollectSummaryAppBar({required this.dailyIncome});

  final double appBarHeight = 66.0;
  final double dailyIncome;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text("Daily Collections", style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 28.0)),
                ),
                Container(
                  child: Text(dailyIncome.toString(), style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w800, fontSize: 36.0)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                    child: new Text(LoginSession.refName, style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins', fontSize: 16.0)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
        ],
      )),
      decoration: new BoxDecoration(
        color: Color(0xff013db7),
      ),
    );
  }
}
