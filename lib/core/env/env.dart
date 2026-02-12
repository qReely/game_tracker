import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'RAWG_API_KEY', obfuscate: true)
  static final String rawgApiKey = _Env.rawgApiKey;
}