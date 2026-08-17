<template>
	<div class="auth-root">

		<!-- ── Left panel — branded hero ──────────────────────────── -->
		<div class="auth-hero" :style="heroBg">
			<div class="hero-overlay" />
			<div class="hero-content">
				<img :src="logo" alt="Logo" class="hero-logo" />
				<h1 class="hero-headline">Enterprise Learning Portal</h1>
				<p class="hero-sub">
					Empower your workforce with world-class learning experiences.
				</p>

				<!-- Feature pills -->
				<div class="hero-pills">
					<span v-for="pill in pills" :key="pill.icon" class="hero-pill">
						<span :class="[pill.icon, 'size-3.5']" />
						{{ pill.label }}
					</span>
				</div>
			</div>
		</div>

		<!-- ── Right panel — auth card ────────────────────────────── -->
		<div class="auth-panel">
			<div class="auth-card">

				<!-- Mobile logo -->
				<div class="mobile-logo">
					<img :src="logo" alt="Logo" class="h-12 w-auto object-contain" />
				</div>

				<!-- Tab switcher -->
				<div class="tab-bar" role="tablist">
					<button
						id="tab-login"
						role="tab"
						:aria-selected="mode === 'login'"
						class="tab-btn"
						:class="{ active: mode === 'login' }"
						@click="switchMode('login')"
					>
						Sign In
					</button>
					<button
						id="tab-signup"
						role="tab"
						:aria-selected="mode === 'signup'"
						class="tab-btn"
						:class="{ active: mode === 'signup' }"
						@click="switchMode('signup')"
					>
						Sign Up
					</button>
					<!-- animated indicator -->
					<span
						class="tab-indicator"
						:style="{ transform: (mode === 'signup') ? 'translateX(100%)' : 'translateX(0)' }"
					/>
				</div>

				<!-- Forgot password back link (only shown in forgot mode) -->
				<div v-if="mode === 'forgot'" class="forgot-back">
					<button type="button" class="back-btn" @click="switchMode('login')">
						<span class="lucide-arrow-left size-3.5" />
						Back to Sign In
					</button>
				</div>

				<!-- ── Sign-In Form ─────────────────────────── -->
				<form v-if="mode === 'login'" id="form-login" @submit.prevent="login" class="auth-form">
					<h2 class="form-title">Welcome back</h2>
					<p class="form-subtitle">Sign in to your account to continue learning.</p>

					<!-- Email / Username -->
					<div class="field-group">
						<label for="login-user" class="field-label">Email or Username</label>
						<div class="input-wrap">
							<span class="lucide-user input-icon" />
							<input
								id="login-user"
								v-model="loginForm.username"
								type="text"
								placeholder="you@example.com"
								autocomplete="username"
								class="field-input"
								required
							/>
						</div>
					</div>

					<!-- Password -->
					<div class="field-group">
						<label for="login-pass" class="field-label">Password</label>
						<div class="input-wrap">
							<span class="lucide-lock input-icon" />
							<input
								id="login-pass"
								v-model="loginForm.password"
								:type="showLoginPwd ? 'text' : 'password'"
								placeholder="Enter your password"
								autocomplete="current-password"
								class="field-input pr-11"
								required
							/>
							<button
								type="button"
								class="eye-btn"
								:aria-label="showLoginPwd ? 'Hide password' : 'Show password'"
								@click="showLoginPwd = !showLoginPwd"
							>
								<span :class="showLoginPwd ? 'lucide-eye-off' : 'lucide-eye'" class="size-4" />
							</button>
						</div>
					</div>

					<!-- Error -->
					<div v-if="loginError" class="alert-error" role="alert">
						<span class="lucide-circle-alert size-4 flex-shrink-0" />
						{{ loginError }}
					</div>

					<button type="submit" class="btn-primary" :disabled="loginLoading">
						<span v-if="loginLoading" class="lucide-loader-circle size-4 btn-spinner" />
						<span>{{ loginLoading ? 'Signing in…' : 'Sign In' }}</span>
					</button>

					<!-- Forgot password link -->
					<div class="forgot-link-wrap">
						<button type="button" class="forgot-link" @click="switchMode('forgot')">
							<span class="lucide-key-round size-3" />
							Forgot your password?
						</button>
					</div>

					<p class="switch-hint">
						Don't have an account?
						<button type="button" class="switch-link" @click="switchMode('signup')">Create one →</button>
					</p>
				</form>

				<!-- ── Forgot Password Form ──────────────────── -->
				<form v-else-if="mode === 'forgot'" id="form-forgot" @submit.prevent="forgotPassword" class="auth-form">
					<h2 class="form-title">Reset your password</h2>
					<p class="form-subtitle">Enter your email and we'll send you a reset link.</p>

					<!-- Success state -->
					<div v-if="forgotSuccess" class="alert-success" role="status">
						<span class="lucide-mail-check size-5 flex-shrink-0 text-emerald-600" />
						<div>
							<p class="font-semibold text-emerald-800">Check your inbox!</p>
							<p class="text-sm text-emerald-700 mt-0.5">
								We sent a password reset link to <strong>{{ forgotEmail }}</strong>.
								Click it to set a new password.
							</p>
						</div>
					</div>

					<template v-else>
						<div class="field-group">
							<label for="forgot-email" class="field-label">Email Address</label>
							<div class="input-wrap">
								<span class="lucide-mail input-icon" />
								<input
									id="forgot-email"
									v-model="forgotEmail"
									type="email"
									placeholder="you@example.com"
									autocomplete="email"
									class="field-input"
									required
								/>
							</div>
						</div>

						<div v-if="forgotError" class="alert-error" role="alert">
							<span class="lucide-circle-alert size-4 flex-shrink-0" />
							{{ forgotError }}
						</div>

						<button type="submit" class="btn-primary" :disabled="forgotLoading">
							<span v-if="forgotLoading" class="lucide-loader-circle size-4 btn-spinner" />
							<span>{{ forgotLoading ? 'Sending…' : 'Send Reset Link' }}</span>
						</button>
					</template>

					<p class="switch-hint">
						Remembered it?
						<button type="button" class="switch-link" @click="switchMode('login')">Sign in →</button>
					</p>
				</form>

				<!-- ── Sign-Up Form ─────────────────────────── -->
				<form v-else id="form-signup" @submit.prevent="signup" class="auth-form">
					<h2 class="form-title">Create your account</h2>
					<p class="form-subtitle">Join the Enterprise Learning Portal today.</p>

					<!-- Success state -->
					<div v-if="signupSuccess" class="alert-success" role="status">
						<span class="lucide-mail-check size-5 flex-shrink-0 text-emerald-600" />
						<div>
							<p class="font-semibold text-emerald-800">Check your inbox!</p>
							<p class="text-sm text-emerald-700 mt-0.5">
								We sent a verification link to <strong>{{ signupForm.email }}</strong>.
								Click it to activate your account.
							</p>
						</div>
					</div>

					<template v-else>
						<!-- Full Name -->
						<div class="field-group">
							<label for="signup-name" class="field-label">Full Name</label>
							<div class="input-wrap">
								<span class="lucide-circle-user input-icon" />
								<input
									id="signup-name"
									v-model="signupForm.fullName"
									type="text"
									placeholder="Your full name"
									autocomplete="name"
									class="field-input"
									required
								/>
							</div>
						</div>

						<!-- Email -->
						<div class="field-group">
							<label for="signup-email" class="field-label">Email</label>
							<div class="input-wrap">
								<span class="lucide-mail input-icon" />
								<input
									id="signup-email"
									v-model="signupForm.email"
									type="email"
									placeholder="you@example.com"
									autocomplete="email"
									class="field-input"
									required
								/>
							</div>
						</div>

						<!-- Password -->
						<div class="field-group">
							<label for="signup-pass" class="field-label">Password</label>
							<div class="input-wrap">
								<span class="lucide-lock input-icon" />
								<input
									id="signup-pass"
									v-model="signupForm.password"
									:type="showSignupPwd ? 'text' : 'password'"
									placeholder="At least 8 characters"
									autocomplete="new-password"
									class="field-input pr-11"
									required
								/>
								<button
									type="button"
									class="eye-btn"
									:aria-label="showSignupPwd ? 'Hide password' : 'Show password'"
									@click="showSignupPwd = !showSignupPwd"
								>
									<span :class="showSignupPwd ? 'lucide-eye-off' : 'lucide-eye'" class="size-4" />
								</button>
							</div>
						</div>

						<!-- Confirm Password -->
						<div class="field-group">
							<label for="signup-confirm" class="field-label">Confirm Password</label>
							<div class="input-wrap">
								<span class="lucide-shield-check input-icon" />
								<input
									id="signup-confirm"
									v-model="signupForm.confirmPassword"
									:type="showSignupPwd ? 'text' : 'password'"
									placeholder="Repeat your password"
									autocomplete="new-password"
									class="field-input"
									required
								/>
							</div>
						</div>

						<!-- Error -->
						<div v-if="signupError" class="alert-error" role="alert">
							<span class="lucide-circle-alert size-4 flex-shrink-0" />
							{{ signupError }}
						</div>

						<button type="submit" class="btn-primary" :disabled="signupLoading">
							<span v-if="signupLoading" class="lucide-loader-circle size-4 btn-spinner" />
							<span>{{ signupLoading ? 'Creating account…' : 'Create Account' }}</span>
						</button>
					</template>

					<p class="switch-hint">
						Already have an account?
						<button type="button" class="switch-link" @click="switchMode('login')">Sign in →</button>
					</p>
				</form>

				<!-- Footer -->
				<p class="card-footer">Khadi &amp; Village Industries Commission · Enterprise Learning Portal</p>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { call } from 'frappe-ui'

import navbarBg from '@/assets/navbar-bg.png'
import logo from '@/assets/Khadi_logo_header.png'

const route = useRoute()

// ── Hero ─────────────────────────────────────────────────────────────
const heroBg = {
	backgroundImage: `url(${navbarBg})`,
	backgroundSize: 'cover',
	backgroundPosition: 'center',
}

const pills = [
	{ icon: 'lucide-book-open',   label: 'Structured Courses' },
	{ icon: 'lucide-users',       label: 'Team Collaboration' },
	{ icon: 'lucide-award',       label: 'Certified Learning' },
	{ icon: 'lucide-trending-up', label: 'Progress Tracking'  },
]

// ── Mode ──────────────────────────────────────────────────────────────
type Mode = 'login' | 'signup' | 'forgot'
const mode = ref<Mode>('login')

onMounted(() => {
	if (route.query.mode === 'signup') mode.value = 'signup'
})

function switchMode(m: Mode) {
	mode.value         = m
	loginError.value   = ''
	signupError.value  = ''
	forgotError.value  = ''
	forgotSuccess.value = false
}

// ── Login ─────────────────────────────────────────────────────────────
const loginForm    = reactive({ username: '', password: '' })
const loginLoading = ref(false)
const loginError   = ref('')
const showLoginPwd = ref(false)

const login = async () => {
	loginError.value   = ''
	loginLoading.value = true
	try {
		await call('login', { usr: loginForm.username, pwd: loginForm.password })
		const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : '/lms/'
		window.location.href = redirect
	} catch (err: any) {
		loginError.value = err?.messages?.[0] || err?.message || 'Invalid username or password.'
	} finally {
		loginLoading.value = false
	}
}

// ── Signup ────────────────────────────────────────────────────────────
const signupForm    = reactive({ fullName: '', email: '', password: '', confirmPassword: '' })
const signupLoading = ref(false)
const signupError   = ref('')
const signupSuccess = ref(false)
const showSignupPwd = ref(false)

const signup = async () => {
	signupError.value = ''

	if (signupForm.password !== signupForm.confirmPassword) {
		signupError.value = 'Passwords do not match.'
		return
	}
	if (signupForm.password.length < 8) {
		signupError.value = 'Password must be at least 8 characters.'
		return
	}

	signupLoading.value = true
	try {
		// Create account with the chosen password — no email verification needed
		await call('lms.lms.api.enterprise_sign_up', {
			email:     signupForm.email,
			full_name: signupForm.fullName,
			password:  signupForm.password,
		})

		// Auto-login immediately after account creation
		await call('login', { usr: signupForm.email, pwd: signupForm.password })
		window.location.href = '/lms/'
	} catch (err: any) {
		signupError.value = err?.messages?.[0] || err?.message || 'Could not create account. Please try again.'
	} finally {
		signupLoading.value = false
	}
}

// ── Forgot Password ─────────────────────────────────────────
const forgotEmail   = ref('')
const forgotLoading = ref(false)
const forgotError   = ref('')
const forgotSuccess = ref(false)

const forgotPassword = async () => {
	forgotError.value   = ''
	forgotLoading.value = true
	try {
		await call('frappe.core.doctype.user.user.reset_password', {
			user: forgotEmail.value,
		})
		forgotSuccess.value = true
	} catch (err: any) {
		// Frappe returns a success-like response even for unknown emails
		// (to prevent user enumeration), so we treat most errors as success.
		const msg = err?.messages?.[0] || err?.message || ''
		if (msg.toLowerCase().includes('not found') || msg.toLowerCase().includes('no user')) {
			forgotError.value = 'No account found with that email address.'
		} else {
			// Treat as success — Frappe may return 200 with a message
			forgotSuccess.value = true
		}
	} finally {
		forgotLoading.value = false
	}
}
</script>

<style scoped>
/* ── Root layout ────────────────────────────────────────────────── */
.auth-root {
	display: flex;
	min-height: 100vh;
	width: 100%;
}

/* ── Left hero panel ────────────────────────────────────────────── */
.auth-hero {
	position: relative;
	flex: 1;
	display: none;
}
@media (min-width: 1024px) {
	.auth-hero { display: flex; }
}
.hero-overlay {
	position: absolute; inset: 0;
	background: linear-gradient(135deg, rgba(5,46,22,0.82) 0%, rgba(6,78,59,0.68) 100%);
}
.hero-content {
	position: relative; z-index: 1;
	display: flex; flex-direction: column; justify-content: center;
	padding: 64px 56px;
	color: #fff;
}
.hero-logo {
	height: 72px; width: auto; object-fit: contain;
	margin-bottom: 40px;
	filter: brightness(0) invert(1);
}
.hero-headline {
	font-size: 2.25rem; font-weight: 800; line-height: 1.2;
	margin-bottom: 16px;
}
.hero-sub {
	font-size: 1rem; color: rgba(255,255,255,0.75);
	max-width: 380px; line-height: 1.6; margin-bottom: 36px;
}
.hero-pills { display: flex; flex-wrap: wrap; gap: 10px; }
.hero-pill {
	display: inline-flex; align-items: center; gap: 6px;
	background: rgba(255,255,255,0.14);
	border: 1px solid rgba(255,255,255,0.25);
	backdrop-filter: blur(8px);
	padding: 6px 14px; border-radius: 999px;
	font-size: 0.78rem; font-weight: 600; color: #fff;
}

/* ── Right auth panel ───────────────────────────────────────────── */
.auth-panel {
	width: 100%;
	display: flex; align-items: center; justify-content: center;
	background: #f8fafc;
	padding: 32px 16px;
	overflow-y: auto;
}
@media (min-width: 1024px) {
	.auth-panel { width: 480px; flex-shrink: 0; }
}
.auth-card {
	width: 100%; max-width: 440px;
	background: #fff;
	border-radius: 20px;
	border: 1px solid #e5e7eb;
	box-shadow: 0 4px 32px rgba(0,0,0,0.08);
	padding: 32px;
}

/* Mobile logo */
.mobile-logo { display: flex; justify-content: center; margin-bottom: 24px; }
@media (min-width: 1024px) { .mobile-logo { display: none; } }

/* ── Tab bar ────────────────────────────────────────────────────── */
.tab-bar {
	position: relative;
	display: grid; grid-template-columns: 1fr 1fr;
	background: #f3f4f6; border-radius: 10px;
	padding: 4px;
	margin-bottom: 28px;
}
.tab-btn {
	position: relative; z-index: 1;
	padding: 9px 0; border-radius: 7px;
	font-size: 0.875rem; font-weight: 600; color: #6b7280;
	background: transparent; border: none; cursor: pointer;
	transition: color 0.2s ease;
}
.tab-btn.active { color: #111827; }
.tab-indicator {
	position: absolute; top: 4px; bottom: 4px;
	width: calc(50% - 4px); left: 4px;
	background: #fff;
	border-radius: 7px;
	box-shadow: 0 1px 4px rgba(0,0,0,0.10);
	transition: transform 0.25s cubic-bezier(0.4,0,0.2,1);
}

/* ── Form ───────────────────────────────────────────────────────── */
.auth-form { display: flex; flex-direction: column; gap: 16px; }
.form-title    { font-size: 1.375rem; font-weight: 800; color: #111827; }
.form-subtitle { font-size: 0.8125rem; color: #6b7280; margin-top: 2px; }

.field-group { display: flex; flex-direction: column; gap: 6px; }
.field-label { font-size: 0.8125rem; font-weight: 600; color: #374151; }

.input-wrap   { position: relative; }
.input-icon {
	position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
	width: 16px; height: 16px; color: #9ca3af;
}
.field-input {
	width: 100%;
	padding: 11px 12px 11px 38px;
	border: 1px solid #d1d5db; border-radius: 10px;
	font-size: 0.875rem; background: #fff; color: #111827;
	outline: none;
	transition: border-color 0.2s ease, box-shadow 0.2s ease;
}
.field-input:focus {
	border-color: #059669;
	box-shadow: 0 0 0 3px rgba(5,150,105,0.12);
}
.eye-btn {
	position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
	color: #9ca3af; background: none; border: none; cursor: pointer; padding: 0;
	transition: color 0.15s ease;
}
.eye-btn:hover { color: #4b5563; }

/* ── Alerts ─────────────────────────────────────────────────────── */
.alert-error {
	display: flex; align-items: flex-start; gap: 8px;
	background: #fef2f2; border: 1px solid #fecaca;
	border-radius: 10px; padding: 10px 12px;
	font-size: 0.8125rem; color: #b91c1c;
}
.alert-success {
	display: flex; align-items: flex-start; gap: 10px;
	background: #ecfdf5; border: 1px solid #a7f3d0;
	border-radius: 10px; padding: 14px;
}

/* ── CTA button ─────────────────────────────────────────────────── */
.btn-primary {
	display: flex; align-items: center; justify-content: center; gap: 8px;
	width: 100%; padding: 12px;
	background: linear-gradient(135deg, #059669 0%, #047857 100%);
	color: #fff; font-size: 0.9375rem; font-weight: 700;
	border: none; border-radius: 10px; cursor: pointer;
	box-shadow: 0 2px 8px rgba(5,150,105,0.28);
	transition: opacity 0.2s ease, box-shadow 0.2s ease, transform 0.15s ease;
}
.btn-primary:hover:not(:disabled) {
	opacity: 0.92; transform: translateY(-1px);
	box-shadow: 0 4px 16px rgba(5,150,105,0.34);
}
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }

/* ── Switch hint ────────────────────────────────────────────────── */
.switch-hint { text-align: center; font-size: 0.8125rem; color: #6b7280; }
.switch-link {
	color: #059669; font-weight: 600;
	background: none; border: none; cursor: pointer; padding: 0;
	transition: color 0.15s ease;
}
.switch-link:hover { color: #047857; }

/* ── Card footer ────────────────────────────────────────────────── */
.card-footer {
	margin-top: 20px; text-align: center;
	font-size: 0.7rem; color: #9ca3af;
}

/* ── Spinner ────────────────────────────────────────────────────── */
@keyframes btn-spin { to { transform: rotate(360deg); } }
.btn-spinner { animation: btn-spin 0.8s linear infinite; }

/* ── Forgot password link ───────────────────────────────────────── */
.forgot-link-wrap {
	text-align: center;
}
.forgot-link {
	display: inline-flex; align-items: center; gap: 4px;
	font-size: 0.78rem; color: #6b7280; font-weight: 500;
	background: none; border: none; cursor: pointer; padding: 0;
	transition: color 0.15s ease;
}
.forgot-link:hover { color: #059669; }

/* ── Back button (forgot → login) ───────────────────────────────── */
.forgot-back {
	margin-bottom: 12px;
}
.back-btn {
	display: inline-flex; align-items: center; gap: 5px;
	font-size: 0.78rem; font-weight: 600; color: #6b7280;
	background: none; border: none; cursor: pointer; padding: 0;
	transition: color 0.15s ease;
}
.back-btn:hover { color: #111827; }
</style>
