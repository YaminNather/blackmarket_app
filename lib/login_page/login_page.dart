import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/sign_up_page/sign_up_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../home_page/home_page.dart';
import '../injector.dart';
import '../widgets/loading_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() => AppBar();

  Widget _buildBody() {
    final ThemeData theme = Theme.of(context);

    if(_isLoading)
      return const LoadingIndicator();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(    
          children: <Widget>[
            Text('Blackmarket', style: theme.textTheme.headline5),

            const SizedBox(height: 32.0),

            _buildForm(),

            const SizedBox(height: 32.0),

            _buildError()
          ]
        )
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      onChanged: () => setState(() => _signUpButtonEnabled = _formKey.currentState!.validate()),
      child: Column(
        mainAxisSize: MainAxisSize.min,          
        children: <Widget>[
          _buildUsernameAndEmailField(),
          
          const SizedBox(height: 16.0),
          
          _buildPasswordField(),

          const SizedBox(height: 16.0),

          _buildLoginButton(),

          const SizedBox(height: 32.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Dont have an account?'),

              TextButton(
                child: const Text('Sign up'), 
                onPressed: () async {
                  final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const SignUpPage());

                  await Navigator.of(context).push(route);
                }
              )
            ]
          )
        ]
      ),
    );
  }

  // Widget _buildUsernameField() {
  //   String? validator(String? text) {
  //     if(text == null)
  //       throw Error();

  //     final RegExp regExp = RegExp(r'[!@#$%^&*()+\-=\[\]{};'':"\\|,.<>\/?]');
  //     if(text.contains(regExp))
  //       return 'Username cannot have special characters, except for _';

  //     if(text.contains(' '))
  //       return 'Username cannot have spaces, use _ instead';
      
  //     if(text.length < 5)
  //       return 'Username must have atleast 5 characters';

  //     return null;
  //   }

  //   return TextFormField(
  //     controller: _usernameController,
  //     decoration: const InputDecoration(hintText: 'Username'),
  //     validator: validator,
  //     autovalidateMode: AutovalidateMode.onUserInteraction
  //   );
  // }

  Widget _buildUsernameAndEmailField() {
    return TextFormField(
      controller: _usernameOrEmailFieldController, 
      decoration: const InputDecoration(hintText: 'Username or Email'),
      autovalidateMode: AutovalidateMode.onUserInteraction
    );
  }

  Widget _buildPasswordField() {
    String? validator(String? text) {
      if(text == null)
        throw Error();

      if(text.length < 6)
        return 'Password has to have a minimum of 6 characters';

      return null;
    }

    return TextFormField(
      controller: _passwordController, 
      decoration: const InputDecoration(hintText: 'Password'),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true
    );
  }

  Widget _buildLoginButton() {
    Future<void> onPressed() async {
      try {
        final String password = _passwordController.text;

        setState(() => _isLoading = true);
        
        if(!_isEmailInField())
          await _authentication.loginWithUsername(_usernameOrEmailFieldController.text, password);
        else
          await _authentication.loginWithEmail(_usernameOrEmailFieldController.text, password);
      }
      catch(e) {
        setState(
          () {
            _isLoading = false;
            _error = 'Login failed';
            print('CustomLog: $e');
          }
        );
        return;
      }

      setState(() => _isLoading = false);
      final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const HomePage());
      await Navigator.of(context).push(route);
    }

    return SizedBox(
      width: 256.0,
      child: ElevatedButton(
        // onPressed: (_signUpButtonEnabled) ? onPressed : null,
        onPressed: () {},
        child: const Text('Login')
      )
    );
  }

  Widget _buildError() {
    final ThemeData theme = Theme.of(context);

    final String? error = _error;

    if(error == null)
      return const SizedBox.shrink();

    return Text(error, style: TextStyle(color: theme.colorScheme.error));
  }

  Authentication get _authentication => _client.authentication();

  bool _isEmailInField() {
    final String text = _usernameOrEmailFieldController.text;
    
    return EmailValidator.validate(text);
  }


  bool _isLoading = false;
  String? _error;

  bool _signUpButtonEnabled = false;
  

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController _usernameOrEmailFieldController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final Client _client = getIt<Client>();
}