// to convert the response into a non nullable object (model)

import 'package:clean_architect_app/app/extensions.dart';
import 'package:clean_architect_app/data/responses/response.dart';
import 'package:clean_architect_app/domain/model.dart';

const EMPTY ="";
const ZERO = 0;
extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(this?.id?.orEmpty() ?? EMPTY, this?.name?.orEmpty() ?? EMPTY,
        this?.numOfNotifications?.orZero() ?? ZERO);
  }
}
extension ContactResponseMapper on ContactResponse? {
  Contacts toDomain() {
    return Contacts(this?.email?.orEmpty() ?? EMPTY, this?.phone?.orEmpty() ?? EMPTY,
        this?.link?.orEmpty() ?? EMPTY);
  }
}
extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(this?.customer?.toDomain(),this?.contacts?.toDomain());
  }
}
