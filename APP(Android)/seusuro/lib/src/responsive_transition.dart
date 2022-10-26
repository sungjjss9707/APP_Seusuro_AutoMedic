import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';

Transition rTransition() {
  if (!DataController.to.isDesktop()) {
    // Mobile
    return Transition.native;
  } else {
    // Desktop
    return Transition.noTransition;
  }
}
