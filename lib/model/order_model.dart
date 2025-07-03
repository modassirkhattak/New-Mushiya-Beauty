class OrderResponse {
  final List<OrderModel> orders;
  final Map<String, String>? pagination; // Optional field for pagination links
  final int? totalCount; // Optional field for total orders count

  OrderResponse({required this.orders, this.pagination, this.totalCount});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    try {
      return OrderResponse(
        orders:
            (json['orders'] as List? ?? []).map((orderJson) {
              if (orderJson is Map<String, dynamic>) {
                return OrderModel.fromJson(orderJson);
              } else {
                throw FormatException('Invalid order JSON: $orderJson');
              }
            }).toList(),
        pagination:
            json['pagination'] != null
                ? Map<String, String>.from(json['pagination'] as Map)
                : null,
        totalCount: json['total_count'] as int?,
      );
    } catch (e, stackTrace) {
      print('Error parsing OrderResponse: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toJson()).toList(),
      'pagination': pagination,
      'total_count': totalCount,
    };
  }
}

// Rest of the model classes (Order, ClientDetails, MoneySet, etc.) remain unchanged
// Include them here as provided in the previous response
class OrderModel {
  final int id;
  final String adminGraphqlApiId;
  final int appId;
  final String? browserIp;
  final bool buyerAcceptsMarketing;
  final String? cancelReason;
  final String? cancelledAt;
  final String? cartToken;
  final int? checkoutId;
  final String? checkoutToken;
  final ClientDetails? clientDetails;
  final String? closedAt;
  final String confirmationNumber;
  final bool confirmed;
  final String? contactEmail;
  final String createdAt;
  final String currency;
  final String currentSubtotalPrice;
  final MoneySet currentSubtotalPriceSet;
  final AdditionalFeesSet? currentTotalAdditionalFeesSet;
  final String currentTotalDiscounts;
  final MoneySet currentTotalDiscountsSet;
  final DutiesSet? currentTotalDutiesSet;
  final String currentTotalPrice;
  final MoneySet currentTotalPriceSet;
  final String currentTotalTax;
  final MoneySet currentTotalTaxSet;
  final String? customerLocale;
  final int? deviceId;
  final List<String> discountCodes;
  final String? email;
  final bool estimatedTaxes;
  final String financialStatus;
  final String? fulfillmentStatus;
  final String? landingSite;
  final String? landingSiteRef;
  final int? locationId;
  final int? merchantOfRecordAppId;
  final String name;
  final String? note;
  final List<NoteAttribute> noteAttributes;
  final int number;
  final int orderNumber;
  final String orderStatusUrl;
  final AdditionalFeesSet? originalTotalAdditionalFeesSet;
  final DutiesSet? originalTotalDutiesSet;
  final List<String> paymentGatewayNames;
  final String? phone;
  final String? poNumber;
  final String presentmentCurrency;
  final String processedAt;
  final String? reference;
  final String? referringSite;
  final String? sourceIdentifier;
  final String sourceName;
  final String? sourceUrl;
  final String subtotalPrice;
  final MoneySet subtotalPriceSet;
  final String tags;
  final bool taxExempt;
  final List<TaxLine> taxLines;
  final bool taxesIncluded;
  final bool test;
  final String token;
  final String totalDiscounts;
  final MoneySet totalDiscountsSet;
  final String totalLineItemsPrice;
  final MoneySet totalLineItemsPriceSet;
  final String totalOutstanding;
  final String totalPrice;
  final MoneySet totalPriceSet;
  final MoneySet totalShippingPriceSet;
  final String totalTax;
  final MoneySet totalTaxSet;
  final String totalTipReceived;
  final int totalWeight;
  final String updatedAt;
  final int? userId;
  final Address? billingAddress;
  final Customer? customer;
  final List<DiscountApplication> discountApplications;
  final List<Fulfillment> fulfillments;
  final List<LineItem> lineItems;
  final PaymentTerms? paymentTerms;
  final List<Refund> refunds;
  final Address? shippingAddress;
  final List<ShippingLine> shippingLines;

  OrderModel({
    required this.id,
    required this.adminGraphqlApiId,
    required this.appId,
    this.browserIp,
    required this.buyerAcceptsMarketing,
    this.cancelReason,
    this.cancelledAt,
    this.cartToken,
    this.checkoutId,
    this.checkoutToken,
    this.clientDetails,
    this.closedAt,
    required this.confirmationNumber,
    required this.confirmed,
    this.contactEmail,
    required this.createdAt,
    required this.currency,
    required this.currentSubtotalPrice,
    required this.currentSubtotalPriceSet,
    this.currentTotalAdditionalFeesSet,
    required this.currentTotalDiscounts,
    required this.currentTotalDiscountsSet,
    this.currentTotalDutiesSet,
    required this.currentTotalPrice,
    required this.currentTotalPriceSet,
    required this.currentTotalTax,
    required this.currentTotalTaxSet,
    this.customerLocale,
    this.deviceId,
    required this.discountCodes,
    this.email,
    required this.estimatedTaxes,
    required this.financialStatus,
    this.fulfillmentStatus,
    this.landingSite,
    this.landingSiteRef,
    this.locationId,
    this.merchantOfRecordAppId,
    required this.name,
    this.note,
    required this.noteAttributes,
    required this.number,
    required this.orderNumber,
    required this.orderStatusUrl,
    this.originalTotalAdditionalFeesSet,
    this.originalTotalDutiesSet,
    required this.paymentGatewayNames,
    this.phone,
    this.poNumber,
    required this.presentmentCurrency,
    required this.processedAt,
    this.reference,
    this.referringSite,
    this.sourceIdentifier,
    required this.sourceName,
    this.sourceUrl,
    required this.subtotalPrice,
    required this.subtotalPriceSet,
    required this.tags,
    required this.taxExempt,
    required this.taxLines,
    required this.taxesIncluded,
    required this.test,
    required this.token,
    required this.totalDiscounts,
    required this.totalDiscountsSet,
    required this.totalLineItemsPrice,
    required this.totalLineItemsPriceSet,
    required this.totalOutstanding,
    required this.totalPrice,
    required this.totalPriceSet,
    required this.totalShippingPriceSet,
    required this.totalTax,
    required this.totalTaxSet,
    required this.totalTipReceived,
    required this.totalWeight,
    required this.updatedAt,
    this.userId,
    this.billingAddress,
    this.customer,
    required this.discountApplications,
    required this.fulfillments,
    required this.lineItems,
    this.paymentTerms,
    required this.refunds,
    this.shippingAddress,
    required this.shippingLines,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        id: json['id'] as int,
        adminGraphqlApiId: json['admin_graphql_api_id'] as String? ?? '',
        appId: json['app_id'] as int,
        browserIp: json['browser_ip'] as String?,
        buyerAcceptsMarketing: json['buyer_accepts_marketing'] as bool,
        cancelReason: json['cancel_reason'] as String?,
        cancelledAt: json['cancelled_at'] as String?,
        cartToken: json['cart_token'] as String?,
        checkoutId: json['checkout_id'] as int?,
        checkoutToken: json['checkout_token'] as String?,
        clientDetails:
            json['client_details'] != null
                ? ClientDetails.fromJson(
                  json['client_details'] as Map<String, dynamic>,
                )
                : null,
        closedAt: json['closed_at'] as String?,
        confirmationNumber: json['confirmation_number'] as String? ?? '',
        confirmed: json['confirmed'] as bool,
        contactEmail: json['contact_email'] as String?,
        createdAt: json['created_at'] as String? ?? '',
        currency: json['currency'] as String? ?? '',
        currentSubtotalPrice: json['current_subtotal_price'] as String? ?? '',
        currentSubtotalPriceSet: MoneySet.fromJson(
          json['current_subtotal_price_set'] as Map<String, dynamic>,
        ),
        currentTotalAdditionalFeesSet:
            json['current_total_additional_fees_set'] != null
                ? AdditionalFeesSet.fromJson(
                  json['current_total_additional_fees_set'],
                )
                : null,
        currentTotalDiscounts: json['current_total_discounts'] as String? ?? '',
        currentTotalDiscountsSet: MoneySet.fromJson(
          json['current_total_discounts_set'] as Map<String, dynamic>,
        ),
        currentTotalDutiesSet:
            json['current_total_duties_set'] != null
                ? DutiesSet.fromJson(json['current_total_duties_set'])
                : null,
        currentTotalPrice: json['current_total_price'] as String? ?? '',
        currentTotalPriceSet: MoneySet.fromJson(
          json['current_total_price_set'] as Map<String, dynamic>,
        ),
        currentTotalTax: json['current_total_tax'] as String? ?? '',
        currentTotalTaxSet: MoneySet.fromJson(
          json['current_total_tax_set'] as Map<String, dynamic>,
        ),
        customerLocale: json['customer_locale'] as String?,
        deviceId: json['device_id'] as int?,
        discountCodes:
            (json['discount_codes'] as List<dynamic>?)?.cast<String>() ?? [],
        email: json['email'] as String?,
        estimatedTaxes: json['estimated_taxes'] as bool,
        financialStatus: json['financial_status'] as String? ?? '',
        fulfillmentStatus: json['fulfillment_status'] as String?,
        landingSite: json['landing_site'] as String?,
        landingSiteRef: json['landing_site_ref'] as String?,
        locationId: json['location_id'] as int?,
        merchantOfRecordAppId: json['merchant_of_record_app_id'] as int?,
        name: json['name'] as String? ?? '',
        note: json['note'] as String?,
        noteAttributes:
            (json['note_attributes'] as List<dynamic>? ?? [])
                .map(
                  (note) =>
                      NoteAttribute.fromJson(note as Map<String, dynamic>),
                )
                .toList(),
        number: json['number'] as int,
        orderNumber: json['order_number'] as int,
        orderStatusUrl: json['order_status_url'] as String? ?? '',
        originalTotalAdditionalFeesSet:
            json['original_total_additional_fees_set'] != null
                ? AdditionalFeesSet.fromJson(
                  json['original_total_additional_fees_set'],
                )
                : null,
        originalTotalDutiesSet:
            json['original_total_duties_set'] != null
                ? DutiesSet.fromJson(json['original_total_duties_set'])
                : null,
        paymentGatewayNames:
            (json['payment_gateway_names'] as List<dynamic>?)?.cast<String>() ??
            [],
        phone: json['phone'] as String?,
        poNumber: json['po_number'] as String?,
        presentmentCurrency: json['presentment_currency'] as String? ?? '',
        processedAt: json['processed_at'] as String? ?? '',
        reference: json['reference'] as String?,
        referringSite: json['referring_site'] as String?,
        sourceIdentifier: json['source_identifier'] as String?,
        sourceName: json['source_name'] as String? ?? '',
        sourceUrl: json['source_url'] as String?,
        subtotalPrice: json['subtotal_price'] as String? ?? '',
        subtotalPriceSet: MoneySet.fromJson(
          json['subtotal_price_set'] as Map<String, dynamic>,
        ),
        tags: json['tags'] as String? ?? '',
        taxExempt: json['tax_exempt'] as bool,
        taxLines:
            (json['tax_lines'] as List<dynamic>? ?? [])
                .map((tax) => TaxLine.fromJson(tax as Map<String, dynamic>))
                .toList(),
        taxesIncluded: json['taxes_included'] as bool,
        test: json['test'] as bool,
        token: json['token'] as String? ?? '',
        totalDiscounts: json['total_discounts'] as String? ?? '',
        totalDiscountsSet: MoneySet.fromJson(
          json['total_discounts_set'] as Map<String, dynamic>,
        ),
        totalLineItemsPrice: json['total_line_items_price'] as String? ?? '',
        totalLineItemsPriceSet: MoneySet.fromJson(
          json['total_line_items_price_set'] as Map<String, dynamic>,
        ),
        totalOutstanding: json['total_outstanding'] as String? ?? '',
        totalPrice: json['total_price'] as String? ?? '',
        totalPriceSet: MoneySet.fromJson(
          json['total_price_set'] as Map<String, dynamic>,
        ),
        totalShippingPriceSet: MoneySet.fromJson(
          json['total_shipping_price_set'] as Map<String, dynamic>,
        ),
        totalTax: json['total_tax'] as String? ?? '',
        totalTaxSet: MoneySet.fromJson(
          json['total_tax_set'] as Map<String, dynamic>,
        ),
        totalTipReceived: json['total_tip_received'] as String? ?? '',
        totalWeight: json['total_weight'] as int,
        updatedAt: json['updated_at'] as String? ?? '',
        userId: json['user_id'] as int?,
        billingAddress:
            json['billing_address'] != null
                ? Address.fromJson(
                  json['billing_address'] as Map<String, dynamic>,
                )
                : null,
        customer:
            json['customer'] != null
                ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
                : null,
        discountApplications:
            (json['discount_applications'] as List<dynamic>? ?? [])
                .map(
                  (discount) => DiscountApplication.fromJson(
                    discount as Map<String, dynamic>,
                  ),
                )
                .toList(),
        fulfillments:
            (json['fulfillments'] as List<dynamic>? ?? [])
                .map(
                  (fulfillment) =>
                      Fulfillment.fromJson(fulfillment as Map<String, dynamic>),
                )
                .toList(),
        lineItems:
            (json['line_items'] as List<dynamic>? ?? [])
                .map((item) => LineItem.fromJson(item as Map<String, dynamic>))
                .toList(),
        paymentTerms:
            json['payment_terms'] != null
                ? PaymentTerms.fromJson(
                  json['payment_terms'] as Map<String, dynamic>,
                )
                : null,
        refunds:
            (json['refunds'] as List<dynamic>? ?? [])
                .map(
                  (refund) => Refund.fromJson(refund as Map<String, dynamic>),
                )
                .toList(),
        shippingAddress:
            json['shipping_address'] != null
                ? Address.fromJson(
                  json['shipping_address'] as Map<String, dynamic>,
                )
                : null,
        shippingLines:
            (json['shipping_lines'] as List<dynamic>? ?? [])
                .map(
                  (shipping) =>
                      ShippingLine.fromJson(shipping as Map<String, dynamic>),
                )
                .toList(),
      );
    } catch (e, stackTrace) {
      print('Error parsing Order: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_graphql_api_id': adminGraphqlApiId,
      'app_id': appId,
      'browser_ip': browserIp,
      'buyer_accepts_marketing': buyerAcceptsMarketing,
      'cancel_reason': cancelReason,
      'cancelled_at': cancelledAt,
      'cart_token': cartToken,
      'checkout_id': checkoutId,
      'checkout_token': checkoutToken,
      'client_details': clientDetails?.toJson(),
      'closed_at': closedAt,
      'confirmation_number': confirmationNumber,
      'confirmed': confirmed,
      'contact_email': contactEmail,
      'created_at': createdAt,
      'currency': currency,
      'current_subtotal_price': currentSubtotalPrice,
      'current_subtotal_price_set': currentSubtotalPriceSet.toJson(),
      'current_total_additional_fees_set':
          currentTotalAdditionalFeesSet?.toJson(),
      'current_total_discounts': currentTotalDiscounts,
      'current_total_discounts_set': currentTotalDiscountsSet.toJson(),
      'current_total_duties_set': currentTotalDutiesSet?.toJson(),
      'current_total_price': currentTotalPrice,
      'current_total_price_set': currentTotalPriceSet.toJson(),
      'current_total_tax': currentTotalTax,
      'current_total_tax_set': currentTotalTaxSet.toJson(),
      'customer_locale': customerLocale,
      'device_id': deviceId,
      'discount_codes': discountCodes,
      'email': email,
      'estimated_taxes': estimatedTaxes,
      'financial_status': financialStatus,
      'fulfillment_status': fulfillmentStatus,
      'landing_site': landingSite,
      'landing_site_ref': landingSiteRef,
      'location_id': locationId,
      'merchant_of_record_app_id': merchantOfRecordAppId,
      'name': name,
      'note': note,
      'note_attributes': noteAttributes.map((note) => note.toJson()).toList(),
      'number': number,
      'order_number': orderNumber,
      'order_status_url': orderStatusUrl,
      'original_total_additional_fees_set':
          originalTotalAdditionalFeesSet?.toJson(),
      'original_total_duties_set': originalTotalDutiesSet?.toJson(),
      'payment_gateway_names': paymentGatewayNames,
      'phone': phone,
      'po_number': poNumber,
      'presentment_currency': presentmentCurrency,
      'processed_at': processedAt,
      'reference': reference,
      'referring_site': referringSite,
      'source_identifier': sourceIdentifier,
      'source_name': sourceName,
      'source_url': sourceUrl,
      'subtotal_price': subtotalPrice,
      'subtotal_price_set': subtotalPriceSet.toJson(),
      'tags': tags,
      'tax_exempt': taxExempt,
      'tax_lines': taxLines.map((tax) => tax.toJson()).toList(),
      'taxes_included': taxesIncluded,
      'test': test,
      'token': token,
      'total_discounts': totalDiscounts,
      'total_discounts_set': totalDiscountsSet.toJson(),
      'total_line_items_price': totalLineItemsPrice,
      'total_line_items_price_set': totalLineItemsPriceSet.toJson(),
      'total_outstanding': totalOutstanding,
      'total_price': totalPrice,
      'total_price_set': totalPriceSet.toJson(),
      'total_shipping_price_set': totalShippingPriceSet.toJson(),
      'total_tax': totalTax,
      'total_tax_set': totalTaxSet.toJson(),
      'total_tip_received': totalTipReceived,
      'total_weight': totalWeight,
      'updated_at': updatedAt,
      'user_id': userId,
      'billing_address': billingAddress?.toJson(),
      'customer': customer?.toJson(),
      'discount_applications':
          discountApplications.map((discount) => discount.toJson()).toList(),
      'fulfillments':
          fulfillments.map((fulfillment) => fulfillment.toJson()).toList(),
      'line_items': lineItems.map((item) => item.toJson()).toList(),
      'payment_terms': paymentTerms?.toJson(),
      'refunds': refunds.map((refund) => refund.toJson()).toList(),
      'shipping_address': shippingAddress?.toJson(),
      'shipping_lines':
          shippingLines.map((shipping) => shipping.toJson()).toList(),
    };
  }
}

class ClientDetails {
  final String? acceptLanguage;
  final int? browserHeight;
  final String? browserIp;
  final int? browserWidth;
  final String? sessionHash;
  final String? userAgent;

  ClientDetails({
    this.acceptLanguage,
    this.browserHeight,
    this.browserIp,
    this.browserWidth,
    this.sessionHash,
    this.userAgent,
  });

  factory ClientDetails.fromJson(Map<String, dynamic> json) {
    return ClientDetails(
      acceptLanguage: json['accept_language'] as String?,
      browserHeight: json['browser_height'] as int?,
      browserIp: json['browser_ip'] as String?,
      browserWidth: json['browser_width'] as int?,
      sessionHash: json['session_hash'] as String?,
      userAgent: json['user_agent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accept_language': acceptLanguage,
      'browser_height': browserHeight,
      'browser_ip': browserIp,
      'browser_width': browserWidth,
      'session_hash': sessionHash,
      'user_agent': userAgent,
    };
  }
}

class MoneySet {
  final Money shopMoney;
  final Money presentmentMoney;

  MoneySet({required this.shopMoney, required this.presentmentMoney});

  factory MoneySet.fromJson(Map<String, dynamic> json) {
    return MoneySet(
      shopMoney: Money.fromJson(json['shop_money'] as Map<String, dynamic>),
      presentmentMoney: Money.fromJson(
        json['presentment_money'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_money': shopMoney.toJson(),
      'presentment_money': presentmentMoney.toJson(),
    };
  }
}

class Money {
  final String amount;
  final String currencyCode;

  Money({required this.amount, required this.currencyCode});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amount: json['amount'] as String,
      currencyCode: json['currency_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'currency_code': currencyCode};
  }
}

class AdditionalFeesSet {
  AdditionalFeesSet();

  factory AdditionalFeesSet.fromJson(Map<String, dynamic> json) {
    return AdditionalFeesSet();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class DutiesSet {
  DutiesSet();

  factory DutiesSet.fromJson(Map<String, dynamic> json) {
    return DutiesSet();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class NoteAttribute {
  final String name;
  final String value;

  NoteAttribute({required this.name, required this.value});

  factory NoteAttribute.fromJson(Map<String, dynamic> json) {
    return NoteAttribute(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}

class TaxLine {
  final bool channelLiable;
  final String price;
  final MoneySet priceSet;
  final double rate;
  final String title;

  TaxLine({
    required this.channelLiable,
    required this.price,
    required this.priceSet,
    required this.rate,
    required this.title,
  });

  factory TaxLine.fromJson(Map<String, dynamic> json) {
    return TaxLine(
      channelLiable: json['channel_liable'] as bool,
      price: json['price'] as String,
      priceSet: MoneySet.fromJson(json['price_set'] as Map<String, dynamic>),
      rate: (json['rate'] as num).toDouble(),
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_liable': channelLiable,
      'price': price,
      'price_set': priceSet.toJson(),
      'rate': rate,
      'title': title,
    };
  }
}

class Address {
  final String? firstName;
  final String? address1;
  final String? phone;
  final String? city;
  final String? zip;
  final String? province;
  final String? country;
  final String? lastName;
  final String? address2;
  final String? company;
  final double? latitude;
  final double? longitude;
  final String? name;
  final String? countryCode;
  final String? provinceCode;

  Address({
    this.firstName,
    this.address1,
    this.phone,
    this.city,
    this.zip,
    this.province,
    this.country,
    this.lastName,
    this.address2,
    this.company,
    this.latitude,
    this.longitude,
    this.name,
    this.countryCode,
    this.provinceCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: json['first_name'] as String?,
      address1: json['address1'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      zip: json['zip'] as String?,
      province: json['province'] as String?,
      country: json['country'] as String?,
      lastName: json['last_name'] as String?,
      address2: json['address2'] as String?,
      company: json['company'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      name: json['name'] as String?,
      countryCode: json['country_code'] as String?,
      provinceCode: json['province_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'address1': address1,
      'phone': phone,
      'city': city,
      'zip': zip,
      'province': province,
      'country': country,
      'last_name': lastName,
      'address2': address2,
      'company': company,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'country_code': countryCode,
      'province_code': provinceCode,
    };
  }
}

class Customer {
  final int id;
  final String? email;
  final String createdAt;
  final String updatedAt;
  final String? firstName;
  final String? lastName;
  final String state;
  final String? note;
  final bool verifiedEmail;
  final String? multipassIdentifier;
  final bool taxExempt;
  final String? phone;
  final MarketingConsent? emailMarketingConsent;
  final MarketingConsent? smsMarketingConsent;
  final String tags;
  final String currency;
  final List<String> taxExemptions;
  final String adminGraphqlApiId;
  final Address? defaultAddress;

  Customer({
    required this.id,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    this.firstName,
    this.lastName,
    required this.state,
    this.note,
    required this.verifiedEmail,
    this.multipassIdentifier,
    required this.taxExempt,
    this.phone,
    this.emailMarketingConsent,
    this.smsMarketingConsent,
    required this.tags,
    required this.currency,
    required this.taxExemptions,
    required this.adminGraphqlApiId,
    this.defaultAddress,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      email: json['email'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      state: json['state'] as String,
      note: json['note'] as String?,
      verifiedEmail: json['verified_email'] as bool,
      multipassIdentifier: json['multipass_identifier'] as String?,
      taxExempt: json['tax_exempt'] as bool,
      phone: json['phone'] as String?,
      emailMarketingConsent:
          json['email_marketing_consent'] != null
              ? MarketingConsent.fromJson(
                json['email_marketing_consent'] as Map<String, dynamic>,
              )
              : null,
      smsMarketingConsent:
          json['sms_marketing_consent'] != null
              ? MarketingConsent.fromJson(
                json['sms_marketing_consent'] as Map<String, dynamic>,
              )
              : null,
      tags: json['tags'] as String,
      currency: json['currency'] as String,
      taxExemptions:
          (json['tax_exemptions'] as List<dynamic>?)?.cast<String>() ?? [],
      adminGraphqlApiId: json['admin_graphql_api_id'] as String,
      defaultAddress:
          json['default_address'] != null
              ? Address.fromJson(
                json['default_address'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'first_name': firstName,
      'last_name': lastName,
      'state': state,
      'note': note,
      'verified_email': verifiedEmail,
      'multipass_identifier': multipassIdentifier,
      'tax_exempt': taxExempt,
      'phone': phone,
      'email_marketing_consent': emailMarketingConsent?.toJson(),
      'sms_marketing_consent': smsMarketingConsent?.toJson(),
      'tags': tags,
      'currency': currency,
      'tax_exemptions': taxExemptions,
      'admin_graphql_api_id': adminGraphqlApiId,
      'default_address': defaultAddress?.toJson(),
    };
  }
}

class MarketingConsent {
  final String state;
  final String optInLevel;
  final String? consentUpdatedAt;

  MarketingConsent({
    required this.state,
    required this.optInLevel,
    this.consentUpdatedAt,
  });

  factory MarketingConsent.fromJson(Map<String, dynamic> json) {
    return MarketingConsent(
      state: json['state'] as String? ?? '',
      optInLevel: json['opt_in_level'] as String? ?? '',
      consentUpdatedAt: json['consent_updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'opt_in_level': optInLevel,
      'consent_updated_at': consentUpdatedAt,
    };
  }
}

class DiscountApplication {
  DiscountApplication();

  factory DiscountApplication.fromJson(Map<String, dynamic> json) {
    return DiscountApplication();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class Fulfillment {
  final int id;
  final String adminGraphqlApiId;
  final String createdAt;
  final int locationId;
  final String name;
  final int orderId;
  final Map<String, dynamic> originAddress;
  final Map<String, dynamic> receipt;
  final String service;
  final String? shipmentStatus;
  final String status;
  final String? trackingCompany;
  final String? trackingNumber;
  final List<String> trackingNumbers;
  final String? trackingUrl;
  final List<String> trackingUrls;
  final String updatedAt;
  final List<LineItem> lineItems;

  Fulfillment({
    required this.id,
    required this.adminGraphqlApiId,
    required this.createdAt,
    required this.locationId,
    required this.name,
    required this.orderId,
    required this.originAddress,
    required this.receipt,
    required this.service,
    this.shipmentStatus,
    required this.status,
    this.trackingCompany,
    this.trackingNumber,
    required this.trackingNumbers,
    this.trackingUrl,
    required this.trackingUrls,
    required this.updatedAt,
    required this.lineItems,
  });

  factory Fulfillment.fromJson(Map<String, dynamic> json) {
    return Fulfillment(
      id: json['id'] as int,
      adminGraphqlApiId: json['admin_graphql_api_id'] as String,
      createdAt: json['created_at'] as String,
      locationId: json['location_id'] as int,
      name: json['name'] as String,
      orderId: json['order_id'] as int,
      originAddress: json['origin_address'] as Map<String, dynamic>,
      receipt: json['receipt'] as Map<String, dynamic>,
      service: json['service'] as String,
      shipmentStatus: json['shipment_status'] as String?,
      status: json['status'] as String,
      trackingCompany: json['tracking_company'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      trackingNumbers:
          (json['tracking_numbers'] as List<dynamic>?)?.cast<String>() ?? [],
      trackingUrl: json['tracking_url'] as String?,
      trackingUrls:
          (json['tracking_urls'] as List<dynamic>?)?.cast<String>() ?? [],
      updatedAt: json['updated_at'] as String,
      lineItems:
          (json['line_items'] as List<dynamic>? ?? [])
              .map((item) => LineItem.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_graphql_api_id': adminGraphqlApiId,
      'created_at': createdAt,
      'location_id': locationId,
      'name': name,
      'order_id': orderId,
      'origin_address': originAddress,
      'receipt': receipt,
      'service': service,
      'shipment_status': shipmentStatus,
      'status': status,
      'tracking_company': trackingCompany,
      'tracking_number': trackingNumber,
      'tracking_numbers': trackingNumbers,
      'tracking_url': trackingUrl,
      'tracking_urls': trackingUrls,
      'updated_at': updatedAt,
      'line_items': lineItems.map((item) => item.toJson()).toList(),
    };
  }
}

class LineItem {
  final int id;
  final String adminGraphqlApiId;
  final List<AttributedStaff> attributedStaffs;
  final int currentQuantity;
  final int fulfillableQuantity;
  final String fulfillmentService;
  final String? fulfillmentStatus;
  final bool giftCard;
  final int grams;
  final String name;
  final String preTaxPrice;
  final MoneySet preTaxPriceSet;
  final String price;
  final MoneySet priceSet;
  final bool productExists;
  final int? productId;
  final List<Property> properties;
  final int quantity;
  final bool requiresShipping;
  final String? sku;
  final bool taxable;
  final String title;
  final String totalDiscount;
  final MoneySet totalDiscountSet;
  final int? variantId;
  final String? variantInventoryManagement;
  final String? variantTitle;
  final String? vendor;
  final List<TaxLine> taxLines;
  final List<dynamic> duties;
  final List<DiscountAllocation> discountAllocations;

  LineItem({
    required this.id,
    required this.adminGraphqlApiId,
    required this.attributedStaffs,
    required this.currentQuantity,
    required this.fulfillableQuantity,
    required this.fulfillmentService,
    this.fulfillmentStatus,
    required this.giftCard,
    required this.grams,
    required this.name,
    required this.preTaxPrice,
    required this.preTaxPriceSet,
    required this.price,
    required this.priceSet,
    required this.productExists,
    this.productId,
    required this.properties,
    required this.quantity,
    required this.requiresShipping,
    this.sku,
    required this.taxable,
    required this.title,
    required this.totalDiscount,
    required this.totalDiscountSet,
    this.variantId,
    this.variantInventoryManagement,
    this.variantTitle,
    this.vendor,
    required this.taxLines,
    required this.duties,
    required this.discountAllocations,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'] as int,
      adminGraphqlApiId: json['admin_graphql_api_id'] as String,
      attributedStaffs:
          (json['attributed_staffs'] as List<dynamic>? ?? [])
              .map(
                (staff) =>
                    AttributedStaff.fromJson(staff as Map<String, dynamic>),
              )
              .toList(),
      currentQuantity: json['current_quantity'] as int,
      fulfillableQuantity: json['fulfillable_quantity'] as int,
      fulfillmentService: json['fulfillment_service'] as String,
      fulfillmentStatus: json['fulfillment_status'] as String?,
      giftCard: json['gift_card'] as bool,
      grams: json['grams'] as int,
      name: json['name'] as String,
      preTaxPrice: json['pre_tax_price'] as String,
      preTaxPriceSet: MoneySet.fromJson(
        json['pre_tax_price_set'] as Map<String, dynamic>,
      ),
      price: json['price'] as String,
      priceSet: MoneySet.fromJson(json['price_set'] as Map<String, dynamic>),
      productExists: json['product_exists'] as bool,
      productId: json['product_id'] as int?,
      properties:
          (json['properties'] as List<dynamic>? ?? [])
              .map((prop) => Property.fromJson(prop as Map<String, dynamic>))
              .toList(),
      quantity: json['quantity'] as int,
      requiresShipping: json['requires_shipping'] as bool,
      sku: json['sku'] as String?,
      taxable: json['taxable'] as bool,
      title: json['title'] as String,
      totalDiscount: json['total_discount'] as String,
      totalDiscountSet: MoneySet.fromJson(
        json['total_discount_set'] as Map<String, dynamic>,
      ),
      variantId: json['variant_id'] as int?,
      variantInventoryManagement:
          json['variant_inventory_management'] as String?,
      variantTitle: json['variant_title'] as String?,
      vendor: json['vendor'] as String?,
      taxLines:
          (json['tax_lines'] as List<dynamic>? ?? [])
              .map((tax) => TaxLine.fromJson(tax as Map<String, dynamic>))
              .toList(),
      duties: json['duties'] as List<dynamic>? ?? [],
      discountAllocations:
          (json['discount_allocations'] as List<dynamic>? ?? [])
              .map(
                (discount) => DiscountAllocation.fromJson(
                  discount as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_graphql_api_id': adminGraphqlApiId,
      'attributed_staffs':
          attributedStaffs.map((staff) => staff.toJson()).toList(),
      'current_quantity': currentQuantity,
      'fulfillable_quantity': fulfillableQuantity,
      'fulfillment_service': fulfillmentService,
      'fulfillment_status': fulfillmentStatus,
      'gift_card': giftCard,
      'grams': grams,
      'name': name,
      'pre_tax_price': preTaxPrice,
      'pre_tax_price_set': preTaxPriceSet.toJson(),
      'price': price,
      'price_set': priceSet.toJson(),
      'product_exists': productExists,
      'product_id': productId,
      'properties': properties.map((prop) => prop.toJson()).toList(),
      'quantity': quantity,
      'requires_shipping': requiresShipping,
      'sku': sku,
      'taxable': taxable,
      'title': title,
      'total_discount': totalDiscount,
      'total_discount_set': totalDiscountSet.toJson(),
      'variant_id': variantId,
      'variant_inventory_management': variantInventoryManagement,
      'variant_title': variantTitle,
      'vendor': vendor,
      'tax_lines': taxLines.map((tax) => tax.toJson()).toList(),
      'duties': duties,
      'discount_allocations':
          discountAllocations.map((discount) => discount.toJson()).toList(),
    };
  }
}

class AttributedStaff {
  AttributedStaff();

  factory AttributedStaff.fromJson(Map<String, dynamic> json) {
    return AttributedStaff();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class Property {
  final String name;
  final String value;

  Property({required this.name, required this.value});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}

class DiscountAllocation {
  DiscountAllocation();

  factory DiscountAllocation.fromJson(Map<String, dynamic> json) {
    return DiscountAllocation();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class PaymentTerms {
  PaymentTerms();

  factory PaymentTerms.fromJson(Map<String, dynamic> json) {
    return PaymentTerms();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class Refund {
  Refund();

  factory Refund.fromJson(Map<String, dynamic> json) {
    return Refund();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class ShippingLine {
  final int id;
  final String? carrierIdentifier;
  final String code;
  final String discountedPrice;
  final MoneySet discountedPriceSet;
  final bool isRemoved;
  final String? phone;
  final String price;
  final MoneySet priceSet;
  final String? requestedFulfillmentServiceId;
  final String source;
  final String title;
  final List<TaxLine> taxLines;
  final List<DiscountAllocation> discountAllocations;

  ShippingLine({
    required this.id,
    this.carrierIdentifier,
    required this.code,
    required this.discountedPrice,
    required this.discountedPriceSet,
    required this.isRemoved,
    this.phone,
    required this.price,
    required this.priceSet,
    this.requestedFulfillmentServiceId,
    required this.source,
    required this.title,
    required this.taxLines,
    required this.discountAllocations,
  });

  factory ShippingLine.fromJson(Map<String, dynamic> json) {
    return ShippingLine(
      id: json['id'] as int,
      carrierIdentifier: json['carrier_identifier'] as String?,
      code: json['code'] as String,
      discountedPrice: json['discounted_price'] as String,
      discountedPriceSet: MoneySet.fromJson(
        json['discounted_price_set'] as Map<String, dynamic>,
      ),
      isRemoved: json['is_removed'] as bool,
      phone: json['phone'] as String?,
      price: json['price'] as String,
      priceSet: MoneySet.fromJson(json['price_set'] as Map<String, dynamic>),
      requestedFulfillmentServiceId:
          json['requested_fulfillment_service_id'] as String?,
      source: json['source'] as String,
      title: json['title'] as String,
      taxLines:
          (json['tax_lines'] as List<dynamic>? ?? [])
              .map((tax) => TaxLine.fromJson(tax as Map<String, dynamic>))
              .toList(),
      discountAllocations:
          (json['discount_allocations'] as List<dynamic>? ?? [])
              .map(
                (discount) => DiscountAllocation.fromJson(
                  discount as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carrier_identifier': carrierIdentifier,
      'code': code,
      'discounted_price': discountedPrice,
      'discounted_price_set': discountedPriceSet.toJson(),
      'is_removed': isRemoved,
      'phone': phone,
      'price': price,
      'price_set': priceSet.toJson(),
      'requested_fulfillment_service_id': requestedFulfillmentServiceId,
      'source': source,
      'title': title,
      'tax_lines': taxLines.map((tax) => tax.toJson()).toList(),
      'discount_allocations':
          discountAllocations.map((discount) => discount.toJson()).toList(),
    };
  }
}
