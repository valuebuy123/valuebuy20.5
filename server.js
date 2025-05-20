// const express = require('express');
// const axios = require('axios');
// const cors = require('cors');
// const app = express();

// app.use(cors());
// app.use(express.json());

// const CASHFREE_APP_ID = 'TEST1058486122b5c134bb68e319b29b16848501'; // Replace with your Cashfree App ID
// const CASHFREE_SECRET_KEY = 'cfsk_ma_test_beb06233e0c9ab10623597f08db85f40_db6478d2'; // Replace with your Cashfree Secret Key
// const CASHFREE_BASE_URL = 'https://sandbox.cashfree.com/pg'; // Use https://api.cashfree.com/pg for production

// // Endpoint to create a payment session
// app.post('/create-payment-session', async (req, res) => {
//   const { orderId, amount, customerId, customerEmail, customerPhone } = req.body;
//   console.log('Received request:', req.body); // Log incoming request
//   try {
//     const response = await axios.post(
//       `${CASHFREE_BASE_URL}/orders`,
//       {
//         order_id: orderId,
//         order_amount: amount,
//         order_currency: 'INR',
//         customer_details: {
//           customer_id: customerId,
//           customer_email: customerEmail,
//           customer_phone: customerPhone,
//         },
//         order_meta: {
//           return_url: 'https://your-app.com/payment-callback?order_id={order_id}',
//           notify_url: 'https://your-backend.com/webhook',
//         },
//       },
//       {
//         headers: {
//           'x-api-version': '2022-09-01',
//           'x-client-id': CASHFREE_APP_ID,
//           'x-client-secret': CASHFREE_SECRET_KEY,
//           'Content-Type': 'application/json',
//         },
//       }
//     );
//     console.log('Cashfree response:', response.data); // Log Cashfree response
//     res.json({
//       payment_session_id: response.data.payment_session_id,
//       order_id: response.data.order_id,
//     });
//   } catch (error) {
//     console.error('Error creating payment session:', error.response?.data || error.message);
//     res.status(500).json({ error: 'Failed to create payment session', details: error.response?.data || error.message });
//   }
// });

// // Webhook to handle payment status (optional, for server-side verification)
// app.post('/webhook', (req, res) => {
//   console.log('Webhook received:', req.body);
//   // Verify webhook signature and update order status in Supabase
//   res.status(200).send('Webhook received');
// });

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//   console.log(`Server running on port ${PORT}`);
// });





const express = require('express');
const axios = require('axios');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

const CASHFREE_APP_ID = 'TEST1058486122b5c134bb68e319b29b16848501'; // Replace with your Cashfree App ID
const CASHFREE_SECRET_KEY = 'cfsk_ma_test_beb06233e0c9ab10623597f08db85f40_db6478d2'; // Replace with your Cashfree Secret Key
const CASHFREE_BASE_URL = 'https://sandbox.cashfree.com/pg'; // Use https://api.cashfree.com/pg for production

// Endpoint to create a payment session
app.post('/create-payment-session', async (req, res) => {
  const { orderId, amount, customerId, customerEmail, customerPhone } = req.body;
  console.log('Received request:', req.body); // Log incoming request
  try {
    const response = await axios.post(
      `${CASHFREE_BASE_URL}/orders`,
      {
        order_id: orderId,
        order_amount: amount,
        order_currency: 'INR',
        customer_details: {
          customer_id: customerId,
          customer_email: customerEmail,
          customer_phone: customerPhone,
        },
        order_meta: {
          return_url: 'https://your-app.com/payment-callback?order_id={order_id}',
          notify_url: 'https://your-backend.com/webhook',
        },
      },
      {
        headers: {
          'x-api-version': '2022-09-01',
          'x-client-id': CASHFREE_APP_ID,
          'x-client-secret': CASHFREE_SECRET_KEY,
          'Content-Type': 'application/json',
        },
      }
    );
    console.log('Cashfree response:', response.data); // Log Cashfree response
    res.json({
      payment_session_id: response.data.payment_session_id,
      order_id: response.data.order_id,
    });
  } catch (error) {
    console.error('Error creating payment session:', error.response?.data || error.message);
    res.status(500).json({ error: 'Failed to create payment session', details: error.response?.data || error.message });
  }
});

// Webhook to handle payment status (optional, for server-side verification)
app.post('/webhook', (req, res) => {
  console.log('Webhook received:', req.body);
  res.status(200).send('Webhook received');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});