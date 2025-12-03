import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/logic/cubit/login_cubit.dart';
import 'package:legal_assistant_app/presentation/views/sign_in_view.dart';

class ContainerChat extends StatelessWidget {
  final IconData icon;
  const ContainerChat({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(231, 214, 248, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: () {
          // Navigator.pop(context); 
          // Logout
        context.read<LoginCubit>().logout();

        // Navigate to SignInView
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SignInView()),
        );
        },
        icon: Icon(icon, color: Colors.black, size: 25),
      ),
    );
  }
}
