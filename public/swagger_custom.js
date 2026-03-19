const originalFetch = window.fetch;
window.fetch = async (...args) => {
  const response = await originalFetch(...args);

  // Determine the URL (handle both string and Request object)
  const url = typeof args[0] === 'string' ? args[0] : (args[0] && args[0].url);

  console.log("Swagger Interceptor - Fetch called for:", url);

  // If the request was for login or register, extract the token
  if (response.ok && url && (url.includes('/api/v1/auth/login') || url.includes('/api/v1/auth/register'))) {
    console.log("Swagger Interceptor - Authentication request detected!");
    const clone = response.clone();
    clone.json().then(data => {
      console.log("Swagger Interceptor - Response data received");
      if (data && data.data && data.data.token) {
        const token = data.data.token;
        const swaggerVal = `Token token=${token}`;
        console.log("Swagger Interceptor - Token extracted, applying...");

        const setToken = () => {
          if (window.ui) {
            window.ui.authActions.authorize({
              TokenAuth: {
                name: 'TokenAuth',
                schema: {
                  type: 'apiKey',
                  in: 'header',
                  name: 'Authorization',
                  description: ''
                },
                value: swaggerVal
              }
            });
            console.log("Token automatically applied to Swagger UI!");
          } else {
            console.log("Swagger Interceptor - window.ui not ready, retrying...");
            setTimeout(setToken, 100);
          }
        };
        setToken();
      }
    }).catch(err => console.error("Could not parse login response for token injection", err));
  }

  return response;
};

