import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_screen_layout.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getBytes(
        'https://media.istockphoto.com/id/1364105164/photo/hologram-human-head-deep-learning-and-artificial-intelligence-abstract-background.jpg?s=2048x2048&w=is&k=20&c=SLWe2u1zeCyZwUq6klqq-F8UUQUrGOOO3GAbSg_r_2s=');
  }

  void _getBytes(imageUrl) async {
    final ByteData data =
        await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    setState(() {
      _image = data.buffer.asUint8List();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void signUpUser(context) async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreen(),
              webscreenLayout: WebScreenLayout())));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //svg image
          Flexible(
            flex: 2,
            child: Container(),
          ),
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),
          //text field input for email
          const SizedBox(
            height: 64,
          ),
          Stack(
            children: [
              _image == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ))
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _usernameController,
              hintText: "Enter your username",
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your password",
              isPass: true,
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _bioController,
              hintText: "Enter your Bio",
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () => signUpUser(context),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: blueColor),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text('Sign Up'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Have an account?"),
              ),
              GestureDetector(
                onTap: () => navigateToLogin(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
          //text field input for password
          //button login
          //Sign up button
        ]),
      )),
    );
  }
}
