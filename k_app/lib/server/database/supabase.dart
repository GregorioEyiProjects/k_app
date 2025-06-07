import 'package:k_app/server/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
/*   final String _anoKey = anonKey;
  final String _projectURL = projectURL; */
  await Supabase.initialize(
    url: projectURL,
    anonKey: anonKey,
  );
}
