<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">View Shipping Details</h4>
                        <b-form-group label="Sender Name" label-for="sender">
                            <b-form-input type="text" disabled v-model="objDelivery.sender" id="sender"
                                          placeholder="Sender Name"></b-form-input>
                        </b-form-group>
                        <b-form-group label="Receiver Name" disabled label-for="receiver">
                            <b-form-input type="text" v-model="objDelivery.receiver" id="receiver"
                                          placeholder="Receiver Name"></b-form-input>
                        </b-form-group>
                        <b-form-group label="Receiver Phone no." disabled label-for="receiver_no">
                            <b-form-input type="text" v-model="objDelivery.phone_number" id="receiver_no"
                                          placeholder="Receiver Phone no"></b-form-input>
                        </b-form-group>
                        <b-form-group label="Location" label-for="location">
                            <b-form-input type="text" v-model="objDelivery.location" disabled id="location"
                                          placeholder="Location"></b-form-input>
                        </b-form-group>

                         <b-form-group label="Note" label-for="note">
                             <textarea id="note" v-model="objDelivery.note" class="form-control"
                                  rows="6"></textarea>
                         </b-form-group>
                        <!--<b-form-group label="Note" label-for="note">-->
                            <!--<b-form-input type="text" v-model="objDelivery.location" disabled id="Location"-->
                                          <!--placeholder="Location"></b-form-input>-->
                        <!--</b-form-group>-->
                        <b-form-group label="ETA" label-for="eta">
                            <b-form-input type="text" v-model="objDelivery.ETA" disabled id="eta"
                                          placeholder="00:00"></b-form-input>
                        </b-form-group>
                        <b-form-group label="Tracking ID" label-for="tracking_id">
                            <b-form-input type="text" v-model="objDelivery.tracking_id" id="tracking_id" disabled
                                          placeholder="Tracking codes"></b-form-input>
                        </b-form-group>

                    </div>
                </div>
            </div>
        </div>
    </section>

</template>
<script>
    // eslint-disable
    import {mapState} from 'vuex'

    export default {
        name: 'deliverycreate',
        data() {
            return {
                objDelivery: {
                    sender: '',
                    receiver: '',
                    phone_number:'',
                    location: null,
                    note: '',
                    tracking_id: '',
                    Eta: '',
                    status: 0,
                },
                errors: [],
            };
        },

        created() {
            this.getDeliveryDetails();
        },

        methods: {
            save() {
                let id= this.$route.params.id
                let url= '/api/admin/delivery/'+id
                axios.post(url,{
                    username: this.objDelivery.name,
                    email: this.objProfile.email,
                    password: this.objProfile.password,
                    phone_number: this.objProfile.phone_number,
                    is_notification: this.objProfile.is_notification,

                })
                    .then(response => {
                        if(response.status == 200){
                            this.$router.push('/profiles')
                        }
                    }).catch(error => {
                    console.log(error)
                })
            },
            getDeliveryDetails(){
                let id= this.$route.params.id
                let url= '/api/admin/delivery/'+id
                axios.get(url)
                    .then(response => {
                        console.log(response.data.sender);
                        if(response.status == 200){
                            this.objDelivery.sender          =   response.data.sender.username;
                            this.objDelivery.receiver        =   response.data.receiver.username;
                            this.objDelivery.phone_number    =   response.data.phone_number;
                            this.objDelivery.location        =   response.data.location;
                            this.objDelivery.note            =   response.data.note;
                            this.objDelivery.tracking_id     =   response.data.tracking_id;
                            this.objDelivery.ETA             =   response.data.ETA;
                        }
                    }).catch(error => {
                    console.log(error)
                })
            },
        }
    };

</script>
<style scoped>

</style>
