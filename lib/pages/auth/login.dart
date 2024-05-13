import 'package:flutter/material.dart';
import 'package:funaabmap/services/repositories.dart';
import 'package:funaabmap/utils/providers.dart';
import 'package:funaabmap/utils/theme.dart';
import 'package:funaabmap/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;

import '../../models/user.dart';
import '../../utils/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> formKey = GlobalKey();

  var username = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: formKey,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 150,
                child: FittedBox(
                  child: Image.asset(Assets.logo),
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 30),
              Text('Officer Login', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: primaryColor, fontWeight: FontWeight.w600),),
              const SizedBox(height: 50,),
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) => value?.isNotEmpty == true ? null : 'Username field is required',
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 25,),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value?.isNotEmpty == true ? null : 'Password field is required',
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 40,),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  style: primaryButtonStyle,
                  onPressed: () async {
                    if( formKey.currentState?.validate() != true ) return;

                    context.push('/load');
                    // login process
                    final res = await (await Repository.users()).findOne(where.eq('username', username.text).eq('password', generateMd5(password.text)).limit(1));
                    print(res);
                    context.pop();
                    if( res != null ){
                      try {
                        final user = User.fromJson(res);
                        providerContainer
                            .read(loggedInUserProvider.notifier)
                            .state = user;

                        context.go('/artifacts');
                        return;
                      } catch(e){ rethrow; }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
                  },
                  child: Text('LOGIN')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
