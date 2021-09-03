import profileList from './components/list'
import profilesCreate from './components/create'

const profileRouter = [
    {
        path: '/profiles',
        name: 'profiles',
        component: profileList,
        meta: { requiresAuth: true }
    },
    {
        path: '/profile/edit/:id',
        component: profilesCreate,
        meta: { requiresAuth: true }
    },
]

export  default  profileRouter
