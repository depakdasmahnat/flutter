enum UserRoles {
  guest('Guest'),
  member('Member');

  final String value;

  const UserRoles(this.value);
}

enum LeadsStatus {
  newLead('New'),
  invitationCall('Invitation Call'),
  demoScheduled('Demo Scheduled'),
  followUp('Follow Up'),
  closed('Closed');

  final String value;

  const LeadsStatus(this.value);
}

enum GoalStatus {
  pending('Pending'),
  achieved('Achieved');

  final String value;

  const GoalStatus(this.value);
}

enum LeadPriorityFilters {
  hot('Hot'),
  warm('Warm'),
  cold('Cold');

  final String value;

  const LeadPriorityFilters(this.value);
}

enum Roles {
  admin('Admin'),
  premium('Premium'),
  user('User');

  final String value;

  const Roles(this.value);
}

enum ChapterStatus {
  open('Open'),
  locked('Locked'),
  complete('Complete');

  final String value;

  const ChapterStatus(this.value);
}

enum FeedsFileType {
  article('Article'),
  video('Video'),
  videos('Videos'),
  youtubeVideo('YoutubeVideo'),
  pdf('Pdf'),
  ppt('Ppt'),
  image('Image');

  final String value;

  const FeedsFileType(this.value);
}

enum Genders {
  male('Male'),
  female('Female'),
  other('Other');

  final String value;

  const Genders(this.value);
}

enum OrderStatuses {
  all('All'),
  placed('Order Placed'),
  processing('Processing'),
  confirmed('Order Confirmed'),
  completed('Completed');

  final String value;

  const OrderStatuses(this.value);
}
