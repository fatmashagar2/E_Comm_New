abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class ChangeBottomNavIndexState extends LayoutStates {}

class GetUserDataLoadingState extends LayoutStates {}

class GetUserDataSuccessState extends LayoutStates {}

class FailedToGetUserDataState extends LayoutStates {
  final String error;
  FailedToGetUserDataState({required this.error});
}

class GetBannersSuccessState extends LayoutStates {}

class FailedToGetBannersState extends LayoutStates {}

class GetCategoriesSuccessState extends LayoutStates {}

class FailedToGetCategoriesState extends LayoutStates {}

class GetProductsSuccessState extends LayoutStates {}

class FailedToGetProductsState extends LayoutStates {}

class FilterProductsSuccessState extends LayoutStates {}

class GetFavoritesSuccessState extends LayoutStates {}

class FailedToGetFavoritesState extends LayoutStates {}

class AddOrRemoveItemFromFavoritesSuccessState extends LayoutStates {}
class AddOrRemoveItemFromFavoritesLoadingState extends LayoutStates {}

class FailedToAddOrRemoveItemFromFavoritesState extends LayoutStates {
  final String error;

  FailedToAddOrRemoveItemFromFavoritesState({required this.error});
}

class GetCartsSuccessState extends LayoutStates {}

class FailedToGetCartsState extends LayoutStates {}

class AddOrRemoveFromCartLoadingState extends LayoutStates {}

class AddOrRemoveFromCartSuccessState extends LayoutStates {}

class FailedToAddOrRemoveFromCartState extends LayoutStates {
  final String error;
  FailedToAddOrRemoveFromCartState(this.error);
}

class AddToCartLoadingState extends LayoutStates {}

class AddToCartSuccessState extends LayoutStates {}

class FailedToAddToCartState extends LayoutStates {
  final String error;
  FailedToAddToCartState(this.error);
}

class UpdateTotalPriceState extends LayoutStates {}

class ChangePasswordLoadingState extends LayoutStates {}

class ChangePasswordSuccessState extends LayoutStates {}

class ChangePasswordWithFailureState extends LayoutStates {
  final String error;
  ChangePasswordWithFailureState(this.error);
}

class UpdateUserDataLoadingState extends LayoutStates {}

class UpdateUserDataSuccessState extends LayoutStates {}

class UpdateUserDataWithFailureState extends LayoutStates {
  final String error;
  UpdateUserDataWithFailureState(this.error);
}

// الحالات الجديدة الخاصة بالعربة
class LayoutCartUpdated extends LayoutStates {}  // تم تحديث العربة
