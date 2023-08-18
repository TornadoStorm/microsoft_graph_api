library microsoft_graph_api;

import 'package:microsoft_graph_api/src/calendars/calendars.dart';
import 'package:microsoft_graph_api/src/me/me.dart';
import 'package:microsoft_graph_api/src/meetingrooms/meetingrooms.dart';
import 'package:microsoft_graph_api/src/places/places.dart';
import 'package:microsoft_graph_api/src/users/users.dart';

/// Class for interacting with the Microsoft Graph API.
/// This class serves as the central access point to the various
/// areas of the Microsoft Graph API, including users, calendar,
/// meeting rooms, and places.
class MSGraphAPI {
  final String _token;

  /// Represents the authenticated user.
  late Me me;

  /// Provides access to operations on users in the Microsoft Graph API.
  late Users users;

  /// Provides access to operations on the authenticated user's calendar.
  late Calendars calendars;

  /// Provides access to operations on meeting rooms.
  late MeetingRooms meetingRooms;

  /// Provides access to operations on places.
  late Places places;

  /// Creates a new instance of the MSGraphAPI class.
  /// Accepts an authentication token and initializes access to the various
  /// areas of the Microsoft Graph API.
  MSGraphAPI(this._token) {
    me = Me(_token);
    users = Users(_token);
    calendars = Calendars(_token);
    meetingRooms = MeetingRooms(_token);
    places = Places(_token);
  }

  /// Shuts down all dio clients associated with this instance.
  ///
  /// If [force] is false (the default) the [Dio] will be kept alive until all
  /// active connections are done. If [force] is true any active connections
  /// will be closed to immediately release all resources. These closed
  /// connections will receive an error event to indicate that the client was
  /// shut down. In both cases trying to establish a new connection after
  /// calling [close] will throw an exception.
  void close({bool force = false}) {
    me.close(force: force);
    users.close(force: force);
    calendars.close(force: force);
    meetingRooms.close(force: force);
    places.close(force: force);
  }
}
