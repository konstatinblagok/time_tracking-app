<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <div>
                            <b-card no-body>
                                <form  method="POST" role="form">

                                    <h3 class="tile-title">Social Links</h3>
                                    <hr>
                                    <div class="tile-body">
                                        <div class="form-group">
                                            <label class="control-label" for="social_facebook">Facebook Profile</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter facebook profile link"
                                                id="social_facebook"
                                                name="social_facebook"

                                            />
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="social_twitter">Twitter Profile</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter twitter profile link"
                                                id="social_twitter"
                                                name="social_twitter"

                                            />
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="social_instagram">Instagram Profile</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter instagram profile link"
                                                id="social_instagram"
                                                name="social_instagram"

                                            />
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="social_linkedin">LinkedIn Profile</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter linkedin profile link"
                                                id="social_linkedin"
                                                name="social_linkedin"

                                            />
                                        </div>
                                    </div>
                                    <div class="tile-footer">
                                        <div class="row d-print-none mt-2">
                                            <div class="col-12 text-right">
                                                <button class="btn btn-success" type="submit"><i class="fa fa-fw fa-lg fa-check-circle"></i>Update Settings</button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </b-card>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</template>
<script>
    import general from "./general";

    export default {
        name: 'Social Links',
        data() {
            return {

            };
        },

        computed: {},
        components: {
            'general-setting':general
        },
        methods: {
            addProduct() {
                this.$store.dispatch('addNewProduct', this.objProduct)
            },

            selectFile(event) {
                // `files` is always an array because the file input may be in multiple mode
                // this.image = event.target.files[0].name;
                this.image = '';
            }

        }
    };

</script>
<style scoped>

</style>
