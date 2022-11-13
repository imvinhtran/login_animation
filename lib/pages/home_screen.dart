import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_login/component/dialog/loading_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String validEmail = "admin@gmail.com";
  String validPassword = "123456";
  //Input force controler

  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailControler = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordControler = TextEditingController();

  // Rive Controler Input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordForcus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordForcus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordForcus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              height: 64,
              width: 64,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Image(
                image: AssetImage('assets/rive-logo.png'),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Rive + Flutter \nAnimated Guardian \nPolar Bear',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                'assets/rive-animation.riv',
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                      artboard, "Login Machine");
                  if (controller == null) return;
                  artboard.addController(controller!);
                  isChecking = controller?.findInput('isChecking');
                  numLook = controller?.findInput('numLook');
                  isHandsUp = controller?.findInput('isHandsUp');
                  trigSuccess = controller?.findInput('trigSuccess');
                  trigFail = controller?.findInput('trigFail');
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      focusNode: emailFocusNode,
                      controller: emailControler,
                      // keyboardType: TextInputType.none,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                      onChanged: (value) {
                        numLook?.change(value.length.toDouble());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      focusNode: passwordFocusNode,
                      controller: passwordControler,
                      // keyboardType: TextInputType.none,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();

                        final email = emailControler.text;
                        final password = passwordControler.text;

                        showLoadingDialog(context);

                        await Future.delayed(
                            const Duration(milliseconds: 1500));
                        if (mounted) Navigator.pop(context);
                        if (email == validEmail && password == validPassword) {
                          trigSuccess?.change(true);
                        } else {
                          trigFail?.change(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF183052),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
