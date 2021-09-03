export default {
    setProductList(state, payload){
        state.arrProductList = payload;
    },
    setDeliveryList(state, payload){
        state.arrShippingDetail = payload;
    },
    setAuthentication(state, payload){
        state.arrProductList = payload;
    },
    setProfileList(state, payload){
        state.arrProfile = payload;
    },
    // To set My Profile
    setUserProfile(state, payload) {
        console.log('payload');
        console.log(payload);
        state.userProfileDetails    = payload.responseData.user;
        state.userSessionKey        = payload.responseData.access_token;
        state.first_name            = payload.responseData.user.name;
        state.user_id               = payload.responseData.user.id;

        // To store user session key in browser session
        sessionStorage.setItem("user_session_key", state.userSessionKey);
        sessionStorage.setItem("first_name", state.first_name);
        sessionStorage.setItem("user_id", state.user_id);
    },

    setErrors(state, paylaod){
        state.errors = paylaod.errors
    },

    setLoginStatus(state, payload) {
        localStorage.setItem('is_logged_in', payload.boolLoggedIn)
    },
}


