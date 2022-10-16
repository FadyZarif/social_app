abstract class SearchStates  {}

class SearchInitialState extends SearchStates{}


class LoginChangeVisibilityState extends SearchStates{}


class SearchLoadingState extends SearchStates{}

class SearchSuccessState extends SearchStates{

}
class SearchErrorState extends SearchStates{}


class SocialGetPostLikersLoadingState extends SearchStates{}
class SocialGetPostLikersSuccessState extends SearchStates{}
class SocialGetPostLikersErrirState extends SearchStates{}

