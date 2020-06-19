import Vue from 'vue';
import Vant from 'vant';
import 'vant/lib/index.css';
import 'normalize.css'
import router from './router'
import App from './App.vue'
import 'lib-flexible/flexible'
Vue.config.productionTip = false
Vue.use(Vant);

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
