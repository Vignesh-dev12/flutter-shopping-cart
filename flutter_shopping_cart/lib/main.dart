import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/core/shared_preference_helper.dart';
import 'package:flutter_shopping_cart/core/utils/data_connection_checker.dart';
import 'package:flutter_shopping_cart/route_setup.dart';
import 'package:flutter_shopping_cart/ui/routes/cart/view/cart_view.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/view/login_view.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/view/register_view.dart';
import 'package:flutter_shopping_cart/ui/themes/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DataConnectionStatus dataConnectionStatus =
  await DataConnectionChecker().connectionStatus;
  runApp(MyApp(dataConnectionStatus: dataConnectionStatus));
}

class MyApp extends StatelessWidget {
  final DataConnectionStatus? dataConnectionStatus;

  MyApp({this.dataConnectionStatus});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object>(
      create: (_) => DataConnectionChecker().onStatusChange,
      initialData: dataConnectionStatus!,
      builder: (context, child) {
        return MaterialApp(
            title: 'Smart Shop',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(context),
            onGenerateRoute: RouterViews.generateRoute,
            //home: MyHomePage(title: 'Flutter Demo Home Page'),
          //home: CartView(),
            home: FutureBuilder<bool>(
              future: PreferenceHelper.getBool(PreferenceConst.isUserLogin),
              builder: (context, snapData) {
                if (snapData.hasData) {
                  if (snapData.data ?? false)
                    return CartView();
                  else
                    return RegisterView();
                } else
                  return Container();
              },
            ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    /*setState(() {
      _counter++;
    });*/
    Navigator.pushNamed(context, RoutePaths.CartView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
