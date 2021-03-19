import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// After a summary is fetched from the internet, it is saved inside a local cache 
/// file so that it can be used afterwards in case the user has no internet connection
/// available

/// This constant represents the cache file containing the last global and national 
/// summaries fetched from the internet

const GLOBAL_NATIONAL_SUMMARIES_CACHE = const _CacheFile("global_national_summaries.json");

/// This constant represents the cache file containing the last global regional summaries
/// fetched from the internet

const REGIONAL_SUMMARIES_CACHE = const _CacheFile("regional_summaries.csv");

/// This constant represents the cache file containing the last us regional summaries
/// fetched from the internet

const US_REGIONAL_SUMMARIES_CACHE = const _CacheFile("us_regional_summaries.csv");

/// This constant represents the cache file containing the last it provincial summaries
/// fetched from the internet

const IT_PROVINCIAL_SUMMARIES_CACHE = const _CacheFile("it_provincial_summaries.json");

/// This constant represents the cache file containing the countries, regions and
/// provinces selected by the user

const SELECTED_PLACES_CACHE = const _CacheFile("selected_places.json");

/// This class represents a cache file

class _CacheFile {

  /// This constant represents the name of the cache file

  final String _name;

  /// This is the constructor of the class

  const _CacheFile(this._name);

  /// This getter returns a future to the path to the cache file and creates it if 
  /// it doesn't already exist

  Future<File> get _localFile async {
    return File('${(await getApplicationDocumentsDirectory()).path}/$_name').create();
  }

  /// This method returns a future to the content of the cache file

  Future<String> read() async {
    try {
      return await (await _localFile).readAsString();
    } catch (e) {
      return "null";
    }
  }

  /// This method writes the given content to the cache file

  void write(String content) async {
    (await _localFile).writeAsString(content);
  }
}