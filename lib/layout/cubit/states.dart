abstract class SocialStates{}

class SocialInitState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUserLoadingState extends SocialStates{}
class SocialGetAllUserSuccessState extends SocialStates{}
class SocialGetAllUserErrorState extends SocialStates{}

class SocialGetAllChatsLoadingState extends SocialStates{}
class SocialGetAllChatsSuccessState extends SocialStates{}
class SocialGetAllChatsErrorState extends SocialStates{}

class SocialGetAllMessagesSuccessState extends SocialStates{}


class SocialGetPostLoadingState extends SocialStates{}
class SocialGetPostSuccessState extends SocialStates{}
class SocialGetPostErrorState extends SocialStates{}

class SocialGetPostLikersLoadingState extends SocialStates{}
class SocialGetPostLikersSuccessState extends SocialStates{}
class SocialGetPostLikersErrirState extends SocialStates{}



class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{}

class SocialGetLikePostSuccessState extends SocialStates{}
class SocialGetLikePostLoadingState extends SocialStates{}

class SocialChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}


class SocialProfileImgPickedSuccessState extends SocialStates{}
class SocialProfileImgPickedErrorState extends SocialStates{}

class SocialCoverImgPickedSuccessState extends SocialStates{}
class SocialCoverImgPickedErrorState extends SocialStates{}

class SocialPostImgPickedSuccessState extends SocialStates{}
class SocialPostImgPickedErrorState extends SocialStates{}
class SocialPostImgDeletedSuccessState extends SocialStates{}
class SocialPostImgDeletedErrorState extends SocialStates{}

class SocialPostImgRemoveSuccessState extends SocialStates{}


class SocialProfileImgUploadLoadingState extends SocialStates{}
class SocialProfileImgUploadSuccessState extends SocialStates{}
class SocialProfileImgUploadErrorState extends SocialStates{}


class SocialCoverImgUploadLoadingState extends SocialStates{}
class SocialCoverImgUploadSuccessState extends SocialStates{}
class SocialCoverImgUploadErrorState extends SocialStates{}


class SocialUserUpdateLoadingState extends SocialStates{}
class SocialUserUpdateErrorState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{}

class SocialEditPostLoadingState extends SocialStates{}
class SocialEditPostSuccessState extends SocialStates{}
class SocialEditPostErrorState extends SocialStates{}


class SocialWriteCommentSuccessState extends SocialStates{}
class SocialWriteCommentLoadingState extends SocialStates{}
class SocialWriteCommentErrorState extends SocialStates{}

class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{}

class SocialGetMessagesSuccessState extends SocialStates{}
class SocialGetMessageErrorState extends SocialStates{}







