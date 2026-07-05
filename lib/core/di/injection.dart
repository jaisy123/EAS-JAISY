import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


// Import komponen internal fitur News
import '../../features/news/data/datasources/news_local_data_source.dart';
import '../../features/news/data/datasources/news_remote_data_source.dart';
import '../../features/news/data/models/news_model.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/news_usecases.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';

// Instance global untuk memanggil kelas di mana saja
final locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Eksternal: Setup Database Lokal Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NewsModelSchema], // Skema generator hasil build_runner tadi
    directory: dir.path,
  );
  locator.registerSingleton<Isar>(isar);

  // 2. Eksternal: Setup HTTP Client untuk menembak API Internet
  locator.registerLazySingleton<http.Client>(() => http.Client());

  // 3. Data Sources (Local & Remote)
  locator.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(isar: locator<Isar>()),
  );
  locator.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: locator<http.Client>()),
  );

  // 4. Repository (Menghubungkan Domain Interface dengan Data Impl)
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      localDataSource: locator<NewsLocalDataSource>(),
      remoteDataSource: locator<NewsRemoteDataSource>(),
    ),
  );

  // 5. Use Cases
  locator.registerLazySingleton<NewsUseCases>(
    () => NewsUseCases(repository: locator<NewsRepository>()),
  );

  // 6. State Management (BLoC) - Gunakan Factory agar state segar setiap dipanggil
  locator.registerFactory<NewsBloc>(
    () => NewsBloc(useCases: locator<NewsUseCases>()),
  );
}