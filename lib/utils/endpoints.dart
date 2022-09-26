// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
//import User from '../models/User';
import '../models/Affimation.dart';
import '../models/Exercise.dart';
import '../models/Goal.dart';
import '../models/MoodTracker.dart';
import '../models/Reminder.dart';
import '../models/Thoughts.dart';
import '../models/User.dart';
import '../models/SleepRecord.dart';
import 'package:http/http.dart' as http;

//global variable to store the token

class DataBaseHelper {
  //final BASE_URL = 'http://10.0.2.2:8081/';
  final BASE_URL = 'https://mentalhealthapp2022.herokuapp.com/';

  Future<String> authenticate(String userName, String password) async {
    final url = '${BASE_URL}authenticate';
    http.Response auth = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'userName': userName, 'password': password}));

    return (json.decode(auth.body))['token'];
  }

  Future<int> authenticateToGetId(String userName, String password) async {
    final url = '${BASE_URL}authenticate';
    http.Response auth = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'userName': userName, 'password': password}));
    return (json.decode(auth.body))['id'];
  }

  Future<http.Response> register(
      String userName,
      String email,
      String password,
      String phone,
      String university,
      String province,
      String district,
      String supervisorEmail
      ) async {
    var url = '${BASE_URL}register';
    var body = json.encode({
      'userName': userName,
      'email': email,
      'password': password,
      'role': "ROLE_USER",
      'phone': phone,
      'university': university,
      'province': province,
      'district': district,
      'supervisorEmail': supervisorEmail,
    });

    var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

    return response;
  }

  Future<User> updateUser(
      String userName,
      String password,
      User user,
      ) async {
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/${user.id}");

    Map<String,dynamic> userJson = user.toJson();
    userJson.remove("id");

    http.Response result = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(userJson),
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<User> getUser(
      String userId,
      String userName,
      String password
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List> getUsuarios(String userName, String password) async {
    final requestUrl = "${BASE_URL}api/users/";
    final url = Uri.parse(requestUrl);
    final token = await authenticate(userName, password);
    http.Response result = await http.get(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(utf8.decode(result.bodyBytes));
      final list = jsonResponse['content'];
      return list;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Exercise> createExercise(
      String userId,
      String userName,
      String password,
      Exercise exercise
      ) async {
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/exercises");

    http.Response result = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(exercise),
    );
    print(json.decode(result.body));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Exercise> updateExercise(
      String userId,
      String userName,
      String password,
      Exercise exercise
      ) async {
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/exercises/${exercise.id}");

    Map<String,dynamic> exerciseJson = exercise.toJson();
    exerciseJson.remove("id");

    http.Response result = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(exerciseJson),
    );
    print(json.decode(result.body));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List> getExercisesByUserIdAndDateRange(
      String userId,
      String userName,
      String password,
      String startDate,
      String endDate
      ) async {
    final token = await authenticate(userName, password);
    Map<String,dynamic> parameters = {
      "startDate": startDate,
      "endDate": endDate
    };
    final encodedParameters = Uri(queryParameters: parameters).toString();
    final url = Uri.parse("${BASE_URL}api/users/$userId/exercises/startDate${encodedParameters}");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return jsonResponse['content'];
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Affirmation> updateAffirmation(
      String userId,
      String userName,
      String password,
      Affirmation affirmation
      ) async {
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/affirmations/${affirmation.id}");

    Map<String,dynamic> affirmationJson = affirmation.toJson();
    affirmationJson.remove("id");

    http.Response result = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(affirmationJson),
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Affirmation.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Affirmation> createAffirmation(
      String userId,
      String userName,
      String password,
      Affirmation affirmation,
      ) async {
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/affirmations");

    http.Response result = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'message': affirmation.message,
        'creationDate': affirmation.creationDate,
      }),
    );

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Affirmation.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }
  Future<List<Affirmation>> getAffirmations(
      String userId,
      String username,
      String password
      ) async {

    final token = await authenticate(username, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/affirmations");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      var affirmationMapsList = json.decode(result.body)["content"] as List;
      return affirmationMapsList.map((affirmationJson) => Affirmation.fromJson(affirmationJson)).toList();
    } else {
      throw Exception('Failed request');
    }
  }

  Future<int> deleteAffirmation(
      String affirmationId,
      String userId,
      String username,
      String password,
      )async{

    final token = await authenticate(username, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/affirmations/$affirmationId");

    http.Response result = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Affirmation> getAffirmationByIdAndUserId(String affirmationId, String userId, String username, String password) async {

    final token = await authenticate(username, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/affirmations/$affirmationId");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Affirmation.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  //SLEEP ENDPOINTS

  Future<SleepRecord> createASleepRecord(
      String userId, String userName,
      String password, SleepRecord sleepRecord
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/sleeps");

    http.Response result = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'startDate': sleepRecord.startDate,
        'endDate': sleepRecord.endDate,
        'message': sleepRecord.message,
      }),
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return SleepRecord.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List<SleepRecord>> getSleepsRecords(
      String userId,
      String userName,
      String password
      ) async {
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/sleeps");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      var list = json.decode(result.body)["content"] as List;
      return list.map((json) => SleepRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed request');
    }
  }


  Future<List> getSleepsRecordsByUserIdAndDateRange(
      String userId,
      String userName,
      String password,
      String startDate,
      String endDate
      ) async {
    final token = await authenticate(userName, password);

    Map<String,dynamic> parameters = {
      "startDate": startDate,
      "endDate": endDate
    };

    final encodedParameters = Uri(queryParameters: parameters).toString();
    final url = Uri.parse("${BASE_URL}api/users/$userId/sleeps/startDate${encodedParameters}");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return jsonResponse['content'];
    } else {
      throw Exception('Failed request');
    }

  }

  // GOALS ENDPOINTS

  Future<Goal> createGoal(
      String urlOption,
      String userName,
      String password,
      Goal goal
      ) async {
    final requestUrl = "${BASE_URL}api/users/";
    final url = Uri.parse(requestUrl + urlOption + "/goals");
    final token = await authenticate(userName, password);

    Map<String,dynamic> goalJson = goal.toJson();
    goalJson.remove("id");
    http.Response result = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(goalJson),
    );
    if (result.statusCode == HttpStatus.ok) {
      return Goal.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Goal> updateGoal(
      String userId,
      String userName,
      String password,
      Goal goal
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/goals/${goal.id.toString()}");

    Map<String,dynamic> goalJson = goal.toJson();
    goalJson.remove("id");
    http.Response result = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(goalJson),
    );

    if (result.statusCode == HttpStatus.ok) {
      return Goal.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List> getGoals(
      String userId,
      String userName,
      String password
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/goals");

    http.Response result = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (result.statusCode == HttpStatus.ok) {
      var list = json.decode(result.body)["content"] as List;
      return list.map((json) => Goal.fromJson(json)).toList();
    } else {
      throw Exception('Failed request');
    }
  }
  
  Future<List<Exercise>> getExercises(
      String userId,
      String userName,
      String password,
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/exercises");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      var list = json.decode(result.body)["content"] as List;
      return list.map((jsonItem) => Exercise.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Thought> updateThought(
      String userId,
      String userName,
      String password,
      Thought thought
      ) async {
    final requestUrl = "${BASE_URL}api/users/$userId/thoughtRecords/${thought.id}";
    final token = await authenticate(userName, password);

    Map<String,dynamic> thoughtJson = thought.toJson();
    thoughtJson.remove("id");
    //TODO: FIX THIS IN BACKEND
    //thoughtJson.remove("moodsFelt");

    http.Response result = await http.put(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(thoughtJson),
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Thought.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Thought> createThought(
      String userId,
      String userName,
      String password,
      Thought thought
      ) async {
    final token = await authenticate(userName, password);
    final requestUrl = "${BASE_URL}api/users/$userId/thoughtRecords";

    Map<String,dynamic> thoughtJson = thought.toJson();
    thoughtJson.remove("id");

    //TODO: FIX THIS IN BACKEND
    //thoughtJson.remove("moodsFelt");

    http.Response result = await http.post(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(thoughtJson),
    );
    print(json.decode(result.body));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Thought.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List> getThoughts(
      String userId,
      String userName,
      String password
      ) async {
    final url = "${BASE_URL}api/users/$userId/thoughtRecords";
    final token = await authenticate(userName, password);

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    if (result.statusCode == HttpStatus.ok) {
      var list = json.decode(result.body)["content"] as List;
      return list.map((jsonObj) => Thought.fromJson(jsonObj)).toList();
    } else {
      throw Exception('Failed request');
    }
  }

  Future<int> deleteThought(
      String thoughtId,
      String userId,
      String userName,
      String password,

      ) async {
    final requestUrl = "${BASE_URL}api/users/$userId/thoughtRecords/$thoughtId";
    final token = await authenticate(userName, password);
    http.Response result = await http.delete(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Reminder> createReminder(
      String userId,
      String userName,
      String password,
      Reminder reminder
      ) async {

    final requestUrl = "${BASE_URL}api/users/$userId/reminders";
    final token = await authenticate(userName, password);

    Map<String,dynamic> reminderJson = reminder.toJson();
    reminderJson.remove("id");
    http.Response result = await http.post(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(reminderJson),
    );
    if (result.statusCode == HttpStatus.ok) {

      return Reminder.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Reminder> updateReminder(
      String userId,
      String userName,
      String password,
      Reminder reminder
      ) async {

    final requestUrl = "${BASE_URL}api/users/$userId/reminders/${reminder.id}";
    final token = await authenticate(userName, password);

    Map<String,dynamic> reminderJson = reminder.toJson();
    reminderJson.remove("id");
    http.Response result = await http.put(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(reminderJson),
    );
    if (result.statusCode == HttpStatus.ok) {
      return Reminder.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed request');
    }
  }

  Future<Exercise> editAnExercise(String urlOption, String userName,
      String password, String exerciseId, Exercise exercise) async {
    int id = int.parse(urlOption);
    int id2 = int.parse(exerciseId);
    //var exercise=getExercises(urlOption, userName, password);
    final requestUrl =
        "${BASE_URL}api/users/$id/exercises/$id2";

    final token = await authenticate(userName, password);

    http.Response result = await http.put(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'startDate': exercise.startDate,
        'endDate': exercise.endDate,
        'message': exercise.message,
      }),
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<int> deleteExercise(
      String userId,
      String userName,
      String password,
      String exerciseId
      ) async {

    final requestUrl = "${BASE_URL}api/users/$userId/exercises/$exerciseId";
    final token = await authenticate(userName, password);

    http.Response result = await http.delete(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List<Reminder>> getReminders(
      String userId,
      String userName,
      String password
      ) async {

    final url = "${BASE_URL}api/users/$userId/reminders";
    final token = await authenticate(userName, password);

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      var list = json.decode(result.body)["content"] as List;
      return list.map((jsonItem) => Reminder.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed request');
    }
  }


  Future<int> deleteReminder(
      String reminderId,
      String userId,
      String userName,
      String password,
      ) async {

    final requestUrl = "${BASE_URL}api/users/$userId/reminders/$reminderId";
    final token = await authenticate(userName, password);

    http.Response result = await http.delete(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<int> deleteSleepRecord(
      String userId,
      String userName,
      String password,
      String sleepRecordId
      ) async {

    final requestUrl = "${BASE_URL}api/users/$userId/sleeps/$sleepRecordId";
    final token = await authenticate(userName, password);

    http.Response result = await http.delete(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }



  Future<int> deleteGoal(
      String goalId,
      String userId,
      String userName,
      String password,
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/goals/$goalId");

    http.Response result = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<SleepRecord> updateSleepRecord(
      String userId,
      String name,
      String password,
      SleepRecord sleepRecord
      ) async {

    final requestUrl = "${BASE_URL}api/users/$userId/sleeps/${sleepRecord.id}";
    final token = await authenticate(name, password);

    Map<String,dynamic> sleepRecordJson = sleepRecord.toJson();
    sleepRecordJson.remove("id");
    http.Response result = await http.put(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(sleepRecordJson),
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return SleepRecord.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<int> deleteUser(
      String idSend, String userName, String password) async {
    int id = int.parse(idSend);
    final requestUrl =
        "${BASE_URL}api/users/$id";
    final token = await authenticate(userName, password);
    http.Response result = await http.delete(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }

  // MOOD TRACKER ENDPOINTS
  Future<List> getAllMoodTrackersByUserId(
      String userId,
      String userName,
      String password
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/moods");

    http.Response result = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return jsonResponse['content'];
    } else {
      throw Exception('Failed request');
    }
  }

  Future<List<MoodTracker>> getAllMoodTrackersByUserIdAndMoodTrackerDateRange(
      String userId,
      String userName,
      String password,
      String startDate,
      String endDate
      ) async {

    final token = await authenticate(userName, password);
    Map<String,dynamic> parameters = {
      "startDate": startDate,
      "endDate": endDate
    };

    final encodedParameters = Uri(queryParameters: parameters).toString();
    final url = Uri.parse("${BASE_URL}api/users/$userId/moods/moodTrackerDate${encodedParameters}");

    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      var list = json.decode(result.body)["content"] as List;
      return list.map((jsonItem) => MoodTracker.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed request');
    }

  }

  Future<MoodTracker> createMoodTracker(
      String userId,
      String userName,
      String password,
      MoodTracker moodTracker
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/moods");
    http.Response result = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "moodTrackerDate": moodTracker.moodTrackerDate,
        "mood": moodTracker.mood,
        "message": moodTracker.message,
      }),
    );

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return MoodTracker.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<MoodTracker> getMoodTrackerByUserIdAndId(
      String userId,
      String userName,
      String password,
      String moodTrackerId
      )async{
    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/moods/$moodTrackerId");
    http.Response result = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return MoodTracker.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<MoodTracker> updateMoodTracker(
      String userId,
      String userName,
      String password,
      MoodTracker moodTracker
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/moods/${moodTracker.id}");

    Map<String,dynamic> moodTrackerJson = moodTracker.toJson();
    moodTrackerJson.remove("id");
    http.Response result = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(moodTrackerJson),
    );

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      return MoodTracker.fromJson(jsonResponse);
    } else {
      throw Exception('Failed request');
    }
  }

  Future<int> deleteAllMoodTrackersByUserId(
      String userId,
      String userName,
      String password,
      ) async {

    while(true){
      List<dynamic> moodTrackersPage = [];
      moodTrackersPage = await getAllMoodTrackersByUserId(userId, userName, password);
      int items = moodTrackersPage.length;
      if (items == 0){
        break;
      }
      for(int i = 0; i < items; i++){
        await deleteMoodTracker(moodTrackersPage[i]["id"].toString(), userId, userName, password);
      }
    }

    return 0;

  }

  Future<int> deleteMoodTracker(
      String moodTrackerId,
      String userId,
      String userName,
      String password,
      ) async {

    final token = await authenticate(userName, password);
    final url = Uri.parse("${BASE_URL}api/users/$userId/moods/$moodTrackerId");

    http.Response result = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == HttpStatus.ok) {
      return HttpStatus.ok;
    } else {
      throw Exception('Failed request');
    }
  }
}
