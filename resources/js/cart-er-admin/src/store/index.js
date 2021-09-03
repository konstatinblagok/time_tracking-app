require('../../../bootstrap');
import Vuex from 'vuex';
window.Vue = require('vue');
Vue.use(Vuex);

import globalModule	from './store';


export default new Vuex.Store({
    modules: {
        globalModule,
    },
});
