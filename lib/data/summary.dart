import 'dart:async';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lter/cache/cache.dart';

import 'package:lter/data/subs/global_summary.dart';
import 'package:lter/data/subs/national_summary.dart';
import 'package:lter/data/subs/provincial_summary.dart';
import 'package:lter/data/subs/regional_summary.dart';
import 'package:lter/places/places.dart';

/// This constant represents the url to the global and national summaries

const _url = "https://api.covid19api.com/summary";

/// This constant represents the url to the regional summaries

final _regionsUrl = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/${_latestRegionalDate()}.csv";

/// This constant represents the url to the us regional summaries

final _usRegionsUrl = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/${_latestRegionalDate()}.csv";

/// This constant represents the url to the it provincial summaries

const _provincesUrl = "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-province-latest.json";

/// This variable represents the global summary in use and the only reference of its type

var globalSummary;

/// This variable represents the national summaries in use and the only reference of its type

var nationalSummaries;

/// This variable represents the regional summaries in use and the only reference of its type

var regionalSummaries;

/// This variable represents the it provincial summaries in use and the only reference of its type

var provincialSummaries;

/// This class represents an abstract concept of a summary

abstract class AbstractSummary {

  /// This constant represents the name of the summary's place

  final String name;

  /// This constant represents the total number of cases

  final dynamic totalConfirmed;

  /// This constant represents the number of new daily cases

  final dynamic newConfirmed;

  /// This constant represents the total number of deaths

  final dynamic totalDeaths;

  /// This constant represents the number of new daily deaths

  final dynamic newDeaths;

  /// This constant represents the total number of recoveries

  final dynamic totalRecovered;

  /// This constant represents the number of new daily recoveries

  final dynamic newRecovered;

  /// This constant represents the number of current cases

  final dynamic currentCases;

  /// This is the constructor of the class, -1 is used for numbers that are not available

  const AbstractSummary([
    this.name,
    this.totalConfirmed = -1,
    this.newConfirmed = -1,
    this.totalDeaths = -1,
    this.newDeaths = -1,
    this.totalRecovered = -1,
    this.newRecovered = -1,
    this.currentCases = -1
  ]);
}

/// This method returns the summary of the country with the given name

NationalSummary nationalSummaryByName(String name) {
  return nationalSummaries.firstWhere((country) => country.name == name);
}

/// This method returns the summary of the region with the given name

RegionalSummary regionalSummaryByName(String name) {
  return regionalSummaries.firstWhere((region) => region.name == name);
}

/// This method returns the summary of the province with the given name

ProvincialSummary provincialSummaryByName(String name) {
  return provincialSummaries.firstWhere((province) => province.name == name);
}

/// This method creates, sets and updates the global summary from the given body

void _globalSummary(String body, Map<String, dynamic> json, [bool update = false]) {
  if (update) GLOBAL_NATIONAL_SUMMARIES_CACHE.write(body);
  globalSummary = GlobalSummary.fromJson(json["Global"]);
}

/// This method creates, sets and updates the national summaries from the given body

Future<void> _nationalSummaries(String body, Map<String, dynamic> json, [bool update = false]) async {
  final List<NationalSummary> summaries = [];
  final List<Country> places = [];
  (json["Countries"] as List).forEach((element) {
    places.add(Country.fromJson(element));
    summaries.add(NationalSummary.fromJson(element));
  });
  countries = places;
  summaries.sort((a, b) => b.currentCases - a.currentCases);
  nationalSummaries = summaries;
}

/// This method creates, sets and updates the regional summaries from the given body

Future<void> _regionalSummaries(String body, String usBody, [bool update = false]) async {
  if (update) {
    REGIONAL_SUMMARIES_CACHE.write(body); 
    US_REGIONAL_SUMMARIES_CACHE.write(usBody);
  }
  final converter = CsvToListConverter(
      eol: "\n"
  );
  final List<RegionalSummary> summaries = [];
  final List<Region> places = [];
  final Map<String, Set<Region>> byCountry = {};
  final csv = converter.convert(body);
  csv.removeAt(0);
  csv.removeWhere((e) => e[1] != "" || e[2] == "");
  csv.forEach((e) {
    var country = countryByName(e[3]);
    var region = Region(
        e[11],
        country.name,
        country.flag
    );
    places.add(region);
    summaries.add(RegionalSummary.fromList(e));
    byCountry.putIfAbsent(country.name, () => {});
    byCountry[country.name].add(region);
  });
  final usCsv = converter.convert(usBody);
  usCsv.removeAt(0);
  usCsv.forEach((e) {
    var region = Region(
      e[0] + ", United States of America",
      "United States of America",
      "resources/flags/us.png"
    );
    places.add(region);
    summaries.add(RegionalSummary.usFromList(e));
    byCountry["United States of America"].add(region);
  });
  places.sort((a, b) => a.name.compareTo(b.name));
  regions = places;
  regionalSummaries = summaries;
  regionsByCountry = byCountry;
}

/// This method creates, sets and updates the provincial summaries from the given body

Future<void> _provincialSummaries(String body, [bool update = false]) async {
  if (update) IT_PROVINCIAL_SUMMARIES_CACHE.write(body);
  final List<ProvincialSummary> summaries = [];
  final List<Province> places = [];
  final Map<String, Set<Province>> byCountry = {};
  (jsonDecode(body) as List).forEach((e) {
    var name = e["denominazione_provincia"].toString();
    var regionName = e["denominazione_regione"].toString();
    var regionNameCombined = "$regionName, Italy";
    if (!name.startsWith("In fase di") && !name.startsWith("Fuori Regione")) {
      var province = Province(
          "$name, $regionName",
          "Italy",
          "resources/flags/it.png",
          regionNameCombined
      );
      places.add(province);
      summaries.add(ProvincialSummary.fromJson(e));
      byCountry.putIfAbsent(regionNameCombined, () => {});
      byCountry[regionNameCombined].add(province);
    }
  });
  places.sort((a, b) => a.name.compareTo(b.name));
  provinces = places;
  provincialSummaries = summaries;
  provincesByRegion = byCountry;
}

/// This method fetches all the current summaries from the internet. It is run
/// every time the user starts the application

Future<String> fetchSummaries() async {
  try {
    final body = (await get(_url)).body;
    final json = jsonDecode(body);
    _globalSummary(body, json, true);
    await _nationalSummaries(body, json, true);
    await _regionalSummaries((await get(_regionsUrl)).body, (await get(_usRegionsUrl)).body, true);
    await _provincialSummaries((await get(_provincesUrl)).body, true);
  } catch (e) {
    fetchCachedSummaries();
  }
  return "";
}

/// This method fetches all the latest summaries from the cache. It is run if the
/// user isn't able to fetch all the summaries from the internet

Future<String> fetchCachedSummaries() async {
  try {
    final body = await GLOBAL_NATIONAL_SUMMARIES_CACHE.read();
    final json = jsonDecode(body);
    _globalSummary(body, json);
    await _nationalSummaries(body, json);
    await _regionalSummaries(await REGIONAL_SUMMARIES_CACHE.read(), await US_REGIONAL_SUMMARIES_CACHE.read());
    await _provincialSummaries(await IT_PROVINCIAL_SUMMARIES_CACHE.read());
  } catch (e) {
    _fetchDefaultSummaries();
  }
  return "";
}

/// This method fetches all the default summaries from the assets folder. It is run
/// if the user isn't able to fetch all the summaries from the cache

Future<void> _fetchDefaultSummaries() async {
  Future<String> _loadString(String path, [String format = ".json"]) => rootBundle.loadString("resources/defaults/default_" + path + format);
  final body = await _loadString("global_summary");
  final json = jsonDecode(body);
  _globalSummary(body, json);
  await _nationalSummaries(body, json);
  await _regionalSummaries(await _loadString("regional_summaries", ".csv"), (await _loadString("us_regional_summaries", ".csv")));
  await _provincialSummaries(await _loadString("provincial_summaries"));
  return "";
}

/// This method returns the last day the regional summaries were updated

String _latestRegionalDate() {
  final date = DateTime.now().toUtc();
  final formatter =  DateFormat("MM-dd-yyyy");
  if (date.hour >= 4 && date.minute >= 1) {
    return formatter.format(
        date.subtract(
            Duration(
                days: 1
            )
        )
    );
  }
  return formatter.format(
      date.subtract(
          Duration(
              days: 2
          )
      )
  );
}