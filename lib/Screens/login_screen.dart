import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/Screens/signup_screen.dart';
import 'package:instagram_flutter/main.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/gloabal_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _isLoading=false;
  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  logInUser() async{

    setState(() {
      _isLoading=true;
    });
    String res=await AuthMethods().logInUser(
      email: _emailController.text, 
      password: _passwordController.text
    );
    setState(() {
      _isLoading=false;
    });
    if(res!='success'){
      showSnackBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context){
          return const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(), 
            mobileScreenLayout: MobileScreenLayout()
          );
        })
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width> webScreenSize ? 
          EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width)/3)
          :
          const EdgeInsets.symmetric(horizontal: 32),
          width:double.infinity,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 1),
              //svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 100),
              //text field input for email
              CustomTextField(
                hintText: 'Enter your email', 
                textInputType: TextInputType.emailAddress, 
                textEditingController: _emailController,
              ),
              const SizedBox(height:25),
              //text field input for password
              CustomTextField(
                hintText: 'Enter your password', 
                textInputType: TextInputType.visiblePassword, 
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(height:25),
              //button for login
              InkWell(
                onTap: logInUser,
                child: Container(
                  width:double.infinity,
                  padding:const EdgeInsets.symmetric(vertical:12),
                  alignment: Alignment.center,
                  decoration:const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    color: blueColor,
                  ),
                  child:_isLoading?const Center(child: CircularProgressIndicator(
                    color:primaryColor,
                  ))
                  :
                  const Text('Log in'),
                ),
              ),
              const SizedBox(height:12),
              Flexible(child: Container(),flex: 1),
              //Transitioning to signing up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:const EdgeInsets.symmetric(vertical: 8),
                    child:const Text('Don\'t have an account?'),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(context) {
                            return SignupScreen();
                          }
                        )
                      );
                    },
                    child: Container(
                      padding:const EdgeInsets.symmetric(vertical: 8),
                      child:const Text(
                        ' Sign up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        )
      ),
    );
  }
}