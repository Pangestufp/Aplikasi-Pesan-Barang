import 'package:aplikasipemesananpulaubaru/app/controllers/AuthController.dart';
import 'package:aplikasipemesananpulaubaru/shared/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Styles.tertiaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Styles.secondaryColor,
              Styles.tertiaryColor,
            ],
            stops: [0.8, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 350,
                child: Center(
                  child: Image.asset(
                    'assets/images/Pulau_Baru.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Styles.tertiaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20,top: 100, bottom: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Styles.secondaryColor,
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.account_circle, color: Styles.primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Styles.primaryColor, width: 2.0),
                            ),
                          ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                        ),
                        const SizedBox(height: 20),
                        Obx(
                              () => TextFormField(

                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Styles.secondaryColor,
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline, color: Styles.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Styles.primaryColor,
                                ),
                                onPressed: () {
                                  controller.togglePasswordVisibility();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Styles.primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Styles.primaryColor, width: 2.0),
                              ),
                            ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  return null;
                                },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(
                              () => Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                                      onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        controller.login();
                                      }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Styles.primaryColor,
                                  foregroundColor: Styles.secondaryColor,
                                                      ),
                                                      child: controller.isLoading.value
                                    ? const CircularProgressIndicator(
                                  color: Styles.secondaryColor,
                                  strokeWidth: 2,
                                                      )
                                    : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                                      ),
                                                    ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}