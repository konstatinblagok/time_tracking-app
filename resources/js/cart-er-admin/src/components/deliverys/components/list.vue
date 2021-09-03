<template lang="html">
    <section class="tables">
        <div class="row">
            <div class="col-12 grid-margin">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-8">
                                <h5 class="card-title mb-4">Delivery</h5>
                            </div>
                            <div class="col-4">
                                <!--<b-button variant="primary" class="pull-right"><router-link class="nav-link text-white" to="/deliverys/add">Add Deliverys</router-link></b-button>-->
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table id="deliveryList" class="table center-aligned-table">
                                <thead>
                                <tr>
                                    <th class="border-bottom-0">Sr. No</th>
                                    <th class="border-bottom-0">Receiver Name</th>
                                    <th class="border-bottom-0">Mobile Number</th>
                                    <th class="border-bottom-0">Location</th>
                                    <th class="border-bottom-0">Note</th>
                                    <th class="border-bottom-0">Time for Delivery</th>
                                    <th class="border-bottom-0">Status</th>
                                    <th class="border-bottom-0">Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr v-for="objDelivery in arrShippingDetail" >
                                    <td>{{ objDelivery.id }}</td>
                                    <td>{{ objDelivery.receiver_name }}</td>
                                    <td>{{ objDelivery.phone_number }}</td>
                                    <td>{{ objDelivery.location }}</td>
                                    <td>{{ objDelivery.note }}</td>
                                    <td>{{ objDelivery.ETA }}</td>
                                    <td>{{ objDelivery.status== 0 ? 'In progress':'Completed' }}</td>
                                    <td> <b-button variant="primary" class=""><router-link class="nav-link text-white" :to="'/delivery/edit/'+objDelivery.id">View</router-link></b-button></td>

                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</template>
<script lang="js">
    import { mapState } from 'vuex';
    export default {
        name: 'delivery',
        data () {
            return {

            }
        },
        created() {
            this.getDeliveryList();
        },
        methods:{
            getDeliveryList() {
                this.$store.dispatch('getDeliveryList').then(()=>{
                    $(document).ready(function() {
                        $('#deliveryList').DataTable();
                    } );
                });
            }
        },
        computed: {
            ...mapState([
                'arrShippingDetail',
            ]),
        },
    }

</script>

<style scoped lang="scss">
    .tables {

    }
</style>
