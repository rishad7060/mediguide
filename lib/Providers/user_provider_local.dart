import 'package:flutter/foundation.dart';
import 'package:medical/helpers/db_helper.dart';
import 'package:medical/model/user.dart';

class UserProviderLocal extends ChangeNotifier {
  List<User> _UserDetailsInform = [];

  List<User> get userDetailsInform {
    return [..._UserDetailsInform];
  }

  Future GetUserDetails() async {
    // List _temp2 = [];
    var _temp = await DBHelper.getAll('User');
    // _temp.forEach((e) {
    //   _temp2.add(e['client']);
    // });
    _UserDetailsInform = await User.UsersDetailsFromSnapshot(_temp);
    notifyListeners();
    // // print(_ClientDetailsInform);
    // // print('--------------');
    // // print(_temp);
    // return _ClientDetailsInform;
  }

  Future<List> getUsersDetail(String clientId) async {
    var result = await DBHelper.getByWhere('Users', 'id_local=?', [clientId]);

    return result;
  }

  Future<void> insertUserDetail(List savedUser) async {
    await DBHelper.customQuery(
        'INSERT INTO Users (id_local) SELECT "1" WHERE NOT EXISTS(SELECT * FROM Users WHERE id_local="1")',
        []);
    var data = {
      'name': savedUser[0]['name'].toString(),
      'auth': savedUser[0]['auth'].toString(),
      'weight': savedUser[0]['weight'],
      'calories': savedUser[0]['calories']
    };
    await DBHelper.update('Users', 'id_local=1', [], data);
  }

  // void deleteSelectedClientDetail() async {
  //   await DBHelper.delete('SelectedClient', 'id_local=1', []);
  // }

  Future<void> insertClient(User user) async {
    Map<String, dynamic> d = {
      'name': user.name,
      'auth': user.auth,
      'weight': user.weight,
      'calories': user.calories,
    };
    // print(d);
    await DBHelper.insert('User', d);
    // _ClientDetailsInform.add(client);
    var res = await DBHelper.getAll('Client');
    _UserDetailsInform = await User.UserFromSnapshot(res);

    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    Map<String, dynamic> d = {
      'name': user.name,
      'weight': user.weight,
      'calories': user.calories,
    };
    // print(client);

    await DBHelper.update('User', 'id_local=?', [user.id.toString()], d);

    var res = await DBHelper.getAll('User');
    // _temp.forEach((e) {
    //   _temp2.add(e['client']);
    // });
    print(d);
    _UserDetailsInform = await User.UsersDetailsFromSnapshot(res);
    notifyListeners();
  }
}
