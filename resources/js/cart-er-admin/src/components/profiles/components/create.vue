<template lang="html">
    <div>
        <section class="forms">
            <div class="row">
                <div class="col-md-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Add New User</h4>
                            <b-form-group label="Name" label-for="input5">
                                <b-form-input type="text" v-model="objProfile.name" id="name"
                                              placeholder="Name"></b-form-input>
                            </b-form-group>
                            <b-form-group label="Email" label-for="input5">
                                <b-form-input type="text" v-model="objProfile.email" id="email"
                                              placeholder="Email Id"></b-form-input>
                            </b-form-group>
                            <!--<b-form-group label="Password" label-for="input5">-->
                                <!--<b-form-input type="text" v-model="objProfile.password" id="password"-->
                                              <!--placeholder="Password"></b-form-input>-->
                            <!--</b-form-group>-->
                            <b-form-group label="Phone" label-for="input5">
                                <b-form-input type="number" v-model="objProfile.phone_number" id="phone_number"
                                              placeholder="Phone Number"></b-form-input>
                            </b-form-group>
    <!--                        <b-form-group label="Location" label-for="input10">-->
    <!--                            <textarea id="location" v-model="objProfile.location" class="form-control"-->
    <!--                                      rows="6"></textarea>-->
    <!--                        </b-form-group>-->
                            <b-form-group label="Location" label-for="input5">
                                <b-form-input type="text" v-model="objProfile.location" disabled id="Location"
                                              placeholder="Location"></b-form-input>
                            </b-form-group>
                            <!--<b-form-group label="Card" label-for="input5">-->
                                <!--<b-form-input type="text" v-model="objProfile.card_number" id="card_number"-->
                                              <!--placeholder="Card Number"></b-form-input>-->
                            <!--</b-form-group>-->

                            <b-form-group label="Tracking Codes" label-for="input5">
                                <b-form-input type="number" v-model="objProfile.tracking_codes" id="card_number"
                                              placeholder="Tracking codes"></b-form-input>
                            </b-form-group>

                                <b-form-group horizontal label="Notifications">
                                    <b-form-radio-group id="on" v-model="objProfile.is_notification" name="radioSubComponent">
                                        <b-form-radio value="1">On</b-form-radio>
                                        <b-form-radio value="0">Off</b-form-radio>
                                    </b-form-radio-group>
                                </b-form-group>

                            <!--<b-form-group label="Upload file" label-for="files">-->
                                <!--<b-form-file v-model="objProfile.image" id="files" :state="(objProfile.image)" v-on:change="onImageChange" placeholder="Choose a file..."></b-form-file>-->
                            <!--</b-form-group>-->
                            <b-button type="submit" variant="success" class="mr-2" @click="addProfile()">Submit</b-button>
                            <b-button variant="light">Cancel</b-button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="card">
            <div class="card-body">
                <h4 class="card-title">Checkouts</h4>
                <div class="table-responsive">
                    <table id="checkoutList" class="table center-aligned-table">
                <thead>
                <tr>
                    <th class="border-bottom-0">Sr.No</th>
                    <th class="border-bottom-0">Last 4 digit</th>
                    <th class="border-bottom-0">Method</th>
                    <th class="border-bottom-0">Status</th>
                    <th class="border-bottom-0">Amount</th>
                    <th class="border-bottom-0">Tracking Codes</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="checkouts in objProfile.checkouts" >
                    <td>{{ checkouts.id }}</td>
                    <td>{{ checkouts._last4Digits}}</td>
                    <td>{{ checkouts.method}}</td>
                    <td>{{ checkouts.status}}</td>
                    <td>{{ checkouts.amount}}</td>
                    <td>{{ checkouts.tracking_codes}}</td>
                </tr>
                </tbody>
            </table>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    // eslint-disable
    import {mapState} from 'vuex'
    import axios from "axios";

    export default {
        name: 'EditUser',
        data() {
            return {
                objProfile: {
                    name: '',
                    phone_number: '',
                    image: null,
                    location: '',
                    card_number: '',
                    password: '',
                    email: '',
                    is_notification:'',
                    tracking_codes:'',
                    checkouts:{}
                },
                errors: [],
            };
        },
        created() {
            this.getProfile();
        },
        computed: {},
        components: {},
        methods: {
            addProfile() {
                let id= this.$route.params.id
                let url= '/api/admin/profile/'+id
                axios.post(url,{
                    username: this.objProfile.name,
                    email: this.objProfile.email,
                    password: this.objProfile.password,
                    phone_number: this.objProfile.phone_number,
                    is_notification: this.objProfile.is_notification,
                    tracking_codes: this.objProfile.tracking_codes,
                })
                    .then(response => {
                        if(response.status == 200){
                            this.$router.push('/profiles')
                        }
                    }).catch(error => {
                    console.log(error)
                })
            },
            getProfile(){
                let id= this.$route.params.id
                let url= '/api/admin/profile/'+id
                axios.get(url)
                    .then(response => {
                        if(response.status == 200){
                            this.objProfile.name=response.data.username;
                            this.objProfile.email=response.data.email;
                            this.objProfile.phone_number=response.data.phone_number;
                            this.objProfile.location=response.data.location;
                            this.objProfile.is_notification=response.data.is_notification;
                            this.objProfile.tracking_codes=response.data.tracking_codes;
                            this.objProfile.checkouts=response.data.checkouts;
                            $(document).ready(function() {
                                $('#checkoutList').DataTable();
                            });

                        }
                    }).catch(error => {
                    console.log(error)
                })
            },
            onImageChange(e) {
                let files = e.target.files || e.dataTransfer.files;
                if (!files.length)
                    return;
                this.createImage(files[0]);
            },
            createImage(file) {
                let reader = new FileReader();
                let vm = this;
                reader.onload = (e) => {
                    vm.objProfile.image = e.target.result;
                };
                reader.readAsDataURL(file)
            }
        }
    };

</script>
<style scoped>

</style>
