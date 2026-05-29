import 'package:flutter/material.dart';
import 'package:spendsmart/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool isDarkMode =true;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Settings',),
        backgroundColor: Colors.black87,
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            color: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(Icons.dark_mode_outlined),
              trailing: Switch(value: isDarkMode, onChanged: (value) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              activeColor: Color(0xFF6C63FF),),
            ),
          )
        ],
      ),),
    );
  }
}