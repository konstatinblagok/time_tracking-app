import axios from 'axios'
export default {

    getProfileList({commit}) {
        axios.get('/api/admin/profiles')
            .then(response => {
            if(response.status == 200){
            commit('setProfileList', response.data)
        }
    }).catch(error => {
            console.log(error)
        })
    },

    getProfile({commit}) {
        axios.get('/api/admin/profile')
            .then(response => {
                if(response.status == 200){
                    commit('setProfileList', response.data)
                }
            }).catch(error => {
            console.log(error)
        })
    },

    getDeliveryList({commit}) {
        axios.get('/api/admin/delivery')
            .then(response => {
            if(response.status == 200){
            commit('setDeliveryList', response.data)
        }
    }).catch(error => {
            console.log(error)
        })
    },

    //To authenticate user Details
    getAuthenticateUserLogin(context, payload) {
        payload.form.post('/api/admin/login')
            .then((response) => {
                if(200 === response.data.status){
                    context.commit('setErrors', {errors:  false});
                    context.commit('setUserProfile', {responseData: response.data});
                    context.commit('setLoginStatus', {boolLoggedIn: true})
                    context.commit('showLoading', {boolShowLoading: false});
                    payload.router.push('/profiles')
                }
                else {
                    context.commit('setErrors', {errors:  [response.data.error.message]});
                }
            }, (err) => {
                context.dispatch('showErrors', response);
            });
    }



}


