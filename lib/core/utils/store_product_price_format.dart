import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

/// When the store sends a price but no ISO currency code, format as KZT.
const String kDefaultDisplayCurrencyCode = 'KZT';

/// Locale for grouping/symbols when app + device locales have no country.
const String kDefaultPriceFormattingLocale = 'kk_KZ';

/// Locale string for [NumberFormat].
String localeStringForStorePriceFormatting(BuildContext context) {
  final app = Localizations.localeOf(context);
  if (app.countryCode != null && app.countryCode!.isNotEmpty) {
    return app.toString();
  }
  final device = PlatformDispatcher.instance.locale;
  if (device.countryCode != null && device.countryCode!.isNotEmpty) {
    return Locale(app.languageCode, device.countryCode).toString();
  }
  return kDefaultPriceFormattingLocale;
}

/// Store ISO code only when present; otherwise KZT fallback.
String _resolvedCurrencyCode(QProduct product) {
  final c = product.currencyCode?.trim();
  if (c != null && c.isNotEmpty) return c;
  return kDefaultDisplayCurrencyCode;
}

/// Google Play: localized string for the buyer's Play country (best match).
String? _playBillingFormattedPrice(QProduct product) {
  final details = product.storeDetails;
  if (details == null) return null;
  final defaultOffer = details.defaultSubscriptionOfferDetails;
  final fromSub = defaultOffer?.basePlan?.price.formattedPrice.trim();
  if (fromSub != null && fromSub.isNotEmpty) return fromSub;
  final inApp = details.inAppOfferDetails?.price.formattedPrice.trim();
  if (inApp != null && inApp.isNotEmpty) return inApp;
  return null;
}

/// Priority: (1) real store / storefront — Play [formattedPrice], then iOS
/// [QProduct.price] + store [currencyCode] / StoreKit symbol; (2) [prettyPrice]
/// if no numeric price; (3) KZT only when the store omits currency but a
/// numeric [price] exists ([_resolvedCurrencyCode]).
String formatStoreProductPrice(BuildContext context, QProduct product) {
  final play = _playBillingFormattedPrice(product);
  if (play != null) return play;

  final price = product.price;
  final code = _resolvedCurrencyCode(product);
  final localeStr = localeStringForStorePriceFormatting(context);
  final sk = product.skProduct;
  final skSymbol = sk?.priceLocale?.currencySymbol?.trim();

  if (price != null) {
    try {
      if (skSymbol != null && skSymbol.isNotEmpty) {
        return NumberFormat.currency(
          locale: localeStr,
          name: code,
          symbol: skSymbol,
        ).format(price);
      }
      return NumberFormat.simpleCurrency(
        locale: localeStr,
        name: code,
      ).format(price);
    } catch (_) {
      if (skSymbol != null && skSymbol.isNotEmpty) {
        return '$skSymbol$price';
      }
      return '$code ${price.toStringAsFixed(2)}';
    }
  }

  final pretty = product.prettyPrice?.trim();
  if (pretty != null && pretty.isNotEmpty) return pretty;
  return '';
}
