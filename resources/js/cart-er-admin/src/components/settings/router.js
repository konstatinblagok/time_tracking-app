import settings from './components/settings'

const settingRouter = [
    {
        path: '/settings',
        name: 'Settings',
        component: settings,
        meta: { requiresAuth: true }
    },
]

export  default  settingRouter
