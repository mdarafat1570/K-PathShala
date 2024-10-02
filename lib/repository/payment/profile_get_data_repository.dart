import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/profile_model/profile_get_data_model.dart';
import 'package:kpathshala/api/api_container.dart';

class ProfileRepository {
  final BaseRepository _baseRepository = BaseRepository();
  Future<ProfileGetDataModel?> fetchProfile(BuildContext context) async {
    try {
      final response =
          await _baseRepository.getRequest(KpatshalaProfaile.profileData,context: context);

      if (response['status'] == 'success') {
        log("This is profile data : ${response}");

        return ProfileGetDataModel.fromJson(response['data']);
      } else {
        // Log error response
        log('Error fetching profile: ${response['message']}');
        return null;
      }
    } catch (e) {
      // Handle exceptions or logging
      log('Exception in fetching profile: $e');
      return null;
    }
  }
}
