import deliveryList from './components/list'
import deliveryCreate from './components/create'

const deliveryRouter = [
    {
        path: '/delivery',
        name: 'delivery',
        component: deliveryList,
        meta: { requiresAuth: true }
    },
    {
        path: '/delivery/edit/:id',
        name: 'deliverycreate',
        component: deliveryCreate,
        meta: { requiresAuth: true }
    }
]

export  default  deliveryRouter