class Profile{
final String profileId;
final String phoneNo;
Profile({required this.profileId,required this.phoneNo});
factory Profile.fromJson(Map<String,dynamic> json){
  return Profile(
    profileId: json['Profile ID'],
    phoneNo: json['Phone No']
  );
}

}