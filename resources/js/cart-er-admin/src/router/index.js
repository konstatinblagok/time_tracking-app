import Vue from 'vue'
import Router from 'vue-router'

// Dashboard Components
import dashboard from '../views/dashboard'
import profileRouter from '../components/profiles/router'
import deliveryRouter from '../components/deliverys/router'
import settingsRouter from '../components/settings/router'


// Widgets
import widgets from '../views/widgets'

// UI Components
import alerts from '../views/ui-components/alerts'
import badges from '../views/ui-components/badges'
import breadcrumbs from '../views/ui-components/breadcrumbs'
import buttons from '../views/ui-components/buttons'
import carousel from '../views/ui-components/carousel'
import dropdowns from '../views/ui-components/dropdowns'
import icons from '../views/ui-components/icons'
import modals from '../views/ui-components/modals'
import paginations from '../views/ui-components/paginations'
import progress from '../views/ui-components/progress'
import tables from '../views/ui-components/tables'
import typography from '../views/ui-components/typography'
import tabs from '../views/ui-components/tabs'
import tooltips from '../views/ui-components/tooltips'

// Form Components
import forms from '../views/forms/forms'

// Sample Pages
import error404 from '../views/sample-pages/error-404'
import error500 from '../views/sample-pages/error-500'
import login from '../components/login'
import register from '../views/sample-pages/register'

Vue.use(Router)


const routes =  [

  {
    path: '/dashboard',
    name: 'dashboard',
    component: dashboard,
    meta: { requiresAuth: true }
  },
  {
    path: '/widgets',
    name: 'widgets',
    component: widgets,
    meta: { requiresAuth: true }
  },
  {
    path: '/404',
    name: 'error-404',
    component: error404
  },
  {
    path: '/500',
    name: 'error-500',
    component: error500
  },
  {
    path: '/login',
    name: 'login',
    component: login
  },
  {
    path: '/register',
    name: 'register',
    component: register,
    meta: { requiresAuth: true }
  },
  {
    path: '/alerts',
    name: 'alerts',
    component: alerts,
    meta: { requiresAuth: true }
  },
  {
    path: '/badges',
    name: 'badges',
    component: badges,
    meta: { requiresAuth: true }
  },
  {
    path: '/breadcrumbs',
    name: 'breadcrumbs',
    component: breadcrumbs,
    meta: { requiresAuth: true }
  },
  {
    path: '/buttons',
    name: 'buttons',
    component: buttons,
    meta: { requiresAuth: true }
  },
  {
    path: '/carousel',
    name: 'carousel',
    component: carousel,
    meta: { requiresAuth: true }
  },
  {
    path: '/dropdowns',
    name: 'dropdowns',
    component: dropdowns,
    meta: { requiresAuth: true }
  },
  {
    path: '/icons',
    name: 'icons',
    component: icons,
    meta: { requiresAuth: true }
  },
  {
    path: '/modals',
    name: 'modals',
    component: modals,
    meta: { requiresAuth: true }
  },
  {
    path: '/paginations',
    name: 'paginations',
    component: paginations,
    meta: { requiresAuth: true }
  },
  {
    path: '/progress',
    name: 'progress',
    component: progress,
    meta: { requiresAuth: true }
  },
  {
    path: '/tables',
    name: 'tables',
    component: tables,
    meta: { requiresAuth: true }
  },
  {
    path: '/typography',
    name: 'typography',
    component: typography,
    meta: { requiresAuth: true }
  },
  {
    path: '/tabs',
    name: 'tabs',
    component: tabs,
    meta: { requiresAuth: true }
  },

  {
    path: '/tooltips',
    name: 'tooltips',
    component: tooltips,
    meta: { requiresAuth: true }
  },
  {
    path: '/forms',
    name: 'forms',
    component: forms
  },
  ...profileRouter,

  ...settingsRouter,
  ...deliveryRouter,
]

 const router = new Router({
  mode: 'history',
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // this route requires auth, check if logged in
    // if not, redirect to login page.
    if (localStorage.getItem('is_logged_in') == true || localStorage.getItem('is_logged_in') == 'true') {
      next()
    } else {
      next({
        name: 'login'
      })
    }
  } else {
    print('sdfsadf');
    next()
  }
})

export default router;


