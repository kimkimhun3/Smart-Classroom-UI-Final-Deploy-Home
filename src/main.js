import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify';
import 'vuejs-dialog/dist/vuejs-dialog.min.css';
import VueChatScroll from 'vue-chat-scroll'
import linkify from 'vue-linkify'

Vue.directive('linkified', linkify)
Vue.use(VueChatScroll)
Vue.config.productionTip = false

new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')
