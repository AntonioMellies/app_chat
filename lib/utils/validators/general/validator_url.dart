
import 'package:chat/utils/validators/validator.dart';

class ValidatorUrl implements Validator {
  ValidatorUrl();

  @override
  String? valid(String value) {
    bool isValidUrl = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    return !isValidUrl ? 'Url invalida' : null;
  }
}
