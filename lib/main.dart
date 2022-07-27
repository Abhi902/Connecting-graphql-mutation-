import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Equippp_login(),
    ),
  );
}

String query = '''
mutation insert_user(\$username:String!, \$fullname: String!) {
  insert_users(objects: [{user_name: \$username,full_name: \$fullname}]) {
    returning {
      user_name
      full_name
    }
  }
}
''';
TextEditingController username = TextEditingController();
TextEditingController fullname = TextEditingController();

class Equippp_login extends StatefulWidget {
  const Equippp_login({Key? key}) : super(key: key);

  @override
  State<Equippp_login> createState() => _Equippp_loginState();
}

class _Equippp_loginState extends State<Equippp_login> {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        'http://ec2-35-154-124-3.ap-south-1.compute.amazonaws.com:8080/v1/graphql');

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink as Link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    controller!.forward();
    animation = CurvedAnimation(parent: controller!, curve: Curves.bounceInOut);

    animation!.addListener(() {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Mutation(
        options: MutationOptions(
          document: gql(query),
        ),
        builder: (RunMutation insert, QueryResult? result) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 70),
                  child: TypewriterAnimatedTextKit(
                    text: ['EQUIPPP'],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0XffE05971),
                    ),
                    speed: Duration(milliseconds: 200),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  controller: username,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    helperStyle: TextStyle(
                      color: Colors.black,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XffE05971), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XffE05971), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: fullname,
                  decoration: InputDecoration(
                    hintText: 'Fullname',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XffE05971), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XffE05971), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Color(0XffE05971),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () {
                        print(username.text);
                        print(fullname.text);
                        insert({
                          "user_name": username.text,
                          "full_name": fullname.text
                        });
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'SUBMIT',
                      ),
                    ),
                  ),
                ),
                Text('Result :${result?.data?.toString()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
