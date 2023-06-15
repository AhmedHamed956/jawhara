// TODO: 5-Update Dynamic Link Setting
/// Ref: https://support.inspireui.com/help-center/articles/3/25/18/firebase-dynamic-link
const firebaseDynamicLinkConfig = {
  "isEnabled": true,
  // Domain is the domain name for your product.
  // Let’s assume here that your product domain is “example.com”.
  // Then you have to mention the domain name as : https://example.page.link.
  "uriPrefix": "https://jawharaonline.page.link",
  //The link your app will open
  "link": "https://jawhara.online/LANG/catalog/product/view/id/PRODUCT_ID.html",
  //----------* Android Setting *----------//
  "androidPackageName": "online.jawhara",
  "androidAppMinimumVersion": 1,
  //----------* iOS Setting *----------//
  "iOSBundleId": "online.jawhara",
  "iOSAppMinimumVersion": "1.0.0",
  "iOSAppStoreId": "1565162947"
};
