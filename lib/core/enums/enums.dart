enum Roles {
  user("User"),
  partner("Partner");

  final String value;

  const Roles(this.value);
}

enum BannerTypes {
  partner("Partner"),
  partners("Partners"),
  products("Products");

  final String value;

  const BannerTypes(this.value);
}

enum ServiceDateType {
  immediately("Immediately"),
  nextWeek("Next week"),
  exploring("Exploring options"),
  customDate("Custom Date");

  final String value;

  const ServiceDateType(this.value);
}

enum WishListType {
  partner("Partner"),
  product("Product");

  final String value;

  const WishListType(this.value);
}

enum OfferClaimType {
  percent("Percent"),
  amount("Amount");

  final String value;

  const OfferClaimType(this.value);
}

enum PartnerType {
  self("Self"),
  business("Business");

  final String value;

  const PartnerType(this.value);
}

enum AddressTypes {
  home("Home"),
  office("Office"),
  hotel("Hotel"),
  other("Other");

  final String value;

  const AddressTypes(this.value);
}

enum EligibilityOrderType {
  orderValue("Order Value"),
  orderCategory("Order Category");

  final String value;

  const EligibilityOrderType(this.value);
}

enum WishlistServiceType {
  freshProduce("Fresh Produce"),
  nursery("Nursery"),
  serviceProvider("Service Provider"),
  knowledge("Knowledge");

  final String value;

  const WishlistServiceType(this.value);
}

enum ServiceType {
  freshProduce("Fresh Produce"),
  nursery("Nursery"),
  serviceProvider("Service Provider");

  final String value;

  const ServiceType(this.value);
}

enum AllServiceType {
  all("All"),
  freshProduce("Fresh Produce"),
  nursery("Nursery"),
  serviceProvider("Service Provider");

  final String value;

  const AllServiceType(this.value);
}

enum PartnerRequests {
  accepted("Accepted"),
  pending("Pending"),
  rejected("Rejected");

  final String value;

  const PartnerRequests(this.value);
}

enum Genders {
  male("Male"),
  female("Female"),
  other("Other");

  final String value;

  const Genders(this.value);
}

enum FeedTypes {
  faq("FAQ"),
  article("Article"),
  video("Video"),
  image("Image");

  final String value;

  const FeedTypes(this.value);
}

enum AllOrderTypes {
  all("All", 'All'),
  uPick("U-Pick", 'Pick'),
  readyToPick("Ready To Go", 'Ready to go'),
  delivery("Delivery", 'Delivery');

  final String value;
  final String message;

  const AllOrderTypes(this.value, this.message);
}

enum PaymentModes {
  payNow(id: "Online Payment", value: "Pay Now"),
  payReservation(id: "Pay A Reservation", value: "Pay A Reservation"),
  payAtPickup(id: "Pay at Pickup", value: "Pay at Pickup");

  const PaymentModes({
    required this.id,
    required this.value,
  });

  final String id;
  final String value;
}

enum OrderTypes {
  uPick(id: "U-Pick", value: "U-Pick"),
  readyToPick(id: "Ready To Go", value: "Ready To Go"),
  delivery(id: "Delivery", value: "Delivery");

  const OrderTypes({
    required this.id,
    required this.value,
  });

  final String id;
  final String value;
}

List<String> freshProduceOrderTypes({bool? all}) => [
      if (all == true) "All",
      "U-Pick",
      "Ready To Go",
      "Delivery",
    ];

List<String> nurseryOrderTypes({bool? all}) => [
      if (all == true) "All",
      "U-Pick",
      "Ready To Go",
      "Delivery",
    ];

enum OrderStatuses {
  all("All"),
  processing("Processing"),
  readyToPickup("Ready To Go"),
  canceled("Canceled"),
  onHold("On Hold"),
  completed("Completed");

  final String value;

  const OrderStatuses(this.value);
}

enum EarningStatuses {
  all("All"),
  processing("Pending"),
  canceled("Canceled"),
  completed("Completed");

  final String value;

  const EarningStatuses(this.value);
}

enum KYCDocumentTypes {
  ssn(id: "SSN", value: "SSN"),
  federalTax(id: "Federal Tax", value: "Federal Tax");

  const KYCDocumentTypes({
    required this.id,
    required this.value,
  });

  final String id;
  final String value;
}
