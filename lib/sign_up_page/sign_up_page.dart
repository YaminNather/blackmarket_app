import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/products_page/products_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../injector.dart';
import '../widgets/loading_indicator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      onChanged: () => setState(() => _isSignUpButtonEnabled = _formKey.currentState!.validate()),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,          
        children: <Widget>[
          _buildUsernameField(),

          const SizedBox(height: 16.0),

          _buildEmailField(),
          
          const SizedBox(height: 16.0),
          
          _buildPasswordField(),

          const SizedBox(height: 16.0),

          _buildSignUpButton()
        ]
      ),
    );
  }

  Widget _buildUsernameField() {
    String? validator(String? text) {
      if(text == null)
        throw Error();

      final RegExp regExp = RegExp(r'[!@#$%^&*()+\-=\[\]{};'':"\\|,.<>\/?]');
      if(text.contains(regExp))
        return 'Username cannot have special characters, except for _';

      if(text.contains(' '))
        return 'Username cannot have spaces, use _ instead';
      
      if(text.length < 5)
        return 'Username must have atleast 5 characters';

      return null;
    }

    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(hintText: 'Username'),
      validator: validator
    );
  }

  Widget _buildEmailField() {
    String? validator(String? text) {
      if(text == null)
        throw Error();

      if(!EmailValidator.validate(text))
        return 'Please enter a valid email';

      return null;
    }

    return TextFormField(
      controller: _emailController, 
      decoration: const InputDecoration(hintText: 'Email'),
      validator: validator
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
      obscureText: true
    );
  }

  Widget _buildSignUpButton() {
    Future<void> onPressed() async {
      try {
        final String username = _usernameController.text;
        final String email = _emailController.text;
        final String password = _passwordController.text;
        
        setState(() => _isLoading = true);
        await _authentication.signUp(username, email, password);
      }
      catch(e) {
        setState(
          () {
            _isLoading = false;            
            _error = 'Sign up failed';
          }
        );
        return;
      }

      setState(() => _isLoading = false);
      final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const ProductsPage());
      await Navigator.of(context).push(route);
    }

    return SizedBox(
      width: 256.0,
      child: ElevatedButton(
        // onPressed: (_isSignUpButtonEnabled) ? onPressed : null, 
        onPressed: () {}, 
        child: const Text('Sign Up')
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


  bool _isLoading = false;
  String? _error;

  bool _isSignUpButtonEnabled = false;

  final Authentication _authentication = getIt<Client>().authentication();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
}