import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pm1_task_management/bloc/auth/auth_bloc.dart';
import 'package:pm1_task_management/visibility_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
                'https://png.pngtree.com/thumb_back/fw800/background/20230922/pngtree-a-vertical-view-of-a-tall-building-with-clear-glass-walls-image_13307142.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'LOGIN \n Smart Building ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Memudahkan untuk memonitoring ruangan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 255, 252, 252)),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocConsumer<VisibilityCubit, bool>(
                  listener: (context, state) {},
                  builder: (context, isObscured) {
                    return TextFormField(
                      controller: passC,
                      obscureText: isObscured,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            context.read<VisibilityCubit>().change();
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthEventLogin(
                            email: emailC.text,
                            password: passC.text,
                          ),
                        );
                  },
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthStateError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          duration: const Duration(seconds: 2),
                        ));
                      } else if (state is AuthStateLoaded) {
                        // Pindah ke halaman home menggunakan GoRouter
                        context.go('/');
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthStateLoading) {
                        return const Text('Please Wait...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ));
                      }
                      return const Text('Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ));
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
