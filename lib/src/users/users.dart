import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:microsoft_graph_api/models/models.dart';

class Users {
  final String _token;
  Users(this._token);

  final Dio _dio = Dio();

  /// Sends a GET request to the Microsoft Graph API to fetch user information for a specific user.
  ///
  /// This function returns a `Future<User>`, which means it executes asynchronously and returns a `User` object when it completes.
  ///
  /// If the request is successful, the response data is converted into a `User` object by applying the `fromJson` method on the `User` class.
  ///
  /// In case of an error (e.g., network error, invalid response data, etc.), the function catches the exception, logs an appropriate error message, and returns an empty `User` object.
  ///
  /// Note that `$token` in `Bearer $token` is a variable that contains the access token needed for authenticating the request. This token must be set prior to the execution of the function.
  ///
  /// The `userId` parameter is a string representing the unique identifier of the user to fetch information for.
  Future<User> fetchSpecificUserInfo(String userId) async {
    try {
      final response = await _dio.get(
        'https://graph.microsoft.com/v1.0/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      return User.fromJson(response.data);
    } catch (e) {
      log('Failed to fetch specific user info: $e');
      return const User.empty();
    }
  }

  /// Creates a new user using the Microsoft Graph API.
  ///
  /// [displayName] is the name displayed in the address book for the user.
  /// [mailNickname] is the mail alias for the user.
  /// [userPrincipalName] is the user principal name (UPN) of the user.
  /// [password] is the password for the user.
  ///
  /// This method sends a POST request to the Microsoft Graph API to create a new user
  /// with the provided details.
  ///
  /// If the request is successful, it returns a `User` object created from the API response.
  ///
  /// If the request fails, it logs the error message and returns an empty `User` object.
  Future<User> createUser(String displayName, String mailNickname,
      String userPrincipalName, String password) async {
    try {
      final data = {
        "accountEnabled": true,
        "displayName": displayName,
        "mailNickname": mailNickname,
        "userPrincipalName": userPrincipalName,
        "passwordProfile": {
          "forceChangePasswordNextSignIn": true,
          "password": password
        }
      };

      final response = await _dio.post(
        'https://graph.microsoft.com/v1.0/users',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return User.fromJson(response.data);
    } catch (e) {
      log('Failed to create user: $e');
      return const User.empty();
    }
  }

  /// Deletes a user using the Microsoft Graph API.
  ///
  /// [userId] is the unique identifier of the user to be deleted.
  ///
  /// This method sends a DELETE request to the Microsoft Graph API to delete the user
  /// with the provided user ID.
  ///
  /// If the request is successful, it returns `true`.
  ///
  /// If the request fails, it logs the error message and returns `false`.
  Future<bool> deleteUser(String userId) async {
    try {
      await _dio.delete(
        'https://graph.microsoft.com/v1.0/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      return true;
    } catch (e) {
      log('Failed to delete user: $e');
      return false;
    }
  }

  /*-----------------------------BETA--------------------------------*/

  /// !!!...............BETA...............
  /// Fetches all user rooms asynchronously from the Microsoft Graph API.
  ///
  /// This method sends a GET request to the 'findRooms' endpoint
  /// of the Microsoft Graph API and converts the response data into a
  /// list of 'Room' objects. If the request fails, the error is logged
  /// and rethrown.
  ///
  /// Returns:
  /// A Future list of 'Room' objects, representing all rooms fetched
  /// by the user.
  Future<List<Room>> fetchAllUserRooms() async {
    try {
      final response = await _dio.get(
        'https://graph.microsoft.com/beta/me/findRooms',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
          contentType: 'application/json',
        ),
      );

      // Convert the response data to Room objects
      final rooms = (response.data['value'] as List)
          .map((item) => Room.fromJson(item))
          .toList();

      log('Rooms: $rooms');

      return rooms;
    } catch (e) {
      log('Failed to fetch rooms: $e');
      rethrow;
    }
  }

  /// Shuts down the dio client associated with this instance.
  ///
  /// If [force] is false (the default) the [Dio] will be kept alive until all
  /// active connections are done. If [force] is true any active connections
  /// will be closed to immediately release all resources. These closed
  /// connections will receive an error event to indicate that the client was
  /// shut down. In both cases trying to establish a new connection after
  /// calling [close] will throw an exception.
  void close({bool force = false}) {
    _dio.close(force: force);
  }
}
