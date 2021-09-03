<template lang="html">

  <section class="app-sidebar">
    <nav class="sidebar sidebar-offcanvas" id="sidebar">
      <ul class="nav">
        <li class="nav-item nav-profile">
          <div class="nav-link">
             <!--<div class="profile-image">-->
             <!--<img src="../../assets/images/faces/face4.jpg" alt="image"/>&ndash;&gt;-->
              <!--<span class="online-status online"></span>-->
            <!--</div>-->
            <div class="profile-name">
              <!--<p class="name">Richard V.Welsh</p>-->
              <!--<p class="designation">Manager</p>-->
              <!--<div class="badge badge-teal mx-auto mt-3">Online</div>-->
            </div>
          </div>
        </li>

        <!--<li class="nav-item"><router-link class="nav-link" to="/dashboard"><img class="menu-icon" src="../../assets/images/menu_icons/01.png" alt="menu icon"><span class="menu-title">Dashboard</span></router-link></li>-->
        <li class="nav-item"><router-link class="nav-link" to="/delivery"><img class="menu-icon" src="../../assets/images/menu_icons/01.png" alt="menu icon"><span class="menu-title">Delivery</span></router-link></li>
        <li class="nav-item"><router-link class="nav-link" to="/checkouts"><img class="menu-icon" src="../../assets/images/menu_icons/01.png" alt="menu icon"><span class="menu-title">Checkouts</span></router-link></li>
        <li class="nav-item"><router-link class="nav-link" to="/profiles"><img class="menu-icon" src="../../assets/images/menu_icons/01.png" alt="menu icon"><span class="menu-title">User Profile</span></router-link></li>
        <!--<li class="nav-item"><router-link class="nav-link" to="/login"><img class="menu-icon" src="../../assets/images/menu_icons/01.png" alt="menu icon"><span class="menu-title">login</span></router-link></li>-->
      </ul>
    </nav>
  </section>

</template>

<script lang="js">
export default {
  name: 'app-sidebar'
}
</script>

<style scoped lang="scss">
.app-sidebar {

}
</style>
