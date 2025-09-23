import 'package:auto_injector/auto_injector.dart';
import 'package:currency_tracker/core/theme/theme_controller.dart';
import 'package:currency_tracker/presentation/viewmodels/currency_list_viewmodel.dart';
import 'package:currency_tracker/presentation/viewmodels/currency_converter_viewmodel.dart';
import 'package:currency_tracker/presentation/commands/currency_commands.dart';
import 'package:currency_tracker/data/database/i_database_service.dart';
import 'package:currency_tracker/data/database/sql_database_service_impl.dart';
import 'package:currency_tracker/data/remote/currency_remote_data_source_impl.dart';
import 'package:currency_tracker/data/remote/i_currency_remote_service.dart';
import 'package:currency_tracker/data/repositories/currency_repository_impl.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/facades/currency_use_case_facade_impl.dart';
import 'package:currency_tracker/domain/facades/i_currency_use_case_facade.dart';
import 'package:currency_tracker/domain/usecases/add_currency_usecase_impl.dart';
import 'package:currency_tracker/domain/usecases/get_all_currencies_usecase_impl.dart';
import 'package:currency_tracker/domain/usecases/get_currency_usecase_impl.dart';
import 'package:currency_tracker/domain/usecases/get_favorities_usecase_impl.dart';
import 'package:currency_tracker/domain/usecases/get_historical_quotes_usecase_impl.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';
import 'package:currency_tracker/domain/usecases/remove_currency_usecase_impl.dart';
import 'package:currency_tracker/domain/usecases/update_currency_usecase_impl.dart';
import 'package:currency_tracker/presentation/viewmodels/home_viewmodel.dart';

final injector = AutoInjector();
void setupDependencyInjection() {
  injector.addSingleton<ThemeController>(ThemeController.new);
  injector.addSingleton<IDatabaseService>(SqlDatabaseServiceImpl.new);
  injector
      .addSingleton<ICurrencyRemoteService>(CurrencyRemoteDataSourceImpl.new);
  injector.addSingleton<ICurrencyRepository>(CurrencyRepositoryImpl.new);

  injector.addSingleton<IAddCurrencyUseCase>(AddCurrencyUsecase.new);
  injector.addSingleton<IGetAllCurrenciesUseCase>(GetAllCurrenciesUsecase.new);
  injector.addSingleton<IUpdateCurrencyUseCase>(UpdateCurrencyUsecase.new);
  injector.addSingleton<IRemoveCurrencyUseCase>(RemoveCurrencyUsecase.new);
  injector.addSingleton<IGetCurrencyUseCase>(GetCurrencyUsecase.new);
  injector.addSingleton<IGetFavoriteCurrenciesUseCase>(
      GetFavoriteCurrenciesUsecase.new);
  injector.addSingleton<IGetHistoricalQuotesUseCase>(
      GetHistoricalQuotesUsecase.new);

  injector.addSingleton<ICurrencyUseCaseFacade>(CurrencyUseCaseFacadeImpl.new);

  // ViewModels
  injector.addSingleton<HomeViewController>(HomeViewController.new);
  injector.addSingleton<CurrencyListController>(CurrencyListController.new);
  injector.addSingleton<CurrencyConverterController>(CurrencyConverterController.new);


  // Commands
  //injector.add(GetHistoricalQuotesCommand.new);

  injector.commit();
}
