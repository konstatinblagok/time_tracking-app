<template lang="html">
    <section class="forms">
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <div>
                            <b-card no-body>
                                <form method="POST" role="form">

                                    <h3 class="tile-title">Payment Settings</h3>
                                    <hr>
                                    <div class="tile-body">
                                        <div class="form-group">
                                            <label class="control-label" for="stripe_payment_method">Stripe Payment Method</label>
                                            <select name="stripe_payment_method" id="stripe_payment_method" class="form-control">
                                                <option value="1" >Enabled</option>
                                                <option value="0" >Disabled</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="stripe_key">Key</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter stripe key"
                                                id="stripe_key"
                                                name="stripe_key"

                                            />
                                        </div>
                                        <div class="form-group pb-2">
                                            <label class="control-label" for="stripe_secret_key">Secret Key</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter stripe secret key"
                                                id="stripe_secret_key"
                                                name="stripe_secret_key"

                                            />
                                        </div>
                                        <hr>
                                        <div class="form-group pt-2">
                                            <label class="control-label" for="paypal_payment_method">PayPal Payment Method</label>
                                            <select name="paypal_payment_method" id="paypal_payment_method" class="form-control">
                                                <option value="1" >Enabled</option>
                                                <option value="0">Disabled</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="paypal_client_id">Client ID</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter paypal client Id"
                                                id="paypal_client_id"
                                                name="paypal_client_id"

                                            />
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="paypal_secret_id">Secret ID</label>
                                            <input
                                                class="form-control"
                                                type="text"
                                                placeholder="Enter paypal secret id"
                                                id="paypal_secret_id"
                                                name="paypal_secret_id"
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
        name: 'Payments',
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
