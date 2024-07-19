
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';
import 'dart:typed_data';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  
  Uint8List? _image;
  bool _isLoading=false;
  @override
  void initState() {

    super.initState();
    getDefaultImage();
  }
  Future<void> getDefaultImage()async {
    //print("assets/8380015.jpg");
    ByteData bytes= await rootBundle.load('assets/8380015.jpg');
    _image=bytes.buffer.asUint8List();
    if(_image ==null){
      debugPrint("Yes");
    }
  }
  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }
  void selectImage()async{
    _image = await pickImage(ImageSource.gallery);
    setState(() {
      
    });
  }
  void signUpUser()async{
    setState(() {
      _isLoading=true;
    });
    //debugPrint('signup_screen');
    String res = await AuthMethods().signUpUser(
      email: _emailController.text, 
      username: _usernameController.text, 
      bio: _bioController.text, 
      password: _passwordController.text,
      file: _image!,
   );
   setState(() {
     _isLoading = false;
   });
   print(res);
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
          padding:const EdgeInsets.symmetric(horizontal: 32),
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
              const SizedBox(height: 25),
              //Circular avatar for pic
              Stack(
                children:[
                  _image!=null?
                  CircleAvatar(
                    radius:64,
                    backgroundImage:MemoryImage(_image!)
                  ):
                  const CircleAvatar(
                    radius:64,
                    backgroundImage: AssetImage('assets/8380015.jpg'),
                  ),
                  
                  Positioned(
                    right: -14,
                    bottom: -2,
                    child: IconButton(
                      onPressed: selectImage, 
                      icon:const Icon(Icons.add_a_photo,color: Color.fromARGB(255, 85, 87, 87),)
                    ),
                  )
                ]
              ),
              const SizedBox(height: 25),
              //text field input for username
              CustomTextField(
                hintText: 'Enter your username', 
                textInputType: TextInputType.text, 
                textEditingController: _usernameController,
              ),
              const SizedBox(height:25),
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
              //text field for bio
              CustomTextField(
                hintText: 'Enter your bio', 
                textInputType: TextInputType.text, 
                textEditingController: _bioController,
              ),
              const SizedBox(height:25),
              //button for sign up
              InkWell(
                onTap: signUpUser,
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
                  const Text('sign up'),
                ),
              ),
              const SizedBox(height:12),
              Flexible(child: Container(),flex: 1),
            ],
          )
        )
      ),
    );
  }
}