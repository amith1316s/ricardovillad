import 'package:baratinha/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApostaService {
  UserService userService = new UserService();
  Firestore _firestore = Firestore.instance;

  Future<bool> addTicket(List<int> selectedNumbers, double cost) async {
    // String uid = await userService.getUserId();

    await _firestore.collection('Tickets').add({
      '1': selectedNumbers.length > 0 ? selectedNumbers[0] : null,
      '2': selectedNumbers.length > 1 ? selectedNumbers[1] : null,
      '3': selectedNumbers.length > 2 ? selectedNumbers[2] : null,
      '4': selectedNumbers.length > 3 ? selectedNumbers[3] : null,
      '5': selectedNumbers.length > 4 ? selectedNumbers[4] : null,
      '6': selectedNumbers.length > 5 ? selectedNumbers[5] : null,
      '7': selectedNumbers.length > 6 ? selectedNumbers[6] : null,
      '8': selectedNumbers.length > 7 ? selectedNumbers[7] : null,
      '9': selectedNumbers.length > 8 ? selectedNumbers[8] : null,
      'cost': cost,
      'date': new DateTime.now()
    });

    return true;
  }
}
