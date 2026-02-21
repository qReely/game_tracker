import 'package:equatable/equatable.dart';

abstract class GamesByCompanyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGamesByCompany extends GamesByCompanyEvent {
  final String companySlug;
  final bool isPublisher;
  final bool isRefresh;

  FetchGamesByCompany({
    required this.companySlug,
    required this.isPublisher,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [companySlug, isPublisher, isRefresh];
}

class LoadMoreGamesByCompany extends GamesByCompanyEvent {
  final String companySlug;
  final bool isPublisher;

  LoadMoreGamesByCompany({
    required this.companySlug,
    required this.isPublisher,
  });

  @override
  List<Object?> get props => [companySlug, isPublisher];
}

class RefreshGamesByCompany extends GamesByCompanyEvent {}
