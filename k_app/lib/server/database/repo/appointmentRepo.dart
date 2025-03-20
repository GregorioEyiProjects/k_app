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
  Future<List<Appointment>> getAppointments() async {
    return _appointmentBox.getAll();
  }

  // Add appointments
  Future<void> addAppointment(Appointment appointment) async {
    await _appointmentBox.put(appointment);
  }

  // Update appointments
  void updateAppointment(Appointment appointment) async {
    //appointment.isCompleted = true;
    await _appointmentBox.put(appointment);
  }

  // Delete appointments
  void deleteAppointment(int appointmentID) async {
    await _appointmentBox.remove(appointmentID);
  }
}
