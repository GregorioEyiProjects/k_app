import 'package:k_app/objectbox.g.dart';
import 'package:k_app/server/database/repo/appointmentRepo.dart';
import 'package:k_app/server/database/repo/billingRepo.dart';
import 'package:k_app/server/models/appointment-model.dart';
import 'package:k_app/server/models/billing-model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/* Step 3: Initialize ObjectBox */
class ObjectBox {
  //Store
  late final Store _store;

  //late final Box<Appointment> _appointmentBox;
  late final AppointmentRepo appointmentRepo; // AppointmentRepo
  late final BillingRepo billingRepo; // BillingRepo

  // Keeping reference to avoid Admin getting closed.
  // ignore: unused_field
  late final Admin _admin;

//Constructor
  ObjectBox._create(this._store) {
    if (Admin.isAvailable()) {
      _admin = Admin(_store);
    }
    //_appointmentRepo = Box<Appointment>(_store);
    appointmentRepo = AppointmentRepo(_store);
    billingRepo = BillingRepo(_store);
    //billingRepo.getBillings();
  }

  //Create ObjectBox
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
      directory: p.join(
          (await getApplicationDocumentsDirectory()).path, 'Appointments'),
    );
    return ObjectBox._create(store);
  }
}
