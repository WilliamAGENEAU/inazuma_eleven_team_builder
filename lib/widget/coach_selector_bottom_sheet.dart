// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class CoachSelectorBottomSheet extends StatefulWidget {
  final Function(String) onCoachSelected;

  const CoachSelectorBottomSheet({super.key, required this.onCoachSelected});

  @override
  State<CoachSelectorBottomSheet> createState() =>
      _CoachSelectorBottomSheetState();
}

class _CoachSelectorBottomSheetState extends State<CoachSelectorBottomSheet> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> coachs = [];

  @override
  void initState() {
    super.initState();
    _loadCoachs();
  }

  void _loadCoachs() async {
    final data = await _firebaseService.getAllCoachs();
    setState(() => coachs = data);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.greenAccent, Colors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: coachs.length,
          itemBuilder: (context, index) {
            final coach = coachs[index];
            return GestureDetector(
              onTap: () {
                widget.onCoachSelected(coach);
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(coach, fit: BoxFit.contain),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
