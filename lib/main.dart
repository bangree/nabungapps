import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/categoryCubit.dart';
import 'package:nabung/cubit/settingCubit.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/userCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/SplashPage.dart';
import 'package:nabung/repository/authenticationRepository.dart';
import 'package:nabung/repository/categoryRepository.dart';
import 'package:nabung/repository/transactionRepository.dart';
import 'package:nabung/repository/userRepository.dart';
import 'package:nabung/repository/walletRepository.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthenticationRepository authenticationRepository;
  late WalletRepository walletRepository;
  late TransactionRepository transactionRepository;
  late UserRepository userRepository;
  late CategoryRepository categoryRepository;

  @override
  void initState() {
    authenticationRepository = AuthenticationRepository();
    walletRepository = WalletRepository();
    transactionRepository = TransactionRepository();
    userRepository = UserRepository();
    categoryRepository = CategoryRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => authenticationRepository,
        ),
        RepositoryProvider(
          create: (context) => walletRepository,
        ),
        RepositoryProvider(
          create: (context) => transactionRepository,
        ),
        RepositoryProvider(
          create: (context) => userRepository,
        ),
        RepositoryProvider(
          create: (context) => categoryRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationDataCubit(
              authenticationRepository: authenticationRepository,
            )..init(),
          ),
          BlocProvider(
            create: (context) => WalletCubit(
              walletRepository: walletRepository,
            ),
          ),
          BlocProvider(
            create: (context) => TransactionCubit(
              transactionRepository: transactionRepository,
            ),
          ),
          BlocProvider(
            create: (context) => CategoryCubit(
              categoryRepository: categoryRepository,
            ),
          ),
          BlocProvider(
            create: (context) => UserCubit(
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => SettingCubit(),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              fontFamily: 'Montserrat',
              scaffoldBackgroundColor: customBackground.withOpacity(1),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            home: const SplashPage(),
          );
        }),
      ),
    );
  }
}
