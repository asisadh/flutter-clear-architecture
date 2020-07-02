import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:learning/core/network/network_info.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:learning/features/number_trivia/data/repository/number_trivia_repository_impl.dart';

import 'package:learning/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_concerete_number_trivia.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:learning/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:learning/utils/input_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //!- Features Number Trivia
  //* Bloc
  sl.registerFactory(() =>
      NumberTriviaBloc(random: sl(), concrete: sl(), inputConverter: sl()));

  //* Register Usecases
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));

  //* Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //*Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  // network info
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: sl()));

  //! External
  //dataConnectionChecker
  sl.registerLazySingleton(() => DataConnectionChecker());

  // input converter
  sl.registerLazySingleton(() => InputConverter());

  // shared preference
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // http client
  sl.registerLazySingleton(() => http.Client());
}
