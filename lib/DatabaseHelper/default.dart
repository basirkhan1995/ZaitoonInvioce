import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DefaultValues {
  static String defaultInventory = '''
  INSERT INTO ${Tables.inventoryTableName} (inventoryName) VALUES 
  ('Store'),
  ('Warehouse')
  ''';

  static String defaultUnits = '''
  INSERT INTO ${Tables.productUnitTableName} (unitName) VALUES 
  ('pcs'),
  ('ton'),
  ('kg'),
  ('cm'),
  ('m')
  ''';

  static String defaultCurrencies = '''
  INSERT INTO ${Tables.currencyTableName} (currency_code, currency_name, symbol, isDefault)
  VALUES ('USD', 'United States Dollar', '\$',1),
         ('EUR', 'Euro', '€',0),
         ('GBP', 'British Pound', '£',0),
         ('AFN', 'Afghani', 'AFN',0),
         ('PKR', 'Pakistani', 'PKR',0)
         
  ''';

  static String defaultCurrenciesRates = '''
  INSERT INTO ${Tables.exchangeRatesTableName} (base_currency_code, target_currency_code, rate)
  VALUES ('USD', 'EUR', 0.85)  -- 1 USD = 0.85 EUR
  ''';

  static String defaultAccountCategory = '''
  
  INSERT INTO ${Tables.accountCategoryTableName} (accCategoryId, accCategoryName) VALUES
  (1,'Customer'),
  (2,'Company'),
  (3,'User'),
  (4,'Saraf'),
  (5,'Bank'),
  (6,'Expense'),
  (7,'System'),
  (8,'Admin')
  ''';

  static String defaultSystemAccounts = '''
  INSERT INTO ${Tables.accountTableName} (accId,accountName,accountCategory,createdBy,accountDefaultCurrency) VALUES 
  (1,'Assets',7,1,'AFN'),
  (2,'Profit',7,1,'AFN'),
  (3,'Loss',7,1,'AFN'),
  (4,'Expense',7,1,'AFN')
  ''';

  static String defaultProductCategory = '''
  INSERT INTO ${Tables.productCategoryTableName} (pcName) VALUES 
  ('Electronics'),
  ('Food'),
  ('Beverage')
  ''';

  static String defaultTrnType = '''
  INSERT INTO ${Tables.transactionTypeTableName} (trnTypeName) VALUES
  ('Debit'),
  ('Credit'),
  ('Deposit'),
  ('Withdraw'),
  ('Buy'),
  ('Sell'),
  ('refund'),
  ('exchange'),
  ('transfer')
  ''';
}
