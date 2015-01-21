## Configuration for the PxPay gem for Payment Express

# Your Pxpay UserID and Key
#Pxpay::Base.pxpay_user_id = 'Samplepxpayuser'
#Pxpay::Base.pxpay_key = 'cff9bd6b6c7614bec6872182e5f1f5bcc531f1afb744f0bcaa00e82ad3b37f6d'
Pxpay::Base.pxpay_request_url = 'https://sec.paymentexpress.com/pxaccess/pxpay.aspx'

# Return Endpoints for payment confirmation
# Uncomment for global success & failure URLs
# Pxpay::Base.url_success = 'http://localhost:3000/success'
# Pxpay::Base.url_failure = 'http://localhost:3000/failure'

# Coming Soon Global Variables