import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/auth_controller.dart';
import 'package:emart_seller/views/home_screen/home.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      backgroundColor: red,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.heightBox,
                  normalText(text: welcome, size: 19.0),
                  20.heightBox,
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          icLogo,
                          height: 70,
                          width: 70,
                        )
                            .box
                            .border(color: white)
                            .rounded
                            .padding(EdgeInsets.all(8))
                            .make(),
                        10.widthBox,
                        boldText(text: appname, size: 20.0)
                      ],
                    ),
                  ),
                  40.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        normalText(text: loginTo, size: 18.0, color: lightGrey),
                  ),
                  10.heightBox,
                  Column(
                    children: [
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          fillColor: textfieldGrey,
                          filled: true,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                          hintText: emailHint,
                        ),
                      ),
                      10.heightBox,
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: textfieldGrey,
                          filled: true,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.red,
                          ),
                          hintText: passwordHint,
                        ),
                      ),
                      10.heightBox,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: normalText(
                                text: forgotPassword, color: Colors.red)),
                      ),
                      20.heightBox,
                      SizedBox(
                          width: context.screenWidth - 100,
                          child: controller.isLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : OurButton(
                                  title: login,
                                  onPress: () async {
                                    controller.isLoading(true);
                                    await controller
                                        .loginMethod(context: context)
                                        .then((value) {
                                      if (value != null) {
                                        VxToast.show(context, msg: "Logged In");
                                        controller.isLoading(false);
                                        Get.offAll(() => Home());
                                      } else {
                                        controller.isLoading(false);
                                      }
                                    });
                                  }))
                    ],
                  )
                      .box
                      .white
                      .rounded
                      .outerShadowMd
                      .padding(const EdgeInsets.all(8))
                      .make(),
                  20.heightBox,
                  Center(
                    child: normalText(text: anyProblem, color: lightGrey),
                  ),
                  Spacer(),
                  Center(child: boldText(text: credit)),
                  20.heightBox,
                ],
              )),
        ),
      ),
    );
  }
}
