/// Dart import
import 'dart:math' as math;

/// Packages import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set customer's data collection to data grid source.
class CustomerDataGridSource extends DataGridSource {
  /// Creates the customer data source class with required details.
  CustomerDataGridSource({required this.isWebOrDesktop}) {
    customerInfo = getCustomerInfo(100);
    buildDataGridRows();
  }

  /// Determine to decide whether the platform is web or desktop.
  final bool isWebOrDesktop;

  final math.Random _random = math.Random();

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Instance of customer info.
  List<Customer> customerInfo = <Customer>[];

  /// Building DataGridRows
  void buildDataGridRows() {
    dataGridRows = customerInfo.map<DataGridRow>((Customer dataGridRow) {
      return isWebOrDesktop
          ? DataGridRow(cells: <DataGridCell>[
              DataGridCell<Image>(columnName: 'Dealer', value: dataGridRow.dealer),
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<double>(columnName: 'Freight', value: dataGridRow.freight),
              DataGridCell<DateTime>(columnName: 'Shipped Date', value: dataGridRow.shippedDate),
              DataGridCell<String>(columnName: 'City', value: dataGridRow.city),
              DataGridCell<double>(columnName: 'Price', value: dataGridRow.price),
            ])
          : DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<DateTime>(columnName: 'Shipped Date', value: dataGridRow.shippedDate),
              DataGridCell<String>(columnName: 'City', value: dataGridRow.city),
            ]);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  Widget _buildDealer(dynamic value) {
    return Container(
      padding: const EdgeInsets.all(3),
      alignment: Alignment.center,
      child: value,
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return isWebOrDesktop
        ? DataGridRowAdapter(cells: <Widget>[
            _buildDealer(row.getCells()[0].value),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[1].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[2].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2)
                    .format(row.getCells()[3].value),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMd().format(row.getCells()[4].value),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[5].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2)
                    .format(row.getCells()[6].value),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ])
        : DataGridRowAdapter(cells: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[0].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[1].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMd().format(row.getCells()[2].value),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[3].value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]);
  }

  // CustomerInfo Data set

  final List<Image> _dealers = <Image>[
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
    Image.asset(AppAssets.userIcon),
  ];

  final List<String> _names = <String>[
    'Betts',
    'Adams',
    'Crowley',
    'Stark',
    'Keefe',
    'Doran',
    'Newberry',
    'Blanc',
    'Gable',
    'Balnc',
    'Perry',
    'Lane',
    'Grimes'
  ];

  final List<DateTime> _shippedDates = <DateTime>[
    DateTime.now(),
    DateTime(2002, 8, 27),
    DateTime(2015, 7, 4),
    DateTime(2007, 4, 15),
    DateTime(2010, 12, 23),
    DateTime(2010, 4, 20),
    DateTime(2004, 6, 13),
    DateTime(2008, 11, 11),
    DateTime(2005, 7, 29),
    DateTime(2009, 4, 5),
    DateTime(2003, 3, 20),
    DateTime(2011, 3, 8),
    DateTime(2013, 10, 22),
  ];

  final List<String> _cities = <String>[
    'Graz',
    'Bruxelles',
    'Rosario',
    'Recife',
    'Campinas',
    'Montreal',
    'Tsawassen',
    'Resende',
  ];

  /// Get customer info collection.
  List<Customer> getCustomerInfo(int count) {
    final List<Customer> employeeData = <Customer>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(Customer(
        _dealers[i < _dealers.length ? i : _random.nextInt(_dealers.length - 1)],
        1100 + i,
        _names[i < _names.length ? i : _random.nextInt(_names.length - 1)],
        _random.nextInt(1000) + _random.nextDouble(),
        _shippedDates[_random.nextInt(_shippedDates.length - 1)],
        _cities[_random.nextInt(_cities.length - 1)],
        1500.0 + _random.nextInt(100),
      ));
    }
    return employeeData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the customer info which will be rendered in datagrid.
class Customer {
  /// Creates the customer info class with required details.
  Customer(this.dealer, this.id, this.name, this.price, this.shippedDate, this.city, this.freight);

  /// Id of customer.
  final int id;

  /// Name of customer.
  final String name;

  /// Price of customer product.
  final double price;

  /// Shipped date of the product
  final DateTime shippedDate;

  /// Image of the customer.
  final Image dealer;

  /// Freight of the customer.
  final double freight;

  /// City of the customer
  final String city;
}
