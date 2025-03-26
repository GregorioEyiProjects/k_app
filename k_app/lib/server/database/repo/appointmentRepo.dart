import 'package:k_app/objectbox.g.dart';
import 'package:k_app/server/models/appointment-model.dart';

class AppointmentRepo {
  //Model or Entity or DataClass
  late final Box<Appointment> _appointmentBox;

  /*
    CONSTRUCTOR
    The colon (:) introduces the initializer list. The initializer list is used to initialize 
    instance variables before the constructor body runs. Here, _appointmentBox is being initialized with 
    the result of store.box<Appointment>(). 
  */
  AppointmentRepo(Store store) : _appointmentBox = store.box<Appointment>();

  // Get appointments
  Stream<List<Appointment>> getAppointments2() {
    final query = _appointmentBox.query().watch(triggerImmediately: true);
    return query.map((query) => query.find());
    //return _appointmentBox.getAll();
  }

  Future<List<Appointment>> getAppointments() async {
    return _appointmentBox.getAll();
  }

  // Add appointments
  Future<Appointment> addAppointment(Appointment appointment) async {
    final Appointment response =
        await _appointmentBox.putAndGetAsync(appointment);
    return response;
  }

  // Update appointments
  void updateAppointment(Appointment appointment) async {
    //appointment.isCompleted = true;
    await _appointmentBox.put(appointment);
  }

  // Delete appointments
  Future<bool> deleteAppointment(int appointmentID) async {
    final Future<bool> response = _appointmentBox.removeAsync(appointmentID);
    //await _appointmentBox.remove(appointmentID);
    return response;
  }
}
