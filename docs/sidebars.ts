import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  docsSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Getting Started',
      collapsed: false,
      items: [
        'getting-started/installation',
        'getting-started/setup-ios',
        'getting-started/setup-android',
        'getting-started/quickstart',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      items: [
        'guides/products',
        'guides/subscriptions',
        'guides/purchases',
        'guides/receipt-validation',
        'guides/error-handling',
        'guides/testing',
      ],
    },
    {
      type: 'category',
      label: 'Examples',
      items: [
        'examples/basic-store',
        'examples/subscription-store',
        'examples/complete-implementation',
      ],
    },
    {
      type: 'category',
      label: 'Migration',
      items: [
        'migration/from-v5',
        'migration/from-expo-iap',
      ],
    },
    'troubleshooting',
    'faq',
  ],
  
  apiSidebar: [
    'api/overview',
    {
      type: 'category',
      label: 'Classes',
      items: [
        'api/classes/flutter-inapp-purchase',
        'api/classes/iap-item',
        'api/classes/purchase-item',
      ],
    },
    {
      type: 'category',
      label: 'Methods',
      items: [
        'api/methods/init-connection',
        'api/methods/get-products',
        'api/methods/get-subscriptions',
        'api/methods/request-purchase',
        'api/methods/request-subscription',
        'api/methods/finish-transaction',
        'api/methods/get-available-purchases',
        'api/methods/validate-receipt',
      ],
    },
    {
      type: 'category',
      label: 'Types',
      items: [
        'api/types/product-type',
        'api/types/purchase-state',
        'api/types/error-codes',
      ],
    },
  ],
};

export default sidebars;