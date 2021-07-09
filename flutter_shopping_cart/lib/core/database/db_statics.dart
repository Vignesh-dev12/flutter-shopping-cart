class DbStatics {
  /*~~~~~~~~~~~~~~~~~~~~~~ common Database Field~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

  static const String dbName = "shopping_cart.db";
  static const int dbVersion = 1;
  static const _createTable = 'CREATE TABLE IF NOT EXISTS';
  static const _integerAutoIncrement = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const _text = 'TEXT';

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~ Table Assessment Info ~~~~~~~~~~~~~~~~~~~~~~~~~*/

  static const String tableUsers = "users";
  static const String userId = "id";
  static const String userName = "name";
  static const String userDataOfBirth = "date_of_birth";
  static const String userPassword = "password";

  static const String createUsersTable = '$_createTable $tableUsers ('
      '$userId $_integerAutoIncrement,'
      '$userName $_text,'
      '$userDataOfBirth $_text,'
      '$userPassword $_text)';
}
