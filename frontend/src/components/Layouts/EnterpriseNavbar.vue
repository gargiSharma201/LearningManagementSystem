<template>
  <header
  class="enterprise-navbar"
  :class="{ 'navbar-scrolled': isScrolled }"
  style="background-color: white;"
>

  <div class="navbar-overlay"></div>
  

    <div class="navbar-inner">

      <!-- LEFT -->
      <div class="navbar-left">
      </div>

      <!-- CENTER -->
      <router-link
        to="/"
        class="navbar-logo"
        style="display: flex; align-items: center; gap: 16px; text-decoration: none;"
      >
        <img
          :src="logo"
          alt="Indian Army LMS"
          class="dashboard-logo"
        />
        <span class="font-robotoCondensed" style="font-size: 1.5rem; font-weight: 800; color: #111827; letter-spacing: -0.025em;">Indian Army Learning Management System</span>
      </router-link>

      <!-- RIGHT -->
      <div class="navbar-right">

        <div class="relative" ref="profileRef">

          <button
            class="avatar-btn"
            @click="toggleProfile"
          >
            <img
              v-if="user?.user_image"
              :src="user.user_image"
              :alt="user.full_name"
              class="avatar-img"
            />

            <span
              v-else
              class="avatar-initials"
            >
              {{ initials }}
            </span>

            <span class="avatar-status"></span>

          </button>

          <!-- KEEP YOUR EXISTING DROPDOWN HERE -->
           <Transition name="dropdown">
  <div
    v-if="profileOpen"
    class="profile-dropdown"
  >
    <!-- User Info -->
    <div class="dropdown-header">
      <div class="flex items-center gap-3">
        <div class="avatar-lg">
          <img
            v-if="user?.user_image"
            :src="user.user_image"
            :alt="user.full_name"
            class="w-full h-full object-cover rounded-full"
          />
          <span
            v-else
            class="avatar-initials text-base"
          >
            {{ initials }}
          </span>
        </div>

        <div class="min-w-0">
          <p class="font-semibold text-gray-900 truncate">
            {{ user?.full_name }}
          </p>

          <p class="text-xs text-gray-500 truncate">
            {{ user?.name }}
          </p>
        </div>
      </div>
    </div>

    <div class="dropdown-divider"></div>

    <!-- Logout -->
    <button
      class="dropdown-item logout-btn"
      @click="logout"
    >
      <span class="lucide-log-out size-4"></span>
      <span>Logout</span>
    </button>

  </div>
</Transition>

        </div>

      </div>

    </div>
  </header>
</template>
<script setup lang="ts">
import { ref, computed, inject, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import navbarBg from '@/assets/navbar-bg.png'
import logo from '@/assets/ArmyLogo.jpg'

const user = inject<any>('$user')
const router = useRouter()

// ── Scroll detection ──────────────────────────────────────────
const isScrolled = ref(false)
const onScroll = () => { isScrolled.value = window.scrollY > 8 }
onMounted(() => window.addEventListener('scroll', onScroll, { passive: true }))
onBeforeUnmount(() => window.removeEventListener('scroll', onScroll))

// ── User initials ─────────────────────────────────────────────
const initials = computed(() => {
  const name: string = user?.full_name || user?.name || 'U'
  return name.split(' ').slice(0, 2).map((w: string) => w[0]?.toUpperCase()).join('')
})

// ── Nav links ─────────────────────────────────────────────────
const navLinks = [
  { label: 'Dashboard', icon: 'lucide-layout-dashboard', to: { name: 'Home' } },
  { label: 'Courses',   icon: 'lucide-book-open',        to: { name: 'Courses' } },
  { label: 'Programs',  icon: 'lucide-layers',           to: { name: 'Programs' } },
  { label: 'Batches',   icon: 'lucide-users',            to: { name: 'Batches' } },
  { label: 'Reports',   icon: 'lucide-bar-chart-2',      to: { name: 'Statistics' } },
]

// ── Profile dropdown ──────────────────────────────────────────
const profileOpen = ref(false)
const profileRef  = ref<HTMLElement | null>(null)
const toggleProfile = () => { profileOpen.value = !profileOpen.value }

const profileMenu = computed(() => [
  { label: 'My Profile',   icon: 'lucide-user-circle',  to: { name: 'ProfileAbout',      params: { username: user?.name } } },
  { label: 'Certificates', icon: 'lucide-award',         to: { name: 'ProfileCertificates', params: { username: user?.name } } },
  { label: 'Statistics',   icon: 'lucide-bar-chart-2',  to: { name: 'Statistics' } },
])

const logout = () => { window.location.href = '/logout' }

const onClickOutside = (e: MouseEvent) => {
  if (profileRef.value && !profileRef.value.contains(e.target as Node)) {
    profileOpen.value = false
  }
}
onMounted(() => document.addEventListener('mousedown', onClickOutside))
onBeforeUnmount(() => document.removeEventListener('mousedown', onClickOutside))

// ── Notifications ─────────────────────────────────────────────
const toggleNotifications = () => {}

// ── Mobile menu ───────────────────────────────────────────────
const mobileMenuOpen = ref(false)

// ── Search ────────────────────────────────────────────────────
const searchQuery = ref('')
const handleSearch = () => {
  if (searchQuery.value.trim()) {
    router.push({ name: 'Courses', query: { search: searchQuery.value.trim() } })
    searchQuery.value = ''
  }
}
</script>

<style scoped>
.enterprise-navbar {

    position: sticky;
    top: 0;
    z-index: 1000;

    height: 110px;

    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;

    border-bottom: 1px solid rgba(255,255,255,.25);

    overflow: visible;
}

.enterprise-navbar::before{

    content:"";

    position:absolute;
    inset:0;

    background: white;

    backdrop-filter:blur(2px);
    -webkit-backdrop-filter:blur(2px);

    pointer-events:none;
}

.navbar-inner{

    position:relative;
    z-index:2;

    height:100%;

    display:grid;
    grid-template-columns:1fr auto 1fr;

    align-items:center;

    padding:0 32px;
}

.navbar-left{
    justify-self:start;
}

.navbar-logo{

    justify-self:center;

    display:flex;
    justify-content:center;
    align-items:center;
}

.dashboard-logo{

    height:88px;

    width:auto;

    object-fit:contain;

    filter:drop-shadow(0 2px 8px rgba(0,0,0,.18));
}

.navbar-right{

    justify-self:end;

    display:flex;
    align-items:center;
}

.avatar-btn{

    width:44px;
    height:44px;

    border-radius:9999px;

    background:white;

    display:flex;
    justify-content:center;
    align-items:center;

    overflow:hidden;

    cursor:pointer;
}
</style>