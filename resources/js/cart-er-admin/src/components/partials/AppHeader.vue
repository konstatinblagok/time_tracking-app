<template lang="html">
  <b-navbar class="fixed-top" toggleable="md" type="dark" variant="info">
    <div class="text-center navbar-brand-wrapper d-flex align-items-top justify-content-center">
      <a class="navbar-brand brand-logo" href="/demo/star-admin-vue/"><img src="../../assets/images/logo.svg" alt="logo"/></a>
      <a class="navbar-brand brand-logo-mini" href="/demo/star-admin-vue/"><img src="../../assets/images/logo-mini.svg" alt="logo"/></a>
    </div>
    <div class="navbar-menu-wrapper d-flex align-items-center ml-auto ml-lg-0">
      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <b-nav-item-dropdown right class="preview-list">
          <template slot="button-content">
            <img src="../../assets/images/faces/face4.jpg" alt="profile image"  class="img-xs rounded-circle">
          </template>
          <b-dropdown-item href="#" class="preview-item flex-wrap">Profile</b-dropdown-item>
          <b-dropdown-item href="#" class="preview-item flex-wrap">Signout</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>
      <button class="navbar-toggler navbar-toggler-right align-self-center" type="button" @click="collapedMobileSidebar()">
        <span class="mdi mdi-menu"></span>
      </button>
    </div>
  </b-navbar>
</template>

<script lang="js">
export default {
  name: 'app-header',
  methods: {
    collapedMobileSidebar: () => {
      document.querySelector('.sidebar').classList.toggle('active')
    }
  }
}
</script>

<style scoped lang="scss">
.app-header {
}
</style>
