import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pm1_task_management/bloc/profile/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perusahaan'),
        backgroundColor: const Color.fromARGB(255, 63, 169, 255),
        actions: [
          GestureDetector(
            onTap: () {
              context.read<ProfileBloc>().add(ProfileEventGet(auth.currentUser!.uid));
              context.go('/profile');
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI9lRck6miglY0SZF_BZ_sK829yiNskgYRUg&s',
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CompanyCard(
              companyName: 'PT. Minori',
              imageUrl: 'https://connect-assets.prosple.com/cdn/ff/H18oE6gkw1zZezriRozJV8MmZs2bB9T9Edo132x1dBk/1639743459/public/styles/scale_and_crop_center_398x128/public/2021-08/logo%20minori%20Indonesia.jpg?itok=vN7LlkpD',
              onTap: () {
                // Add action if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String companyName;
  final String imageUrl;
  final VoidCallback onTap;

  const CompanyCard({
    Key? key,
    required this.companyName,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                companyName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
