const String ADMIN_TOKEN = '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';
const String STORE_TOKEN = '7b7ff363f445082993d4a173de185fed';
const String BASE_URL = 'https://runwaycurls.myshopify.com/admin/api/2025-01/';
// const String BASE_URL = 'https://runwaycurls.myshopify.com/admin/api/2023-10/';
const String GRAPHQL_URL =
    'https://runwaycurls.myshopify.com/admin/api/2024-04/graphql.json';
const String REGISTER_USER = 'customers.json';
const String LOGIN_USER = 'customers.json';
const String BLOGS_ALL = 'blogs.json';
const String PRODUCTS_URL = 'products.json';
const String PRIVACY_POLICY = 'policies.json';
const String ARTICLES_URL = 'articles.json';
const String CART_URL = 'https://runwaycurls.myshopify.com/cart/add.js';
const String ORDER_URL = 'orders.json';
const String COLLECTIONS_URL = 'custom_collections.json';

// policy page
const String RETURN_POLICY = 'return-policy';
const String REFUND_POLICY = 'return-policy';
const String PARTNER_POLICY = 'return-policy';
const String SHIPPING_POLICY = 'shipping-policy';
const String PRIVACY_POLICY_URL = 'privacy-policy';
const String BEST_SELLER = "gid://shopify/Collection/87225499707";


// const String COSTOMER_PROFILE_URL = 'https://runwaycurls.myshopify.com/admin/api/2025-01/';
// const String COLLECTIONS_SUB_PRODUCTS_URL = 'custom_collections.json';

final headerApi = {
  'X-Shopify-Access-Token': ADMIN_TOKEN,
  'Content-Type': 'application/json',
};

final headerStoreApi = {
  'X-Shopify-Storefront-Access-Token': STORE_TOKEN,
  'Content-Type': 'application/json',
};
