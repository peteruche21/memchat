import 'package:rxdart/rxdart.dart';

import '/backend/schema/structs/index.dart';
import 'custom_auth_manager.dart';

class MemChatAuthUser {
  MemChatAuthUser({
    required this.loggedIn,
    this.uid,
    this.userData,
  });

  bool loggedIn;
  String? uid;
  UserStruct? userData;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<MemChatAuthUser> memChatAuthUserSubject =
    BehaviorSubject.seeded(MemChatAuthUser(loggedIn: false));
Stream<MemChatAuthUser> memChatAuthUserStream() => memChatAuthUserSubject
    .asBroadcastStream()
    .map((user) => currentUser = user);
