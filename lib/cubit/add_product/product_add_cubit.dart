// lib/cubit/product_add/product_add_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_upload_request.dart';
import '../../data/repositories/store_repository.dart';
import 'product_add_state.dart';

class ProductAddCubit extends Cubit<ProductAddState> {
  final StoreRepository _repo;
  ProductAddCubit(this._repo) : super(ProductAddInitial());

  Future<void> addProduct({
    required ProductUploadRequest request,
    required String token,
  }) async {
    emit(ProductAddLoading());
    try {
      await _repo.addProduct(request: request, token: token);
      emit(ProductAddSuccess());
    } catch (e) {
      emit(ProductAddFailure(e.toString()));
    }
  }
}
