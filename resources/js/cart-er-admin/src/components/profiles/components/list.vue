<template lang="html">
    <section class="tables">
        <div class="row">
            <div class="col-12 grid-margin">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-8">
                                <h5 class="card-title mb-4">User Profiles</h5>
                            </div>
                            <div class="col-4">

                            </div>
                        </div>

                        <div  class="table-responsive">
                            <table id="profilesList" class="table center-aligned-table">
                                <thead>
                                <tr>
                                    <th class="border-bottom-0">Sr.No</th>
                                    <th class="border-bottom-0">User Name</th>
                                    <th class="border-bottom-0">Email Id</th>
                                    <th class="border-bottom-0">Phone Number</th>
                                    <th class="border-bottom-0">Location</th>
                                    <th class="border-bottom-0">Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr v-for="objProfile in this.arrobjProfiles" >
                                    <td>{{ objProfile.id }}</td>
                                    <td>{{ objProfile.username }}</td>
                                    <td>{{ objProfile.email }}</td>
                                    <td>{{ objProfile.phone_number}}</td>
                                    <td>{{ objProfile.location }}</td>
                                    <td><b-button variant="primary" class=""><router-link class="nav-link text-white" :to="'/profile/edit/'+objProfile.id">Edit User</router-link></b-button></td>
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
        name: 'profiles',
        data () {
            return {
                columns: [
                    {label: 'Sr no', field: 'id'},
                    {label: 'User Name', field: 'username'},
                    {label: 'Email ID', field: 'email'},
                    {label: 'Phone no.', field: 'phone_number'},
                    {label: 'Location', field: 'location'}
                ],
                rows:null,
                arrobjProfiles:null
            }
        },
        created() {
            this.getProfileList();

        },
        methods:{
            // getProfileList() {
            //     this.$store.dispatch('getProfileList');
            // },
            getProfileList() {
                axios.get('/api/admin/profiles')
                    .then(response => {
                        this.arrobjProfiles = response.data;
                        this.rows = response.data;
                        $(document).ready(function() {
                            $('#profilesList').DataTable();
                        } );
                        if(response.status == 200){
                            this.arrobjProfiles.each((item) => {
                                console.log(item);
                                this.rows.push(item)
                            });

                        }
                    }).catch(error => {
                    console.log(error)
                })
            },
        },
        computed: {
            ...mapState([
                'arrProfile',
            ]),
        },
    }

</script>

<style scoped lang="scss">
    .tables {

    }
</style>
