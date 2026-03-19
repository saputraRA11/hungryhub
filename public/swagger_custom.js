const originalFetch = window.fetch;
window.fetch = async (...args) => {
  const response = await originalFetch(...args);

  // If the request was for login or register, extract the token
  if (response.ok && args[0] && typeof args[0] === 'string' && (args[0].includes('/api/v1/auth/login') || args[0].includes('/api/v1/auth/register'))) {
    const clone = response.clone();
    clone.json().then(data => {
      if (data && data.data && data.data.token) {
        const token = data.data.token;
        const swaggerVal = `Token token=${token}`;

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
            setTimeout(setToken, 100);
          }
        };
        setToken();
      }
    }).catch(err => console.error("Could not parse login response for token injection", err));
  }

  return response;
};
