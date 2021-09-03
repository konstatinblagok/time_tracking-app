/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */
import Vue from 'vue'
import router from './cart-er-admin/src/router'
import BootstrapVue from 'bootstrap-vue'
import VueCookies from 'vue-cookies'
import store from './cart-er-admin/src/store/store'
require('./bootstrap');

window.Vue = require('vue');
Vue.use(BootstrapVue);

Vue.config.productionTip = false;

Vue.use(VueCookies)



let token = document.head.querySelector('meta[name="csrf-token"]');

if (token) {
    window.axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
} else {
    console.error('CSRF token not found: https://laravel.com/docs/csrf#csrf-x-csrf-token');
}

let bearerToken = sessionStorage.getItem('user_session_key');
if (bearerToken) {
    window.axios.defaults.headers.common['Authorization'] = `Bearer ${bearerToken}`
}


/**
 * The following block of code may be used to automatically register your
 * Vue components. It will recursively scan this directory for the Vue
 * components and automatically register them with their "basename".
 *
 * Eg. ./components/ExampleComponent.vue -> <example-component></example-component>
 */


// const files = require.context('./', true, /\.vue$/i)
// files.keys().map(key => Vue.component(key.split('/').pop().split('.')[0], files(key).default))

Vue.component('admin', require('./cart-er-admin/src/Admin.vue').default);

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

new Vue({
    el: '#admin',
    router,
    store
})