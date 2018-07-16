import 'dart:async';
import 'dart:math';

import 'package:change_theme_trial/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  final String title;
  MyApp({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreen();
  }
}

class MainScreen extends State<MyApp> {
  Color color = Colors.red;
  final Random _random = Random();
  void onPressed() {
    setState(() {
      color = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // return ColorState(
    //   color: color,
    //   onTap: onPressed,
    //   child: TreeView(title: widget.title),
    // );

    // return MaterialApp(
    //   theme: Theme.Purple,
    //   home: ColorState(
    //     color: color,
    //     onTap: onPressed,
    //     child: TreeView(
    //       title: widget.title,
    //     ),
    //   ),
    // );

    return StreamBuilder(
      stream: bloc.darktheme,
      initialData: false,
      builder: (context,snapshot) => MaterialApp(
        theme: snapshot.data ? CustomTheme.CompanyThemeData : CustomTheme.Purple,
        home: ColorState(
          color: color,
          onTap: onPressed,
          child: TreeView(title: widget.title,darkThemeEnabled: snapshot.data,),
        ),
      ),
    );
  }
}

class TreeView extends StatelessWidget {
  final String title;
final bool darkThemeEnabled;
  TreeView({Key key, this.title,this.darkThemeEnabled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final onTap = ColorState.of(context).onTap;
    final color = ColorState.of(context).color;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      // body
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Box(),
            Buttons(onTap: onTap,),
            Switch(
              activeColor: Theme.of(context).accentColor,
              activeTrackColor: Theme.of(context).accentColor,
              inactiveThumbColor: Theme.of(context).accentColor,
              inactiveTrackColor: Theme.of(context).accentColor,
              value:darkThemeEnabled,
              onChanged: bloc.changeTheme,

            )
          ],
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorState = ColorState.of(context);
    return Container(
      height: 100.0,
      width: 100.0,
      alignment: Alignment.center,
      color: colorState.color,
      margin: EdgeInsets.only(bottom: 100.0),
    );
  }
}

class Buttons extends StatelessWidget {
  final Function onTap;
  Buttons({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: onTap,
        child: Text(
          "Change Theme ",
          style: TextStyle(color: Colors.green),
        ),
        color: Colors.amber.shade500,
      ),
    );
  }
}

class ColorState extends InheritedWidget {
  final Color color;
  final Function onTap;
  ColorState({
    Key key,
    this.color,
    this.onTap,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ColorState oldWidget) {
    return color != oldWidget.color;
  }

  static ColorState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorState);
  }
}

class Bloc {
  final themeController = StreamController<bool>();
  get changeTheme => themeController.sink.add;
  get darktheme => themeController.stream;
}

final bloc = Bloc();
