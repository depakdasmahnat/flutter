enum Roles {
  admin('Admin'),
  premium('Premium'),
  user('User');

  final String value;

  const Roles(this.value);
}

enum Genders {
  male('Male'),
  female('Female'),
  other('Other');

  final String value;

  const Genders(this.value);
}

enum OrderStatuses {
  all('All'),
  placed('Order Placed'),
  processing('Processing'),
  confirmed('Order Confirmed'),
  completed('Completed');

  final String value;

  const OrderStatuses(this.value);
}
